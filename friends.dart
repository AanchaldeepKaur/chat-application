import 'package:authentication/ChatAPPLICATION/chat.dart';
import 'package:authentication/ChatAPPLICATION/phoneverification.dart';
import 'package:authentication/Providers/provider2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chatting extends StatefulWidget {
  const Chatting({super.key});

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {

  String createRoomId (String myid , String otherid){
    List join = [myid, otherid];
    join.sort();
    var newid = join.join("_");
    return newid.toString();
  }
  Future<void>logoutmethod(context)async{
  await FirebaseAuth.instance.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedin');
  await prefs.remove('phoneNumber');
  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => PhoneChat(),));
}


  @override
  Widget build(BuildContext context) {
    final providers = Provider.of<Providerclass>(context);
    return Scaffold(
      appBar: AppBar(
      //  title: Text('ChattingApp', style: TextStyle(color: Colors.white)),
      title: Consumer<Providerclass>(builder:(context, provider, _) {
        return Text(providers.phoneno,style: TextStyle(color: Colors.white),);
      },),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.camera_alt_outlined, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search_outlined, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
              logoutmethod(context);
            }, icon:Icon(Icons.logout_outlined), color: Colors.white,
          ))
        ],
      ),


      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref().child('UserCredentials').onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            final data = snapshot.data!.snapshot.value;
            if (data is Map<dynamic, dynamic>) {
              final users = data.entries.map((entry) => entry.value).toList();
              final currentUserId = providers.userId;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  if(user["userId"] == currentUserId){
                    return SizedBox.shrink();
                  }
                  var phoneNumber = user['phoneNumber'] ?? 'No phone number';
                //  var userId = user['userId'] ?? 'No user ID';
                 // var chatroomId = createRoomId(currentUserId, user["userId"]);

    
                  return FutureBuilder<DatabaseEvent>(
                  future: providers.getLastMessage(createRoomId(currentUserId, user['userId'])),
                        builder: (context, snapshot) {
                          String lastMessageText = 'No messages yet';
                          String trailingText = '';
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                              final lastMessageMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                              final lastMessageKey = lastMessageMap.keys.first;
                              final lastMessage = lastMessageMap[lastMessageKey] as Map<dynamic, dynamic>;

                              final lastMessageTimestamp = DateTime.fromMillisecondsSinceEpoch(lastMessage['timestamp']);
                              final now = DateTime.now();
                              final difference = now.difference(lastMessageTimestamp).inDays;

                              lastMessageText = lastMessage['text']??"Image";

                              if (difference == 0) {
                                trailingText = DateFormat('h:mm a').format(lastMessageTimestamp);
                              } else {
                                trailingText = DateFormat('EEEE').format(lastMessageTimestamp);
                              }
                            }
                          }

                      return InkWell(
                        onTap: () {
                          var chatroomId = createRoomId(currentUserId, user["userId"]);
                          var otherno = user["phoneNumber"];
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(
                            chatid:chatroomId,
                            otherphone: otherno,
                          )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: Colors.blue, radius: 26),
                          selectedColor: Colors.blue,
                          textColor: const Color.fromARGB(255, 20, 34, 45),
                          contentPadding: EdgeInsets.all(10),
                          title: Text(phoneNumber),
                          subtitle: Text(lastMessageText),
                          trailing: Text(trailingText),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('Unexpected data format'),
              );
            }
          }
        },
      ),
    );
  }
}




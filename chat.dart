import 'dart:io';

import 'package:authentication/ChatAPPLICATION/video.dart';
import 'package:authentication/Providers/provider2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final String chatid;
  final String otherphone;
  const Chat({super.key, required this.chatid, required this.otherphone});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  
  TextEditingController chats = TextEditingController();
  late DatabaseReference messageRef;
  final ScrollController _scrollController = ScrollController();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? selectedphoto;
  final ImagePicker _picker = ImagePicker();


   Future imgFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedphoto = File(pickedFile.path);
        uploadFile(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        selectedphoto = File(pickedFile.path);
        uploadFile(context);
      } else {
        print('No image selected.');
      }
    });
  }

 Future uploadFile(BuildContext context) async {
    if (selectedphoto == null) return;
    final fileName = basename(selectedphoto!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(selectedphoto!);
      String downloadURL = await ref.getDownloadURL();
      _sendMessage(context, imageUrl:downloadURL);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  void initState() {
    super.initState();
    messageRef = FirebaseDatabase.instance.ref().child('Messages').child(widget.chatid);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

   void _sendMessage(BuildContext context, {String ? imageUrl} ) {
    final text = chats.text.trim();
    if (text.isEmpty&& imageUrl == null) return;
    final dataProvider = Provider.of<Providerclass>(context, listen: false);
    messageRef.push().set({
      'text': text.isEmpty? null: text,
      'senderId': dataProvider.userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      "imageUrl" : imageUrl
    });
    chats.clear();
  }
   String getformatteday(DateTime timestamp){
    final now=DateTime.now();
    final difference = now.difference(timestamp).inDays;

    if(difference==0){
      return 'Today';
    }else{return
    DateFormat.EEEE().format(timestamp);}
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<Providerclass>(context);
    print(widget.chatid);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.info_outline),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder:(context) => VideoCall(),));
            }, icon: Icon(Icons.call)),
          ),
        ],
        title: Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.blue),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Consumer<Providerclass>(
                builder: (context, value, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.otherphone,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          value.userId,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: messageRef.orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No messages available'));
                } else {
                  final currentUserID = dataProvider.userId;
                  final messages = (snapshot.data!.snapshot.value as Map<dynamic, dynamic>)
                      .entries
                      .map((entry) => {
                            'text': entry.value['text'],
                            'senderId': entry.value['senderId'],
                            'timestamp': entry.value['timestamp'],
                            "imageUrl" : entry.value["imageUrl"]
                          })
                      .toList()
                        ..sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

                  // Scroll to bottom on new message
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser = message['senderId'] == currentUserID;
                      final messageTime = DateTime.fromMillisecondsSinceEpoch(message['timestamp']);
                      final formattedTime = DateFormat('h:mm a').format(messageTime);
                      final formattedDay = getformatteday(messageTime);
                      

                      bool showDateHeader= false;
                      if (index==0){
                        showDateHeader=true;
                      }else{
                        final prevmessage= messages[index-1];
                        final prevTimeStamp= DateTime.fromMillisecondsSinceEpoch(
                          prevmessage['timestamp']
                        );
                        final prevDay =getformatteday(prevTimeStamp);
                        showDateHeader=prevDay!=formattedDay;
                      }

                      return Column(
                        children: [
                           if (showDateHeader)
                          Center(child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Text(formattedDay,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          ),),
                          Align(
                            alignment:
                                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue : Colors.pinkAccent,
                                borderRadius: isCurrentUser
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(message['text']!=null)
                                  Text(
                                    message['text'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  if(message['imageUrl']!=null)
                                  Image.network(message['imageUrl']),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
           Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chats,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () => imgFromGallery(context),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => imgFromCamera(context),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                ),
              ]
            )
          )
        ],
      ),
    );
  }

}




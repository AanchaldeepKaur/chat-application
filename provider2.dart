import 'package:authentication/ChatAPPLICATION/friends.dart';
import 'package:authentication/ChatAPPLICATION/phoneverification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Providerclass extends ChangeNotifier {
  String _userId = '';
  String _phoneno = '';
  List data = [];
  List get _data => data;

  String get userId => _userId;
  String get phoneno => _phoneno;

  void setUserId(String id) {
    _userId = id;
    storeid(id);
    notifyListeners();
  }
 void storeid(String data)async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', data);
 }

 void getuserdata(BuildContext context)async{
 final SharedPreferences prefs = await SharedPreferences.getInstance();
 final String? user = prefs.getString('user');
 if(user == null || user == " "){
  Navigator.push(context, MaterialPageRoute(builder:(context) => PhoneChat(),));
 }
 else{
  setUserId(user);
  Navigator.push(context, MaterialPageRoute(builder:(context) => Chatting(),));
 }
 }
  void setphone(String id) {
    _phoneno = id;
    notifyListeners();
  }

  void addItem(TextEditingController item) {
    data.add(item.text.toString());
    notifyListeners();
  }

  void removeItem(item) {
    data.remove(item);
    notifyListeners();
  }

  void setDataList(newDataList) {
    data = newDataList;
    notifyListeners();
  }

  Stream<DatabaseEvent> getUserStream() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('UserCredentials/$_userId');
    return ref.onValue;
  }

  Stream<DatabaseEvent> getAllUsersStream() {
     DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('UserCredentials');
    return usersRef.onValue;
  }

  void fetchUserData() {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('UserCredentials/$_userId');
    ref.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        _phoneno = data['phoneNumber'] ?? '';
      } else {
        _phoneno = '';
      }
      notifyListeners();
    });
  }
  Future<DatabaseEvent> getLastMessage(String createRoomId) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Messages/$createRoomId');
  Query query = ref.orderByKey().limitToLast(1);
  return await query.once();
}


}

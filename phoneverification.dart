import 'dart:math';

import 'package:authentication/ChatAPPLICATION/otpscr.dart';
import 'package:authentication/const/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:medical_store_mobile_app/screens/verification/verification.dart';

class PhoneChat extends StatefulWidget {
  const PhoneChat({super.key});

  @override
  State<PhoneChat> createState() => _PhoneChatState();
}

class _PhoneChatState extends State<PhoneChat> {
   GlobalKey<FormState> _formKey = GlobalKey();
   final TextEditingController phonecontroller = TextEditingController();

  void sendOTP()async{
    String phone="+91"+ phonecontroller.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) {}, 
      verificationFailed: (ex) {
        log(ex.code.toString() as num);
      }, 
      codeSent: (verificationId, resendToken) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => Verify(
        verificationId: verificationId,
        phoneno: phone ,
       ),));
      } , 
      codeAutoRetrievalTimeout: (verificationId) {},

      );
  }
   
  @override
  Widget build(BuildContext context) {
    var mywidth= MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            SizedBox(height: 70,),
            Container(
              width: mywidth/1.4,
              child: Text('Please enter your Mobile Number to Login/Sign Up', style: greytext.copyWith(fontSize: 15),)),
         
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phonecontroller,
                decoration: InputDecoration(
                  hintText: 'enter phone number',
                  border: OutlineInputBorder()
                ),
              
              ),
            ),
         
           ElevatedButton(onPressed: () {
            sendOTP();
           }, child:const Text('Continue'))
        
          ],
        ),
      ),
    );
  }
}
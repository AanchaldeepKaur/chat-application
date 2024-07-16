
import 'dart:async';
import 'dart:math';

import 'package:authentication/ChatAPPLICATION/friends.dart';
import 'package:authentication/Providers/provider2.dart';
import 'package:authentication/const/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Verify extends StatefulWidget {
  const Verify({super.key,this.phoneno, required this.verificationId,});
  final dynamic phoneno;
  final String verificationId;
  

  @override
  State<Verify> createState() => _VerifyState();
}



class _VerifyState extends State<Verify> {
  
  final TextEditingController otpController = TextEditingController();
  
  final FocusNode _textFieldFocusNode = FocusNode();
  final FocusNode _submitButtonFocusNode = FocusNode();
  int secondsRemaining = 10;
  bool enableResend = false;
  bool ShowContainer = false;

  void otpverify()async{
    String otp =otpController.text.toString();

    PhoneAuthCredential credential= PhoneAuthProvider.credential(
      verificationId: widget.verificationId, 
      smsCode: otp);
    
      try{
      UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(credential);
      if(userCredential.user!= null){
        String userId = userCredential.user!.uid;
         String phoneno = widget.phoneno;
      //  await FirebaseFirestore.instance.collection('UserCredentials').doc(userId).set({
      //   'userId': userId,
      //   'phoneNumber': widget.phoneno,
      //   'createdAt': FieldValue.serverTimestamp(),
      // });
         Provider.of<Providerclass>(context, listen: false).setUserId(userId);
         Provider.of<Providerclass>(context, listen: false).setphone(phoneno);
       DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('UserCredentials');
        await usersRef.child(userId).set({
          'userId': userId,
          'phoneNumber': phoneno,
          'createdAt': DateTime.now().toString(),
        });
       
       Provider.of<Providerclass>(context, listen: false).fetchUserData();

       Navigator.push(context, MaterialPageRoute(builder: (context) => Chatting(),));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('login Successful userId= $userId')));

      }

      } on FirebaseAuthException catch(ex){
        log(ex.code.toString() as num);

      }


  }

   void _resendCode() {
    setState((){
      secondsRemaining = 15;
      enableResend = false;
    });
  }
  late Timer timer;


@override
  void initState() {
    super.initState();
    otpController.addListener(_onTextChanged);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _textFieldFocusNode.dispose();
    _submitButtonFocusNode.dispose();
     timer.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (otpController.text.length == 6) {
      // Move focus to submit button
      FocusScope.of(context).requestFocus(_submitButtonFocusNode);
    }
  }

  void _handleSubmit() {
    // Perform submit action here
    print("Form submitted!");
  }

  @override
  Widget build(BuildContext context) {
      if(secondsRemaining==0){
        ShowContainer = true;
      }
     var mywidth= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: () {
        Navigator.pop(context);
      }, icon: const Icon(Icons.arrow_back)),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: SizedBox(
              width: mywidth,
              child: Text('Enter the verify code', style: textstylew700.copyWith(fontSize: 25),)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: SizedBox(
              width: mywidth,
              child: Text('We just send you a verification code via phone', style: greytext,)),
          ),
          
           Padding(
             padding: const EdgeInsets.only(left: 20,),
             child: SizedBox(
                width: mywidth,
                child: Text('${widget.phoneno}', style: greytext,)
               ),
           ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: otpController,
                decoration: const InputDecoration(
                  hintText: 'enter otp',
                  border: OutlineInputBorder()
                ),
            
              ),
          ),

            ElevatedButton(onPressed: () {
            otpverify();
           
           },
            child: const Text('Submit')),
          

           const SizedBox(height: 30,),
            SizedBox(width: mywidth,
            child: Center(child: Text('The verify code will expire in $secondsRemaining', style: greytext,)),),
            const SizedBox(height: 20,),
             
            ShowContainer ? 
            SizedBox(
              width: mywidth,
            child: Center(
              child: InkWell(
                onTap: () => enableResend ? _resendCode() : null,
                child: Text('Resend Code', style: textstylew700.copyWith(color: Colors.blue),))),)
                : const SizedBox()
        ],
      )
    );
  }
}
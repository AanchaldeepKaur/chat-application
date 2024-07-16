import 'package:authentication/ChatAPPLICATION/friends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _formkey= GlobalKey<FormState>();
class LoginChat extends StatefulWidget {
  const LoginChat({super.key});

  @override
  State<LoginChat> createState() => _LoginChatState();
}

class _LoginChatState extends State<LoginChat> {
  bool passwordVisible=false;
  
  void initState(){
    super.initState();
    passwordVisible=true;
  }
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'),
      centerTitle: true,
      backgroundColor: Colors.pink,),
   
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Form(
          key: _formkey,
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                 controller: email,
                  decoration: InputDecoration(border: OutlineInputBorder(),
                  labelText: 'Enter Email'),
                  validator: (value) {
                    if(value!.isEmpty){
                      return "please enter correct email";
                    }
                    else if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)){
                      return 'enter a valid email';
                    }else
                    return null;
                  },
                            ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                 controller: name,
                
                  decoration: InputDecoration(border: OutlineInputBorder(),
                  labelText: 'Enter password',
                  suffixIcon: IconButton(onPressed:() {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon: Icon( passwordVisible
                  ?Icons.visibility
                  :Icons.visibility_off)
                  )
                  ),
                  obscureText: passwordVisible,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "required";
                    }
                    else if(value.length<6){
                      return 'atleast 6 characters required';

                    }else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)){
                      return 'enter valid password';
                    }else
                    return null;
                  },
                            ),
              ),

             
            ElevatedButton(onPressed:() {
              if(_formkey.currentState!.validate()){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('data')));
              }
          
            }, child: Text('Submit')),
            ElevatedButton(onPressed: () {
              signInWithGoogle();
            }, child: Text('Signin with google'))
            ],
          )
          )
          ],
      ),
    );
  }
  signInWithGoogle()async{
    GoogleSignInAccount ? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication ? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);

    if(userCredential.user!= null){
     //  router.go('/navigation');
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('logout Successful')));
       Navigator.push(context, MaterialPageRoute(builder:(context) =>Chatting(),));
    }
  }
}
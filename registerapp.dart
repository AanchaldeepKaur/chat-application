import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _formkey= GlobalKey<FormState>();
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
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
      appBar: AppBar(title: Text('signup'),
      centerTitle: true,
      backgroundColor: Colors.amber,),
   
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                 // controller: name,
                  decoration: InputDecoration(border: OutlineInputBorder(),
                  labelText: 'Enter name'),
                  validator: (value) {
                    if(value!.isEmpty|| !RegExp(r'^[a-z A-Z]+$').hasMatch(value)){
                      return "please enter some text";
                    }
                    return null;
                  },
                            ),
              ),

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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                 // controller: name,
                
                  decoration: InputDecoration(border: OutlineInputBorder(),
                  labelText: 'Confirm password',
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed:()async {
                  if(_formkey.currentState!.validate()){

                    try{
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: name.text).whenComplete(() {
                   //   Navigator.push(context, MaterialPageRoute(builder: (context) => signin(),));
                    });
                    }
                    catch(e){
                       print('bitch---------------------${e}');
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                    
                    }
                  }
                    
                    


                   
                            
                  }, child: Text('Submit')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('already have an account?',style: TextStyle(color: Colors.blue),),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: () {
                     //   Navigator.push(context,MaterialPageRoute(builder: (context) => signin(),));
                      }, child: Text('signin'))
                    ],
                  ),
                )
              ],
            )
            ],
          )
          )
          ],
      ),
    );
  }
}
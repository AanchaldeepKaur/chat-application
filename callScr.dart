import 'package:authentication/ChatAPPLICATION/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder:(context) => VideoCall(),));
              },
              color: Colors.green,
              child: Text("Accept"),
              ),
                MaterialButton(onPressed: (){
                Navigator.pop(context);
              },
              color: Colors.red,
              child: Text("Decline"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
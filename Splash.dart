import 'package:authentication/Providers/provider2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Future.delayed(Duration(milliseconds: 300), (){
        final Providers = Provider.of<Providerclass>(context, listen:false);
        Providers.getuserdata(context);
       }
       );
    });

  }

  @override
  Widget build(BuildContext context) {
    var myheight = MediaQuery.of(context).size.height;
    var mywidth = MediaQuery.of(context).size.width;
    return Scaffold(
       body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Center(
            child: Container(
              height: myheight,
              width: mywidth,
              child: Icon(Icons.chat_bubble_outline, size: 60,)),
          )
         ],
       ),
    );
  }
}

import 'package:authentication/ChatAPPLICATION/callScr.dart';
import 'package:authentication/ChatAPPLICATION/notificationhelp.dart';
import 'package:authentication/Providers/Splash.dart';
import 'package:authentication/Providers/provider2.dart';
import 'package:authentication/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
       AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
dynamic regId;

getRegId() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  String? registrationToken;
  registrationToken = await messaging.getToken();
  regId = registrationToken.toString();
  print(regId);
}

void _initializeFCMHandlers(context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
   
     if (message.data['type'] == 'VideoCall') {
     Navigator.push(context, MaterialPageRoute(builder:(context) =>CallScreen() ,));
    } else if (message.data['type'] == 'AudioCall') {
      Navigator.push(context, MaterialPageRoute(builder:(context) =>CallScreen() ,));
    }
    ForegroundNotificationHandler.handleMessage(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("onMessageOpenedApp: $message");
    
    ForegroundNotificationHandler.handleMessageOpenedApp(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
 void handleMessagess(BuildContext context, RemoteMessage message) {
    print("Handling message: $message");
    if (message.data['type'] == 'VideoCall') {
     Navigator.push(context, MaterialPageRoute(builder:(context) =>CallScreen() ,));
    } else if (message.data['type'] == 'AudioCall') {
      Navigator.push(context, MaterialPageRoute(builder:(context) =>CallScreen() ,));
    } else {
      print('Unknown message type: ${message.data['type']}');
    }
  }

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background message: ${message.messageId}");
  BackgroundNotificationHandler.handleBackgroundMessage(message);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
//PushNotificationService().initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  NotificationHelper.init();
  initializeLocalNotifications();
  _firebaseMessaging.requestPermission();
  getRegId();
  _initializeFCMHandlers(context);
  runApp( 
    MultiProvider(providers:  [
    ChangeNotifierProvider<Providerclass>(create: (_) => Providerclass()),
  ],child: MyApp(),
  )
     );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:SplashScreen(),
    );
  }
}
class ForegroundNotificationHandler {
  static void handleMessage(RemoteMessage message) {
    print("Foreground message received: $message");
    if (message.notification != null) {
      _displayLocalNotification(
          message.notification!.title, message.notification!.body);

    } else if (message.data.isNotEmpty) {
      _handleDataMessage(message.data);
    }
  }

  static void handleMessageOpenedApp(RemoteMessage message) {
    print("Foreground message opened from terminated state: $message");
    if (message.notification != null) {
      _displayLocalNotification(
          message.notification!.title, message.notification!.body);
    } else if (message.data.isNotEmpty) {
      _handleDataMessage(message.data);
    }
  }

  static void _displayLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
        'important_notification',
         'HK NOTIFICATION',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  static void _handleDataMessage(Map<String, dynamic> data) {
    print("Data message received: $data");
  }
}

class BackgroundNotificationHandler {
  static void handleBackgroundMessage(RemoteMessage message) {
    print("Background message received: ${message.messageId}");
 
  }
}



//fVTOdyedSPqFycp2A3NLW_:APA91bE60j3eplv3PEFA-7ir7O50EMd8h1jDa-qTldOrJlF1-mwBB9IVgNME4x6OBAyVus66zCyLek4DRggM7oS6Q3t72HcM0Shp3JSJGlzaF_TTY3xA8Dwzvs-KSd9cjhC34glm7dj2

// flutterfire configure --project=fir-project1-eb32f

//  keytool -list -v -keystore C:\Users\Pavlion\.android\debug.keystore -alias androiddebugkey 
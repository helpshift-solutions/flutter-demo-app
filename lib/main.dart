import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hs_wrapper/hs_wrapper.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Listneing to the foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  Map<String, dynamic> config = {"enableLogging": true};
  setupHelpShiftSdk(config);
  runApp(const MyApp());
}

void setupHelpShiftSdk(config) async {
  await HsWrapper.setUpHelpShiftSDK(
      helpShiftApiKey: Constants.helpShiftApiKey(),
      helpShiftAppId: Constants.helpShiftAppId(),
      helpShiftDomain: Constants.helpShiftDomain,
      config: config
      //notificationChannelId: 'test_app'
    );
  print("HelpshiftAPIKEY = ${Constants.helpShiftApiKey()}");
}

// Lisitnening to the background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  HsWrapper.handlePush(message.data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _onButton1Pressed() async {
    print('Button 1 Pressed');
    await _getToken();
    HsWrapper.showAllConversation(configMap: getConfigMap());
  }

  void _onButton2Pressed() {
    HsWrapper.openFAQsScreen(configMap: getConfigMap());
    print('Button 2 Pressed');
  }

  Future<void> _getToken() async {
    if (Platform.isIOS) {
      final APNSToken = await firebaseMessaging.getAPNSToken() ?? "";
      print('APNSToken:: $APNSToken');
      HsWrapper.registerPushToken(token: APNSToken);
    } else {
      final fcmToken = await firebaseMessaging.getToken() ?? "";
      print('fcmToken:: $fcmToken');
      HsWrapper.registerPushToken(token: fcmToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _onButton1Pressed,
              child: const Text('Show All Conversion'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onButton2Pressed,
              child: const Text('Show Faq'),
            ),
          ],
        ),
      ),
    );
  }

  getConfigMap() {
    var config = {};
    config["tags"] = ["foo", "bar"];
    // var cifMap = {};
    // var isPro = {"type": "boolean", "value": "true"};
    // cifMap["is_pro"] = isPro;
    // config["customIssueFields"] = cifMap;
    return config;
  }
}

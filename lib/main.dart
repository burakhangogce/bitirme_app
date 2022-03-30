import 'dart:async';

import 'package:bitirme_app/pages/first_page.dart';
import 'package:bitirme_app/pages/profile_page.dart';
import 'package:bitirme_app/service/local_push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'firebase_login/login.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

//meraba

//son degisiklik
class MyApp extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: _scaffoldKey,
      debugShowCheckedModeBanner: false,
      theme: Get.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: firstControl(),
    );
  }
}

class firstControl extends StatefulWidget {
  @override
  _firstControlState createState() => _firstControlState();
}

class _firstControlState extends State<firstControl> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return HomeScreen();
    } else {
      //If the user is not Logged-In.
      return LoginScreen();
    }
  }
}

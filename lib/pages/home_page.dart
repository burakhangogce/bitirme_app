import 'dart:convert';

import 'package:bitirme_app/model/auth_service.dart';
import 'package:bitirme_app/pages/event_detail.dart';
import 'package:bitirme_app/pages/first_page.dart';
import 'package:bitirme_app/service/local_push_notification.dart';
import 'package:bitirme_app/widgets/popular_slider.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/event_list.dart';
import '../widgets/my_events.dart';
import 'package:http/http.dart' as http;

import '../widgets/tabs.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

sendNotification(String title, String desc, String token) async {
  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
  };

  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAimYeu_c:APA91bFkP5PurHzv_Dy924Nxsnz-eqzVoXzU_JL7feHdnK0JffTE3QwMnJ7Z33t5AIMKy7EqXsha2lcc75SMKFldIH1Vxdfp37oetHIO3k5X6nt4Srm1dxvL6acA4VNp0iwsuLfMcelL'
            },
            body: jsonEncode(<String, dynamic>{
              'notification': <String, dynamic>{'title': title, 'body': desc},
              'priority': 'high',
              'data': data,
              'to': '$token'
            }));

    if (response.statusCode == 200) {
      print("Yeh notificatin is sended");
    } else {
      print("Error");
    }
  } catch (e) {}
}

class _FirstPageState extends State<FirstPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  int _current = 0;
  int pageIndex = 0;
  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'token': token,
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    storeNotificationToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 24),
            child: Text(
              'Merhaba, ${loggedInUser.username} 👋 Keyifli Kodlamalar!',
              style: mTitleStyle,
            ),
          ),
          PopularSlider(),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
            child: Text(
              'Haydi Başlayalım!',
              style: mTitleStyle,
            ),
          ),
          Container(
              height: 350,
              margin: EdgeInsets.only(top: 10),
              child: SimpleTab()),
        ],
      ),
    );
  }
}

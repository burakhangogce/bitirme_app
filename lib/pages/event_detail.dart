import 'package:bitirme_app/pages/home_page.dart';
import 'package:bitirme_app/widgets/buttons.dart';
import 'package:bitirme_app/widgets/network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../model/auth_service.dart';

class EventDetail extends StatefulWidget {
  final String eventId,
      eventDesc,
      eventTitle,
      eventImg,
      eventPlat,
      eventOrg,
      eventSubject;
  final Timestamp eventDate;
  final int eventTime;

  const EventDetail(
      {Key? key,
      required this.eventId,
      required this.eventDesc,
      required this.eventDate,
      required this.eventTitle,
      required this.eventPlat,
      required this.eventImg,
      required this.eventTime,
      required this.eventOrg,
      required this.eventSubject})
      : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool join = false;

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
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('events')
        .doc(widget.eventId)
        .get()
        .then((value) {
      join = value['join'] == null ? false : value['join'];
      setState(() {});
    });
  }

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .collection('members')
        .doc(user!.uid)
        .update({
      'token': token,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article One'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: 300,
                    width: double.infinity,
                    child: PNetworkImage(
                      widget.eventImg,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.slideshow,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Technology",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(widget.eventOrg),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet",
                    style: TextStyle(color: Colors.black),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.favorite_border),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("20.2k"),
                      SizedBox(
                        width: 16.0,
                      ),
                      Icon(Icons.comment),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("2.2k"),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  RaisedButton(onPressed: () {
                    FirebaseFirestore.instance
                        .collection("events")
                        .doc(widget.eventId)
                        .collection('members')
                        .where('join', isEqualTo: true)
                        .get()
                        .then((querySnapshot) {
                      querySnapshot.docs.forEach((result) {
                        sendNotification(
                            '${widget.eventTitle} etkinliği başladı! ${loggedInUser.username}',
                            '${widget.eventDesc}',
                            result['token']);
                      });
                    });
                  }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
                              onPressed: () {
                                if (join == true) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(loggedInUser.uid)
                                      .collection('events')
                                      .doc(widget.eventId)
                                      .update({
                                    'join': false,
                                  });
                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(widget.eventId)
                                      .collection('members')
                                      .doc(loggedInUser.uid)
                                      .set({
                                    'join': false,
                                  });
                                } else if (join == false) {
                                  storeNotificationToken();

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(loggedInUser.uid)
                                      .collection('events')
                                      .doc(widget.eventId)
                                      .set({
                                    'eventDate': widget.eventDate,
                                    'eventId': widget.eventId,
                                    'eventDesc': widget.eventDesc,
                                    'eventTitle': widget.eventTitle,
                                    'eventImg': widget.eventImg,
                                    'eventPlat': widget.eventPlat,
                                    'eventTime': widget.eventTime,
                                    'eventSubject': widget.eventSubject,
                                    'join': true,
                                  });
                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(widget.eventId)
                                      .collection('members')
                                      .doc(loggedInUser.uid)
                                      .set({
                                    'memberId': loggedInUser.uid,
                                    'join': true,
                                  });
                                }

                                setState(() {
                                  join = !join;
                                });
                                print(join);
                              },
                              child: Text(join == true ? 'İptal' : 'Katıl'),
                              color: join == false
                                  ? Colors.blue.shade900
                                  : Colors.redAccent,
                              textColor: Colors.white,
                            ),
                          ),
                          buildAddToCartButton(
                              'iptal',
                              'İletişime Geç',
                              loggedInUser.uid.toString(),
                              widget.eventId,
                              widget.eventDate,
                              widget.eventDesc,
                              widget.eventTitle,
                              widget.eventPlat,
                              widget.eventImg,
                              widget.eventTime,
                              widget.eventSubject),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.eventDesc,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

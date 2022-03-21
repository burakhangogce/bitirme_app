import 'package:bitirme_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../firebase_login/auth_service.dart';

class EventClick extends StatefulWidget {
  final String eventId, eventDesc, eventTitle, eventImg, eventPlat;
  final Timestamp eventDate;

  const EventClick(
      {Key? key,
      required this.eventId,
      required this.eventDesc,
      required this.eventDate,
      required this.eventTitle,
      required this.eventPlat,
      required this.eventImg})
      : super(key: key);

  @override
  State<EventClick> createState() => _EventClickState();
}

class _EventClickState extends State<EventClick> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          Container(
            width: screenWidth * 0.95,
            height: screenHeight * 0.7,
            margin: EdgeInsets.only(top: 66.0, bottom: 66.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(left: 2, right: 2, top: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
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
                            },
                            child: Column(
                              children: [
                                FaIcon(FontAwesomeIcons.redo),
                                Text("Katıl"),
                              ],
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
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
                            },
                            child: Column(
                              children: [
                                FaIcon(FontAwesomeIcons.redo),
                                Text("İptal"),
                              ],
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                FaIcon(FontAwesomeIcons.windowClose),
                                Text("Kapat"),
                              ],
                            ),
                          ))
                    ],
                  ),
                  Text(
                    "İstatistiklerim",
                    style: mTitleStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

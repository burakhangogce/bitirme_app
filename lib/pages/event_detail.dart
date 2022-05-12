import 'package:bitirme_app/widgets/buttons.dart';
import 'package:bitirme_app/widgets/network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/auth_service.dart';
import 'home_page.dart';
import 'organization_detail.dart';

class EventDetail extends StatefulWidget {
  final String eventId,
      eventDesc,
      eventTitle,
      eventImg,
      eventPlat,
      eventOrg,
      eventOrgId,
      eventOrgImg,
      eventDuration,
      eventSubject;
  final Timestamp eventDate;

  const EventDetail(
      {Key? key,
      required this.eventId,
      required this.eventDesc,
      required this.eventDate,
      required this.eventTitle,
      required this.eventPlat,
      required this.eventImg,
      required this.eventDuration,
      required this.eventOrg,
      required this.eventOrgId,
      required this.eventOrgImg,
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
        title: Text(widget.eventOrg),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.clock,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.eventDuration + "dk",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.calendarCheck,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.eventDate.toDate().day}/${widget.eventDate.toDate().month}/${widget.eventDate.toDate().year}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.slideshow,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.eventSubject,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
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
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return OrganizationDetail(
                                  orgId: widget.eventOrgId,
                                  orgImg: widget.eventOrgImg,
                                );
                              }));
                            },
                            child: Text(widget.eventOrg)),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Text(
                    widget.eventDesc,
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
                                      .collection('events')
                                      .doc(widget.eventId)
                                      .update({
                                    'join ${loggedInUser.uid}': false,
                                  });
                                } else if (join == false) {
                                  storeNotificationToken();

                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(widget.eventId)
                                      .update({
                                    'join ${loggedInUser.uid}': true,
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
                              widget.eventDuration,
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

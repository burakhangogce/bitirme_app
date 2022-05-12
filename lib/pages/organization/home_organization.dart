import 'package:bitirme_app/pages/organization/create_event.dart';
import 'package:bitirme_app/pages/organization/edit_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_string/random_string.dart';

import '../../model/auth_service.dart';
import '../event_detail.dart';
import '../first_page.dart';
import '../home_page.dart';

class OrganizationHome extends StatefulWidget {
  const OrganizationHome({Key? key}) : super(key: key);

  @override
  State<OrganizationHome> createState() => _OrganizationHomeState();
}

class _OrganizationHomeState extends State<OrganizationHome> {
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
  }

  String date = "";
  DateTime selectedDate = DateTime.now();
  TextEditingController eventDescController = new TextEditingController();
  TextEditingController eventPlatController = new TextEditingController();
  TextEditingController eventSubjectController = new TextEditingController();
  TextEditingController eventTitleController = new TextEditingController();
  final userRef = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });

    print("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return CreateEvent();
        }));
      }),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .where('eventOrgId', isEqualTo: loggedInUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            final QuerySnapshot<Object?>? querySnapshot = snapshot.data;

            return snapshot.data == null
                ? Container()
                : snapshot.data!.docs.length == 0
                    ? Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 50,
                        child: Text("Henüz bir etkinliğiniz yok."),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(left: 16),
                        itemCount: snapshot.data!.docs.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final map = querySnapshot?.docs[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 16, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          Container(
                                            height: 140,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.transparent,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      map!["eventImg"]),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Positioned(
                                            child: SvgPicture.asset(
                                                'assets/svg/travlog_top_corner.svg'),
                                            right: 0,
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  right: 10, top: 10),
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                color: Colors.blueAccent,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text(
                                                        map['eventCat'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.globe,
                                                      color:
                                                          Colors.green.shade600,
                                                      size: 15,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text(
                                                        map['eventPlat'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 25,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              alignment: Alignment.centerLeft,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.clock,
                                                      color: Colors.pink,
                                                      size: 15,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text(
                                                        '${map['eventDuration']} dk',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: 45,
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Text(
                                                map['eventTitle'],
                                                textAlign: TextAlign.left,
                                                style: mTravlogTitleStyle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      /*
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                map["eventDesc"],
                                maxLines: 3,
                                style: mTravlogContentStyle,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                map["eventPlat"],
                                style: mTravlogPlaceStyle,
                              )
                              */
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('events')
                                            .doc(map['eventId'])
                                            .update({
                                          'eventStatus': !map['eventStatus']
                                        });
                                      },
                                      color: Colors.blueGrey,
                                      child: Text(
                                        map['eventStatus'] == true
                                            ? "Pasif Et!"
                                            : "Aktif Et!",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("events")
                                            .doc(map['eventId'])
                                            .collection('members')
                                            .where('join', isEqualTo: true)
                                            .get()
                                            .then((querySnapshot) {
                                          querySnapshot.docs.forEach((result) {
                                            sendNotification(
                                                '${map['eventTitle']} etkinliği başladı! ${loggedInUser.username}',
                                                '${map['eventDesc']}',
                                                result['token']);
                                          });
                                        });
                                      },
                                      color: Colors.blueGrey,
                                      child: Text(
                                        "Bildirim",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            CupertinoPageRoute(
                                                builder: (context) {
                                          return EditEvent(
                                            eventTitle: map['eventTitle'],
                                            eventCat: map['eventCat'],
                                            eventDate: map['eventDate'],
                                            eventDesc: map['eventDesc'],
                                            eventDuration: map['eventDuration'],
                                            eventId: map['eventId'],
                                            eventImg: map['eventImg'],
                                            eventLink: map['eventLink'],
                                            eventPlat: map['eventPlat'],
                                          );
                                        }));
                                      },
                                      color: Colors.blueGrey,
                                      child: Text(
                                        "Düzenle",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              )
                            ],
                          );
                        },
                      );
          }),
    );
  }
}

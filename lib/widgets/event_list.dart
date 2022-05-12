import 'package:bitirme_app/pages/event_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/auth_service.dart';
import '../pages/first_page.dart';

class eventList extends StatelessWidget {
  const eventList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 181,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .where('eventStatus', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            final QuerySnapshot<Object?>? querySnapshot = snapshot.data;

            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    padding: EdgeInsets.only(left: 16),
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final map = querySnapshot?.docs[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetail(
                                        eventDate: map!['eventDate'],
                                        eventOrg: map['eventOrg'],
                                        eventDesc: map['eventDesc'],
                                        eventId: map['eventId'],
                                        eventImg: map['eventImg'],
                                        eventPlat: map['eventPlat'],
                                        eventTitle: map['eventTitle'],
                                        eventSubject: map['eventSubject'],
                                        eventDuration: map['eventDuration'],
                                        eventOrgId: map["eventOrgId"],
                                        eventOrgImg: map['eventOrgImg'],
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 16, bottom: 10),
                          width: 220,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                          image: NetworkImage(map!["eventImg"]),
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
                                      margin:
                                          EdgeInsets.only(right: 10, top: 10),
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.blueAccent,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                map['eventCat'],
                                                textAlign: TextAlign.center,
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
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.globe,
                                              color: Colors.green.shade600,
                                              size: 15,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                map['eventPlat'],
                                                textAlign: TextAlign.center,
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
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.clock,
                                              color: Colors.pink,
                                              size: 15,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                '${map['eventDuration'].toString()} dk',
                                                textAlign: TextAlign.center,
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
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 8, right: 8),
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
                      );
                    },
                  );
          }),
    );
  }
}

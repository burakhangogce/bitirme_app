import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../firebase_login/auth_service.dart';
import '../pages/home_page.dart';
import 'event_click.dart';

class eventList extends StatelessWidget {
  const eventList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 181,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            final QuerySnapshot<Object?>? querySnapshot = snapshot.data;

            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    padding: EdgeInsets.only(left: 16),
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final map = querySnapshot?.docs[index];

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => EventClick(
                              eventId: map!["eventId"],
                              eventDesc: map["eventDesc"],
                              eventDate: map["eventDate"],
                              eventTitle: map["eventTitle"],
                              eventImg: map["eventImg"],
                              eventPlat: map["eventPlat"],
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 16),
                          width: 220,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: 104,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: NetworkImage(map!["eventImg"]),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    child: SvgPicture.asset(
                                        'assets/svg/travlog_top_corner.svg'),
                                    right: 0,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: SvgPicture.asset(
                                        'assets/svg/travelkuy_logo_white.svg'),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: SvgPicture.asset(
                                        'assets/svg/travlog_bottom_gradient.svg'),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Text(
                                      map["eventTitle"],
                                      style: mTravlogTitleStyle,
                                    ),
                                  ),
                                ],
                              ),
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

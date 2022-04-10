import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/event_detail.dart';

class PopularSlider extends StatefulWidget {
  const PopularSlider({Key? key}) : super(key: key);

  @override
  State<PopularSlider> createState() => _PopularSliderState();
}

class _PopularSliderState extends State<PopularSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 16, right: 16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('events').snapshots(),
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 190,
                        child: Swiper(
                          onIndexChanged: (index) {
                            setState(() {
                              _current = index;
                            });
                          },
                          pagination: SwiperPagination(
                              margin: EdgeInsets.only(top: 20),
                              builder: DotSwiperPaginationBuilder(
                                  color: Color(0xFFA7A7A7),
                                  activeColor: Colors.white,
                                  activeSize: 10)),
                          autoplay: true,
                          layout: SwiperLayout.DEFAULT,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            final DocumentSnapshot map =
                                snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetail(
                                              eventDate: map['eventDate'],
                                              eventOrg: map['eventOrg'],
                                              eventDesc: map['eventDesc'],
                                              eventId: map['eventId'],
                                              eventImg: map['eventImg'],
                                              eventPlat: map['eventPlat'],
                                              eventTitle: map['eventTitle'],
                                              eventSubject: map['eventSubject'],
                                              eventTime: map['eventTime'],
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        map['eventImg'],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              }),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

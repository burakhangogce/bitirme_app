import 'package:bitirme_app/pages/first_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'event_detail.dart';

class SearchEvents extends StatefulWidget {
  final String dropCat;

  const SearchEvents({Key? key, required this.dropCat}) : super(key: key);

  @override
  State<SearchEvents> createState() => _SearchEventsState();
}

class _SearchEventsState extends State<SearchEvents> {
  var option, firstValue = null;
  String dropdownValue = 'Hepsi';
  bool isTodayEvent = false;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text("Kategori: "),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categorys')
                      .orderBy('sira', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    // Safety check to ensure that snapshot contains data
                    // without this safety check, StreamBuilder dirty state warnings will be thrown
                    if (!snapshot.hasData) return Container();
                    // Set this value for default,
                    // setDefault will change if an item was selected
                    // First item from the List will be displayed

                    return DropdownButton(
                      isExpanded: false,
                      //value: snapshot.data!.docs[0].get('categoryTitle'),
                      value: firstValue == null ? widget.dropCat : firstValue,
                      items: snapshot.data!.docs.map((value) {
                        return DropdownMenuItem(
                          value: value.get('categoryTitle'),
                          child: Text('${value.get('categoryTitle')}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        debugPrint('selected onchange: $value');
                        setState(() {
                          option = value;
                          firstValue = value;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("Zaman: "),
                DropdownButton<String>(
                  // Step 3.
                  value: dropdownValue,
                  // Step 4.
                  items: <String>['Hepsi', 'Bugün', 'Bu Hafta']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                  // Step 5.
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ],
            )
          ],
        ),
        Container(
          height: 181,
          child: StreamBuilder<QuerySnapshot>(
              stream: option == 'Genel'
                  ? FirebaseFirestore.instance
                      .collection('events')
                      .where('eventStatus', isEqualTo: true)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('events')
                      .where('eventStatus', isEqualTo: true)
                      .where('eventCat', isEqualTo: option)
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
                          Timestamp f = map!['eventTime'];
                          DateTime l = f.toDate();
                          int difference = daysBetween(l, DateTime.now());
                          print(l);
                          print(difference);
                          if (dropdownValue == 'Bugün' && difference == 0) {
                            return EventWidget(context, map);
                          } else if (dropdownValue == 'Bu Hafta' &&
                              difference >= -6 &&
                              difference < 1) {
                            return EventWidget(context, map);
                          } else if (dropdownValue == 'Hepsi') {
                            return EventWidget(context, map);
                          }
                          return Container();
                        },
                      );
              }),
        )
      ]),
    );
  }

  GestureDetector EventWidget(
      BuildContext context, QueryDocumentSnapshot<Object?> map) {
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
                      eventSubject: map['eventCat'],
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
                        image: NetworkImage(map["eventImg"]), fit: BoxFit.fill),
                  ),
                ),
                Positioned(
                  child: SvgPicture.asset('assets/svg/travlog_top_corner.svg'),
                  right: 0,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    margin: EdgeInsets.only(right: 10, top: 10),
                    alignment: Alignment.centerLeft,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              map['eventCat'],
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
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
                    margin: EdgeInsets.only(left: 10, top: 10),
                    alignment: Alignment.centerLeft,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
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
                    margin: EdgeInsets.only(left: 10, top: 10),
                    alignment: Alignment.centerLeft,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
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
                    margin: EdgeInsets.only(left: 8, right: 8),
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
  }
}

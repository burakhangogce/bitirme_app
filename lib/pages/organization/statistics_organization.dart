import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/auth_service.dart';

class StatisticsOrganization extends StatefulWidget {
  @override
  State<StatisticsOrganization> createState() => _StatisticsOrganizationState();
}

class _StatisticsOrganizationState extends State<StatisticsOrganization> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late List<DocumentSnapshot> _myDocCount;

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

  statisticsFound() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('events')
        .where('eventOrgId', isEqualTo: loggedInUser.uid)
        .where('eventStatus', isEqualTo: true)
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    return _myDocCount;
  }

  allQuizCount() async {
    QuerySnapshot _SpecMyDoc =
        await FirebaseFirestore.instance.collection('Quiz').get();
    List<DocumentSnapshot> _SpecMyDocCount = _SpecMyDoc.docs;

    return _SpecMyDocCount;
  }

  Future<dynamic> callAsyncFetch() => statisticsFound();
  //Future<dynamic> allQuizCallAsyncFetch() => allQuizCount();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<dynamic>(
        future: Future.wait([
          callAsyncFetch(),
        ]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
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
                      margin: EdgeInsets.only(
                          left: 2, right: 2, top: 20, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Column(
                                      children: [
                                        FaIcon(FontAwesomeIcons.redo),
                                        Text("Yenile"),
                                      ],
                                    ),
                                  )),
                              /*
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
                                  */
                            ],
                          ),
                          Text(
                            "İstatistiklerim",
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                          Text(
                            "Şuan aktif olan ${snapshot.data[0].length} etkinliğiniz var.",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          Divider(),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('events')
                                  .where('eventOrgId',
                                      isEqualTo: loggedInUser.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                final QuerySnapshot<Object?>? querySnapshot =
                                    snapshot.data;

                                return snapshot.data == null
                                    ? Container()
                                    : ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final map =
                                              querySnapshot?.docs[index];

                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blue.shade200),
                                            margin: EdgeInsets.only(
                                              top: 25,
                                            ),
                                            child: statisticsBar(
                                              eventId: map!["eventId"],
                                              eventImg: map["eventImg"],
                                              eventTitle: map["eventTitle"],
                                            ),
                                          );
                                        });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class statisticsBar extends StatefulWidget {
  final String eventId, eventImg, eventTitle;

  statisticsBar({
    required this.eventId,
    required this.eventImg,
    required this.eventTitle,
  });
  @override
  State<statisticsBar> createState() => _statisticsBarState();
}

class _statisticsBarState extends State<statisticsBar> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late List<DocumentSnapshot> _myDocCount;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    });
  }

  joinTrueEvent() async {
    QuerySnapshot _trueEvent = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .collection('members')
        .where('join', isEqualTo: true)
        .get();
    List<DocumentSnapshot> _trueEventDocs = _trueEvent.docs;

    return _trueEventDocs;
  }

  totalEvent() async {
    QuerySnapshot _totalEvent = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .collection('members')
        .get();
    List<DocumentSnapshot> _totalEventDocs = _totalEvent.docs;

    return _totalEventDocs;
  }

  Future<dynamic> callJoinTrueEvet() => joinTrueEvent();
  Future<dynamic> callTotalEvent() => totalEvent();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<dynamic>(
        future: Future.wait([
          callJoinTrueEvet(),
          callTotalEvent(),
        ]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.eventTitle,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                Text(
                  ("Toplam ${snapshot.data[0].length.toString()} kişi katılıcak.")
                      .toString(),
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                Text(
                  ("Toplam ${snapshot.data[1].length - snapshot.data[0].length} kişi sonradan iptal etti.")
                      .toString(),
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

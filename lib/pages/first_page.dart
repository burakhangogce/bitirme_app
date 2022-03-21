import 'package:bitirme_app/firebase_login/auth_service.dart';
import 'package:bitirme_app/pages/home_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/event_click.dart';
import '../widgets/event_list.dart';
import '../widgets/my_events.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  int _current = 0;

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
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          // Promos Section
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 24),
            child: Text(
              'Merhaba, ${loggedInUser.username} 👋 Keyifli Kodlamalar!',
              style: mTitleStyle,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16, right: 16),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .snapshots(),
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
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            map['eventImg'],
                                          ),
                                          fit: BoxFit.cover),
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
          ),
// Travlog Section
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
            child: Text(
              'Planladığım Etkinliklerim!',
              style: mTitleStyle,
            ),
          ),
          myEvents(),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
            child: Text(
              'Etkinlikler!',
              style: mTitleStyle,
            ),
          ),
          eventList(),
          // Service Section
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
            child: Text(
              'Haydi Başlayalım!',
              style: mTitleStyle,
            ),
          ),
          Container(
            height: 144,
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.only(left: 8),
                        height: 64,
                        decoration: BoxDecoration(
                          color: mFillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mBorderColor, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/questions.svg',
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'İstatistikler',
                                    style: mServiceTitleStyle,
                                  ),
                                  Text(
                                    'Sonuç ve istatistiklerim',
                                    style: mServiceSubtitleStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.only(left: 8),
                        height: 64,
                        decoration: BoxDecoration(
                          color: mFillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mBorderColor, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/categorys.svg',
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Kategoriler',
                                    style: mServiceTitleStyle,
                                  ),
                                  Text(
                                    'Bütün diller',
                                    style: mServiceSubtitleStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.only(left: 8),
                        height: 64,
                        decoration: BoxDecoration(
                          color: mFillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mBorderColor, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/events.svg',
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Etkinlikler',
                                    style: mServiceTitleStyle,
                                  ),
                                  Text(
                                    'Ödüllü etkinlikler',
                                    style: mServiceSubtitleStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.only(left: 8),
                        height: 64,
                        decoration: BoxDecoration(
                          color: mFillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mBorderColor, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/gifts.svg',
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Hediyeler',
                                    style: mServiceTitleStyle,
                                  ),
                                  Text(
                                    'Kazandığın hediyeler',
                                    style: mServiceSubtitleStyle,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Popular Destination Section
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
            child: Text(
              'Popüler Diller!',
              style: mTitleStyle,
            ),
          ),
          Container(
            height: 140,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('quizkategorileri')
                    .limit(5)
                    .orderBy("sira", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data == null
                      ? Container()
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot map =
                                snapshot.data!.docs[index];
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                height: 140,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: mBorderColor, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 16),
                                  child: Column(
                                    children: <Widget>[
                                      Image.network(
                                        map["v1CatImg"],
                                        height: 74,
                                      ),
                                      Text(
                                        map["categoryTitle"],
                                        style: mPopularDestinationTitleStyle,
                                      ),
                                      Text(
                                        map["categoryDesc"],
                                        style: mPopularDestinationSubtitleStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }),
          ),
        ],
      ),
    );
  }
}

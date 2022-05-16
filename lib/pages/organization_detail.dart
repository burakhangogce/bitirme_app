import 'package:bitirme_app/model/auth_service.dart';
import 'package:bitirme_app/pages/first_page.dart';
import 'package:bitirme_app/pages/home_page.dart';
import 'package:bitirme_app/widgets/org_all_chat.dart';
import 'package:bitirme_app/widgets/user_all_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/network_image.dart';

class OrganizationDetail extends StatefulWidget {
  @override
  _OrganizationDetailState createState() => _OrganizationDetailState();

  final String orgId, orgImg;

  const OrganizationDetail({
    Key? key,
    required this.orgId,
    required this.orgImg,
  }) : super(key: key);
}

class _OrganizationDetailState extends State<OrganizationDetail> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String uImg = '';
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('organizations')
        .doc(widget.orgId)
        .get()
        .then((value) => {
              setState(() {
                orgTitle = value['orgTitle'];
                orgDesc = value['orgDesc'];
              })
            });

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      uImg = value['userImg'];
      setState(() {});
    });
    super.initState();
  }

  String orgTitle = "", orgDesc = "", orgImg = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purple, Colors.blue])),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            orgTitle,
            style: TextStyle(color: Colors.black87),
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.orgImg,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(orgTitle,
                          style: TextStyle(fontSize: 25, color: Colors.black)),
                      Text(
                        "Kategori falan",
                        style: TextStyle(fontSize: 19, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          IconTile(
                            backColor: Color(0xffFFECDD),
                            imgNetworkPath:
                                "https://cdn.pixabay.com/photo/2021/06/15/12/14/instagram-6338392_640.png",
                          ),
                          IconTile(
                            backColor: Color(0xffFEF2F0),
                            imgNetworkPath:
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/800px-YouTube_full-color_icon_%282017%29.svg.png",
                          ),
                          IconTile(
                            backColor: Color(0xffEBECEF),
                            imgNetworkPath:
                                "https://e7.pngegg.com/pngimages/796/374/png-clipart-linkedin-linkedin.png",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                            color: Color(0xffFBB97C),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Color(0xffFCCA9B),
                                    borderRadius: BorderRadius.circular(16)),
                                child: FaIcon(FontAwesomeIcons.bell)),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width / 2 - 130,
                              child: Text(
                                "Takip Et!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("chats")
                              .doc(loggedInUser.uid)
                              .collection('UserChats')
                              .doc(widget.orgId)
                              .get()
                              .then((doc) {
                            if (doc.exists) {
                              FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(loggedInUser.uid)
                                  .collection('UserChats')
                                  .doc(widget.orgId)
                                  .update({
                                'chatId': '${loggedInUser.uid}',
                                'toId': '${widget.orgId}',
                                'toImage': '${widget.orgImg}',
                                'toName': '${orgTitle}',
                                'toText': ' ',
                                'uImage': '${uImg}',
                                'toUnreadCount': FieldValue.increment(1),
                                'uText': ' ',
                                'uName': '${loggedInUser.username}',
                                'uUnreadCount': FieldValue.increment(1),
                                'uid': loggedInUser.uid,
                                'chatTime':
                                    '${DateTime.now().hour} : ${DateTime.now().minute}',
                              });

                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return HomeScreen(
                                  page: 1,
                                );
                              }));
                            } else {
                              FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(loggedInUser.uid)
                                  .set({
                                'chatId': '${loggedInUser.uid}',
                                'toId': '${widget.orgId}',
                                'toImage': '${widget.orgImg}',
                                'toName': '${orgTitle}',
                                'toText': ' ',
                                'uImage': '${uImg}',
                                'toUnreadCount': FieldValue.increment(1),
                                'uText': ' ',
                                'uName': '${loggedInUser.username}',
                                'uUnreadCount': FieldValue.increment(1),
                                'uid': loggedInUser.uid,
                                'chatTime':
                                    '${DateTime.now().hour} : ${DateTime.now().minute}',
                              });
                              FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(loggedInUser.uid)
                                  .collection('UserChats')
                                  .doc(widget.orgId)
                                  .set({
                                'chatId': '${loggedInUser.uid}',
                                'toId': '${widget.orgId}',
                                'toImage': '${widget.orgImg}',
                                'toName': '${orgTitle}',
                                'toText': ' ',
                                'uImage': '${uImg}',
                                'toUnreadCount': FieldValue.increment(1),
                                'uText': ' ',
                                'uName': '${loggedInUser.username}',
                                'uUnreadCount': FieldValue.increment(1),
                                'uid': loggedInUser.uid,
                                'chatTime':
                                    '${DateTime.now().hour} : ${DateTime.now().minute}',
                              });

                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return HomeScreen(
                                  page: 1,
                                );
                              }));
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                              color: Color(0xffA5A5A5),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Color(0xffBBBBBB),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: FaIcon(
                                      FontAwesomeIcons.facebookMessenger)),
                              SizedBox(
                                width: 16,
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 130,
                                child: Text(
                                  "Mesaj At",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Hakkında",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget.orgImg,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconTile extends StatelessWidget {
  final String imgNetworkPath;
  final Color backColor;

  const IconTile({required this.imgNetworkPath, required this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Image.network(
          imgNetworkPath,
          width: 20,
        ),
      ),
    );
  }
}

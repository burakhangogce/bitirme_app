import 'dart:core';
import 'dart:core';
import 'package:bitirme_app/firebase_login/login_page.dart';
import 'package:bitirme_app/pages/edit_photo.dart';
import 'package:bitirme_app/pages/organization/edit_profile_organization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bitirme_app/model/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../pages/first_page.dart';
import 'package:intl/intl.dart';

Color kAppPrimaryColor = Colors.grey.shade200;
Color kWhite = Colors.white;
Color kLightBlack = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCL = Colors.grey.shade600;

IconData twitter = IconData(0xe900, fontFamily: "CustomIcons");
IconData facebook = IconData(0xe901, fontFamily: "CustomIcons");
IconData googlePlus = IconData(0xe902, fontFamily: "CustomIcons");
IconData linkedin = IconData(0xe903, fontFamily: "CustomIcons");

const kSpacingUnit = 10;

final kTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(
        bottom: 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            this.icon,
            size: 25,
          ),
          SizedBox(width: 15),
          Text(
            this.text,
            style: kTitleTextStyle.copyWith(
                fontWeight: FontWeight.w500, fontFamily: "Poppins"),
          ),
          Spacer(),
          if (this.hasNavigation)
            Icon(
              LineAwesomeIcons.angle_right,
              size: 25,
            ),
        ],
      ),
    );
  }
}

class MyProfile extends StatefulWidget {
  MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String orgImgUrl = "", orgTitle = "", orgDesc = "";
  String userImgUrl = "";

  @override
  void initState() {
    super.initState();
    if (loggedInUser.userType == 'organization') {
      FirebaseFirestore.instance
          .collection('organizations')
          .doc(user!.uid)
          .get()
          .then((value) => {
                setState(() {
                  orgImgUrl = value['orgImg'];
                  orgTitle = value['orgTitle'];
                  orgDesc = value['orgDesc'];
                }),
              });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((value) => {
                setState(() {
                  userImgUrl = value['userImg'];
                }),
              });
    }

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
    String _copy =
        "https://play.google.com/store/apps/details?id=bukhantech.algoritmik_fikir_quiz";
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(
              height: 50,
            ),
            Row(
              children: <Widget>[
                Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Profil Fotoğrafı',
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return EditPhoto();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    loggedInUser.userType == 'organization'
                                        ? orgImgUrl
                                        : userImgUrl,
                                  ))),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 10,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 214, 205, 205),
              height: 50,
              thickness: 1,
            ),
            Row(
              children: <Widget>[
                Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          loggedInUser.userType == 'organization'
                              ? 'Organizasyon İsmi'
                              : 'Kullanıcı ismi',
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (loggedInUser.userType == 'organization') {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return EditOrganizationProfilePage(
                              orgTitle: orgTitle,
                              orgImgUrl: orgImgUrl,
                              orgDesc: orgDesc,
                            );
                          }));
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(right: 40),
                              child: Text(
                                loggedInUser.userType == 'organization'
                                    ? orgTitle.toString()
                                    : loggedInUser.username.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          //mahir
                          loggedInUser.userType == 'organization'
                              ? Positioned(
                                  bottom: 0,
                                  right: 20,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                  ))
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: loggedInUser.userType == 'organization'
                  ? Color.fromARGB(255, 214, 205, 205)
                  : Colors.transparent,
              height: loggedInUser.userType == 'organization' ? 50 : 20,
              thickness: loggedInUser.userType == 'organization' ? 1 : 0,
            ),
            loggedInUser.userType == 'organization'
                ? Row(
                    children: <Widget>[
                      Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Organizasyon Açıklaması',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return EditOrganizationProfilePage(
                                  orgTitle: orgTitle,
                                  orgImgUrl: orgImgUrl,
                                  orgDesc: orgDesc,
                                );
                              }));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 40),
                                    child: Text(
                                      orgDesc,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 20,
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: Colors.green,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Divider(
              color: loggedInUser.userType == 'organization'
                  ? Color.fromARGB(255, 214, 205, 205)
                  : Colors.transparent,
              height: loggedInUser.userType == 'organization' ? 50 : 20,
              thickness: loggedInUser.userType == 'organization' ? 1 : 0,
            ),
            Row(
              children: <Widget>[
                Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'E-Posta Adresim',
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          user!.email.toString(),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 214, 205, 205),
              height: 50,
              thickness: 1,
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print("Tapped a Container");
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.only(left: 8),
                        height: 64,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: mFillColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mBorderColor, width: 1),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.notifications,
                              color: Colors.indigo,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Bildirimler',
                                    style: mServiceTitleStyle,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.only(left: 8),
                      height: 64,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: mFillColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: mBorderColor, width: 1),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.question_mark, color: Colors.indigo),
                          Padding(
                            padding: EdgeInsets.only(left: 11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Yardım ve Destek',
                                  style: mServiceTitleStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        logout(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
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
                            Icon(Icons.logout_rounded, color: Colors.indigo),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Çıkış yap',
                                    style: mServiceTitleStyle,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
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
                          Icon(Icons.person_add, color: Colors.indigo),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Davet et!',
                                  style: mServiceTitleStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

class AppBarButton extends StatelessWidget {
  final IconData icon;

  const AppBarButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kAppPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: kLightBlack,
              offset: Offset(1, 1),
              blurRadius: 10,
            ),
            BoxShadow(
              color: kWhite,
              offset: Offset(-1, -1),
              blurRadius: 10,
            ),
          ]),
      child: Icon(
        icon,
        color: fCL,
      ),
    );
  }
}

class SocialIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: RawMaterialButton(
            onPressed: () {
              launch("https://twitter.com/algoritmikfikir");
            },
            shape: CircleBorder(),
            child: FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: RawMaterialButton(
            onPressed: () {
              launch("https://www.instagram.com/algoritmikfikir/");
            },
            shape: CircleBorder(),
            child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

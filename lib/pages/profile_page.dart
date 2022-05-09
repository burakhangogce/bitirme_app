// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:core';
import 'dart:core';
import 'package:flutter_svg/svg.dart';
import 'package:bitirme_app/model/auth_service.dart';
import 'package:bitirme_app/firebase_login/login.dart';
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

  @override
  void initState() {
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
    String _copy =
        "https://play.google.com/store/apps/details?id=bukhantech.algoritmik_fikir_quiz";
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          "Hoşgeldin ${loggedInUser.username} ",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: Icon(
            Icons.arrow_back, // add custom icons also
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {
              logout(context),
            },
            icon: Icon(Icons.logout),
            color: Colors.red,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(
              color: Color.fromARGB(255, 214, 205, 205),
              height: 50,
              thickness: 1,
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
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/140x100'),
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
                          'Kullanıcı Adı',
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
                          'Mahirella',
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
                          'mahirdeneme1@gmail.com',
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
                    Container(
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
                          Icon(Icons.settings, color: Colors.indigo),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Ayarlar',
                                  style: mServiceTitleStyle,
                                ),
                              ],
                            ),
                          )
                        ],
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
                          Icon(Icons.info, color: Colors.indigo),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Bilgilerim',
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
                    Container(
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
                          Icon(Icons.message_rounded, color: Colors.indigo),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Mesajlarım',
                                  style: mServiceTitleStyle,
                                ),
                              ],
                            ),
                          )
                        ],
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
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

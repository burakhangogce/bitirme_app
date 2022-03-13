import 'dart:core';
import 'dart:core';

import 'package:bitirme_app/firebase_login/auth_service.dart';
import 'package:bitirme_app/firebase_login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
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

    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                width: 150,
                height: 150,
                padding: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/birdcanta.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '${loggedInUser.username}',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: "Poppins"),
              ),
              Text(
                'BİZİ TAKİP ET!',
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
              ),
              SizedBox(
                height: 15,
              ),
              SocialIcons(),
              SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.bell,
                        text: 'Bildirimler',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(loggedInUser.uid)
                            .get()
                            .then((value) {
                          // show the dialog
                          String startDate = value['subStartDate'];

                          showDialog(
                            context: this.context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text("BİLGİ"),
                                content: loggedInUser.userType == "free"
                                    ? Text(
                                        "Herhangi bir pakete sahip değilsiniz. Bir sorun olduğunu düşünüyorsanız bizimle iletişime geçiniz.")
                                    : Text(
                                        "Premium pakete sahipsiniz.\nPaket başlangıç tarihi: $startDate"),
                                actions: [
                                  loggedInUser.userType == "free"
                                      ? TextButton(
                                          child: Text("Satın Al"),
                                          onPressed: () {
                                            launch(
                                                'https://www.shopier.com/ShowProductNew/storefront.php?shop=algoritmikfikir&sid=dzFWRDQzcHBGOE01S2U2aDBfLTFfIF8g');
                                          },
                                        )
                                      : Container(),
                                  TextButton(
                                    child: Text("Tamam"),
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      },
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.history,
                        text: 'Abonelik bilgilerim',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launch('https://www.instagram.com/algoritmikfikir/');
                      },
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.question_circle,
                        text: 'Yardım & Destek',
                      ),
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.cog,
                      text: 'Ayarlar',
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.columns,
                        text: 'tema',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(new ClipboardData(text: _copy));
                        key.currentState!.showSnackBar(SnackBar(
                          content: new Text("Davet linki kopyalandı!"),
                        ));
                      },
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.user_plus,
                        text: 'Davet et!',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        logout(context);
                      },
                      child: ProfileListItem(
                        icon: LineAwesomeIcons.alternate_sign_out,
                        text: 'Çıkış',
                        hasNavigation: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
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

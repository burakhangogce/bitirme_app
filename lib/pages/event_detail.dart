import 'package:bitirme_app/widgets/network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_login/auth_service.dart';

class EventDetail extends StatefulWidget {
  final String eventId, eventDesc, eventTitle, eventImg, eventPlat;
  final Timestamp eventDate;

  const EventDetail(
      {Key? key,
      required this.eventId,
      required this.eventDesc,
      required this.eventDate,
      required this.eventTitle,
      required this.eventPlat,
      required this.eventImg})
      : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool join = false;

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
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('events')
        .doc(widget.eventId)
        .get()
        .then((value) {
      join = value['join'] == null ? false : value['join'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article One'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: 300,
                    width: double.infinity,
                    child: PNetworkImage(
                      widget.eventImg,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.slideshow,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Technology",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Oct 21, 2017"),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet",
                    style: TextStyle(color: Colors.black),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.favorite_border),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("20.2k"),
                      SizedBox(
                        width: 16.0,
                      ),
                      Icon(Icons.comment),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("2.2k"),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: [
                          _buildAddToCartButton(
                              '', join == false ? 'Katıl' : 'İptal'),
                          _buildAddToCartButton('', 'İletişime Geç'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Lorem ipsum dolor, sit amet consectetur adipisicing elit. Aperiam, ullam? Fuga doloremque repellendus aut sequi officiis dignissimos, enim assumenda tenetur reprehenderit quam error, accusamus ipsa? Officiis voluptatum sequi voluptas omnis. Lorem ipsum dolor, sit amet consectetur adipisicing elit. Aperiam, ullam? Fuga doloremque repellendus aut sequi officiis dignissimos, enim assumenda tenetur reprehenderit quam error, accusamus ipsa? Officiis voluptatum sequi voluptas omnis.",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildAddToCartButton(String kod, String title) {
  return Expanded(
    child: Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
        onPressed: () {},
        child: Text(title),
        color: Colors.blue.shade900,
        textColor: Colors.white,
      ),
    ),
  );
}

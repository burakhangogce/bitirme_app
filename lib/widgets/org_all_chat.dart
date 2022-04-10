import 'package:bitirme_app/widgets/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/auth_service.dart';
import '../pages/chat_room.dart';

class OrgAllChats extends StatefulWidget {
  @override
  State<OrgAllChats> createState() => _OrgAllChatsState();
}

class _OrgAllChatsState extends State<OrgAllChats> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                  color: Colors.white,
                ),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .where('uid', isEqualTo: loggedInUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final QuerySnapshot<Object?>? querySnapshot =
                          snapshot.data;

                      return snapshot.data == null
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, int index) {
                                final map = querySnapshot?.docs[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return ChatRoom(
                                        chatId: map!['chatId'],
                                        image: map['toImage'],
                                        uimage: map['uImage'],
                                        name: map['uName'],
                                        uid: loggedInUser.uid.toString(),
                                        unreadCount: map['toUnreadCount'],
                                        userType:
                                            loggedInUser.userType.toString(),
                                      );
                                    }));
                                    if (loggedInUser.userType ==
                                        'organization') {
                                      FirebaseFirestore.instance
                                          .collection('chats')
                                          .doc(map!['chatId'])
                                          .update({
                                        'uUnreadCount': 0,
                                      });
                                    } else {
                                      FirebaseFirestore.instance
                                          .collection('chats')
                                          .doc(map!['chatId'])
                                          .update({
                                        'toUnreadCount': 0,
                                      });
                                    }
                                  },
                                  child: _itemChats(
                                    avatar: 'assets/images/2.jpg',
                                    name: map!['uName'],
                                    chat: map['uText'],
                                    time: map['chatTime'],
                                  ),
                                );
                              });
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}

Widget _top() {
  return Container(
    padding: EdgeInsets.only(top: 30, left: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Katılımcılarla \nbir sohbet başlat',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black12,
              ),
              child: Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                height: 100,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Avatar(
                      margin: EdgeInsets.only(right: 15),
                      image: 'assets/images/2.jpg',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _itemChats({String avatar = '', name = '', chat = '', time = '00.00'}) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 20),
    elevation: 0,
    child: Row(
      children: [
        Avatar(
          margin: EdgeInsets.only(right: 20),
          size: 60,
          image: avatar,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$time',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$chat',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

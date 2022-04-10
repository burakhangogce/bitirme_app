import 'package:bitirme_app/model/auth_service.dart';
import 'package:bitirme_app/widgets/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String uid;
  final int unreadCount;

  const Conversation({
    Key? key,
    required this.uid,
    required this.unreadCount,
  }) : super(key: key);

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
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
    print('chatid');
    print(widget.uid);
    print('kullanıcı id');
    print(loggedInUser.uid);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.uid)
            .collection('messages')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          final QuerySnapshot<Object?>? querySnapshot = snapshot.data;

          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, int index) {
                    final map = querySnapshot?.docs[index];

                    bool isMe;
                    loggedInUser.userType == "organization"
                        ? isMe = map!['id'] == widget.uid
                        : isMe = map!['id'] != widget.uid;

                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: !isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (isMe)
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(map['image']),
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.6),
                                decoration: BoxDecoration(
                                    color: !isMe
                                        ? MyTheme.kAccentColor
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                      bottomLeft:
                                          Radius.circular(!isMe ? 12 : 0),
                                      bottomRight:
                                          Radius.circular(!isMe ? 0 : 12),
                                    )),
                                child: Text(
                                  map['text'],
                                  style: MyTheme.bodyTextMessage.copyWith(
                                      color: isMe
                                          ? Colors.grey[800]
                                          : Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: !isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isMe)
                                  SizedBox(
                                    width: 40,
                                  ),
                                index == 0
                                    ? Icon(
                                        Icons.done_all,
                                        size: 20,
                                        color: widget.unreadCount != 0
                                            ? MyTheme.bodyTextTime.color
                                            : Colors.green,
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  map['time'],
                                  style: MyTheme.bodyTextTime,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
        });
  }
}

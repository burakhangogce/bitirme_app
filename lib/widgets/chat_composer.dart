import 'package:bitirme_app/widgets/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Container buildChatComposer(String uid, chatid, image, userType) {
  TextEditingController textController = TextEditingController();

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: Colors.white,
    height: 100,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.grey[500],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your message ...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        GestureDetector(
          onTap: () {
            if (textController.text != "") {
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatid)
                  .collection('messages')
                  .add({
                'text': textController.text.toString(),
                'time': '${DateTime.now().hour} : ${DateTime.now().minute}',
                'timeStamp': Timestamp.now(),
                'image': image,
                'id': uid
              });
              if (userType == 'organization') {
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatid)
                    .update({
                  'toUnreadCount': FieldValue.increment(1),
                  'toText': textController.text.toString(),
                  'chatTime':
                      '${DateTime.now().hour} : ${DateTime.now().minute}',
                  'uUnreadCount': 0,
                });
              } else {
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatid)
                    .update({
                  'uUnreadCount': FieldValue.increment(1),
                  'uText': textController.text.toString(),
                  'chatTime':
                      '${DateTime.now().hour} : ${DateTime.now().minute}',
                  'toUnreadCount': 0,
                });
              }
            }

            textController.clear();
          },
          child: CircleAvatar(
            backgroundColor: MyTheme.kAccentColor,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );
}

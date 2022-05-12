import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget buildAddToCartButton(
    String kod,
    String title,
    String uid,
    String eventId,
    Timestamp eventDate,
    String eventDesc,
    String eventTitle,
    String eventPlat,
    String eventImg,
    String eventDuration,
    String eventSubject) {
  return Container(
    color: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    child: FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      onPressed: () {},
      child: Text(title),
      color: Colors.blue.shade900,
      textColor: Colors.white,
    ),
  );
}

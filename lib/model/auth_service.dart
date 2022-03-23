import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? username;
  String? userType;
  int? puan;

  Timestamp? timestamp;

  UserModel({
    this.uid,
    this.email,
    this.username,
    this.timestamp,
    this.userType,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      timestamp: map['timestamp'],
      userType: map['userType'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'userType': userType,
      'timestamp': timestamp,
    };
  }
}

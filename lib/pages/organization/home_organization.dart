import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../../model/auth_service.dart';

class OrganizationHome extends StatefulWidget {
  const OrganizationHome({Key? key}) : super(key: key);

  @override
  State<OrganizationHome> createState() => _OrganizationHomeState();
}

class _OrganizationHomeState extends State<OrganizationHome> {
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
  }

  String date = "";
  DateTime selectedDate = DateTime.now();
  TextEditingController eventDescController = new TextEditingController();
  TextEditingController eventPlatController = new TextEditingController();
  TextEditingController eventSubjectController = new TextEditingController();
  TextEditingController eventTitleController = new TextEditingController();
  final userRef = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });

    print("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}");
  }

  createNewMessage() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: <Widget>[
                        new Text("DÜZENLE"),
                        Container(
                          height: 20,
                        ),
                        TextField(
                          controller: eventTitleController,
                          obscureText: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                            hintText: 'Başlık',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        TextField(
                          controller: eventDescController,
                          obscureText: false,
                          textAlign: TextAlign.left,
                          readOnly: false,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            hintText: 'Açıklama',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text("Choose Date"),
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            FlatButton(
                                child: Text("İptal"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            FlatButton(
                                child: Text("Kaydet"),
                                onPressed: () {
                                  String eventId = randomAlphaNumeric(16);

                                  FirebaseFirestore.instance
                                      .collection('events')
                                      .doc(eventId)
                                      .set({
                                    'eventDate': selectedDate,
                                    'eventDesc': eventDescController.text,
                                    'eventId': eventId,
                                    'eventImg': '',
                                    'eventStatus': false,
                                    'eventLink': '',
                                    'eventOrg': loggedInUser.username,
                                    'eventOrgId': loggedInUser.uid,
                                    'eventOrgImg': '',
                                    'eventPlat': eventPlatController.text,
                                    'eventSubject': eventSubjectController.text,
                                    'eventTime': selectedDate,
                                    'eventTitle': eventTitleController.text
                                  });
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: createNewMessage),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../../model/auth_service.dart';

class EditEvent extends StatefulWidget {
  final String eventId,
      eventDesc,
      eventTitle,
      eventLink,
      eventImg,
      eventPlat,
      eventDuration,
      eventCat;
  final Timestamp eventDate;
  final bool eventStatus;

  const EditEvent(
      {Key? key,
      required this.eventId,
      required this.eventDesc,
      required this.eventDate,
      required this.eventTitle,
      required this.eventPlat,
      required this.eventImg,
      required this.eventLink,
      required this.eventDuration,
      required this.eventStatus,
      required this.eventCat})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String orgImgUrl = "", orgTitle = "";

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
        .collection('organizations')
        .doc(user!.uid)
        .get()
        .then((value) => {
              setState(() {
                orgImgUrl = value['orgImg'];
                orgTitle = value['orgTitle'];
              }),
            });
  }

  String date = "";
  DateTime selectedDate = DateTime.now();
  TextEditingController eventTitleCont = new TextEditingController();
  TextEditingController eventDescCont = new TextEditingController();
  TextEditingController eventImgCont = new TextEditingController();
  TextEditingController eventLinkCont = new TextEditingController();
  TextEditingController eventDurationCont = new TextEditingController();
  String dropdownValue = 'Youtube';

  final userRef = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;
  var option = null;

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: widget.eventDate.toDate(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });

    print("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    eventTitleCont.text = widget.eventTitle;
    eventDescCont.text = widget.eventDesc;
    eventImgCont.text = widget.eventImg;
    eventLinkCont.text = widget.eventLink;
    eventDurationCont.text = widget.eventDuration;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Oluştur'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: eventTitleCont,
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
              controller: eventDescCont,
              obscureText: false,
              textAlign: TextAlign.left,
              readOnly: false,
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                border: OutlineInputBorder(),
                hintText: 'Açıklama',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              height: 20,
            ),
            TextField(
              controller: eventImgCont,
              obscureText: false,
              textAlign: TextAlign.left,
              readOnly: false,
              decoration: InputDecoration(
                icon: Icon(Icons.image),
                border: OutlineInputBorder(),
                hintText: 'Resim',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              height: 20,
            ),
            TextField(
              controller: eventLinkCont,
              obscureText: false,
              textAlign: TextAlign.left,
              readOnly: false,
              decoration: InputDecoration(
                icon: Icon(Icons.image),
                border: OutlineInputBorder(),
                hintText: 'Link',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              height: 20,
            ),
            TextField(
              controller: eventDurationCont,
              obscureText: false,
              textAlign: TextAlign.left,
              readOnly: false,
              decoration: InputDecoration(
                icon: Icon(Icons.image),
                border: OutlineInputBorder(),
                hintText: 'Süre (dk)',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tarih:"),
                ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                      setState(() {
                        selectedDate;
                      });
                    },
                    child: Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Kategori: "),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categorys')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    // Safety check to ensure that snapshot contains data
                    // without this safety check, StreamBuilder dirty state warnings will be thrown
                    if (!snapshot.hasData) return Container();
                    // Set this value for default,
                    // setDefault will change if an item was selected
                    // First item from the List will be displayed

                    return DropdownButton(
                      isExpanded: false,
                      //value: snapshot.data!.docs[0].get('categoryTitle'),
                      value: widget.eventCat,
                      items: snapshot.data!.docs.map((value) {
                        return DropdownMenuItem(
                          value: value.get('categoryTitle'),
                          child: Text('${value.get('categoryTitle')}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        debugPrint('selected onchange: $value');
                        setState(() {
                          option = value;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Platform: "),
                DropdownButton<String>(
                  // Step 3.
                  value: dropdownValue,
                  // Step 4.
                  items: <String>['Teams', 'Zoom', 'Youtube']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                  // Step 5.
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    color: Colors.blueGrey,
                    child: Text(
                      "İptal",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('events')
                          .doc(widget.eventId)
                          .update({'eventStatus': widget.eventStatus});
                    },
                    color: Colors.blueGrey,
                    child: Text(
                      widget.eventStatus == true ? "Pasif Et!" : "Aktif Et!",
                      style: TextStyle(color: Colors.white),
                    )),
                FlatButton(
                    color: Colors.blueGrey,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (option == null ||
                          eventDescCont == null ||
                          eventTitleCont == null ||
                          eventImgCont == null) {
                        final snackBar = SnackBar(
                          content: const Text('Eksik bilgileri tamamla!'),
                          action: SnackBarAction(
                            label: 'Tamam',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (option == '' ||
                          eventDescCont == '' ||
                          eventTitleCont == '' ||
                          eventImgCont == '') {
                        final snackBar = SnackBar(
                          content: const Text('Eksik bilgileri tamamla!'),
                          action: SnackBarAction(
                            label: 'Tamam',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        FirebaseFirestore.instance
                            .collection('events')
                            .doc(widget.eventId)
                            .update({
                          'eventDate': selectedDate,
                          'eventDesc': eventDescCont.text,
                          'eventImg': eventImgCont.text,
                          'eventStatus': false,
                          'eventLink': eventLinkCont.text,
                          'eventOrg': loggedInUser.username,
                          'eventOrgId': loggedInUser.uid,
                          'eventOrgImg': orgImgUrl,
                          'eventPlat': dropdownValue,
                          'eventCat': option,
                          'eventTime': selectedDate,
                          'eventDuration': eventDurationCont.text,
                          'eventTitle': eventTitleCont.text
                        });
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

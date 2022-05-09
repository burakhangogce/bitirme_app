import 'package:bitirme_app/firebase_login/login.dart';
import 'package:bitirme_app/pages/first_page.dart';
import 'package:bitirme_app/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/auth_service.dart';

class RegistrationOrganizationScreen extends StatefulWidget {
  const RegistrationOrganizationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationOrganizationScreenState createState() =>
      _RegistrationOrganizationScreenState();
}

class _RegistrationOrganizationScreenState
    extends State<RegistrationOrganizationScreen> {
  final _auth = FirebaseAuth.instance;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Organizasyon adı boş geçilemez");
          }
          if (!regex.hasMatch(value)) {
            return ("Geçerli organizasyon adı girin(Min. 3 Karakter)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Organizasyon adı",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Şifre eşleşmiyor";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Şifreyi Onayla",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            _scaffoldKey.currentState!.showSnackBar(new SnackBar(
              duration: new Duration(seconds: 1),
              content: new Row(
                children: <Widget>[
                  new CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                  new Text(
                    "  Giriş yapılıyor...",
                    style: TextStyle(color: Colors.deepPurple),
                  )
                ],
              ),
            ));
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            "Kayıt ol",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.blue.shade400])),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 180,
                          child: Image.asset(
                            "images/birdgrup.png",
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 45),
                      firstNameField,
                      SizedBox(height: 20),
                      emailField,
                      SizedBox(height: 20),
                      passwordField,
                      SizedBox(height: 20),
                      confirmPasswordField,
                      SizedBox(height: 20),
                      signUpButton,
                      SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Zaten bir hesabın var mı?"),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text(
                                "Giriş",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                  "Bir kullanıcı hesabı mı oluşturmak istiyorsunuz?"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Kullanıcı hesabı oluştur",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showErrorSnack(String message) {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        "$message",
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        if (e.code == 'wrong-password') {
          _showErrorSnack("Yanlış e-posta/şifre kombinasyonu.");
        } else if (e.code == 'email-already-in-use') {
          _showErrorSnack(
              "Bu E-mail zaten kullanılmış. Giriş sayfasına gidin.");
        } else if (e.code == 'user-not-found') {
          _showErrorSnack("Bu e-posta ile kullanıcı bulunamadı.");
        } else if (e.code == 'user-disabled') {
          _showErrorSnack("Kullanıcı devre dışı bırakıldı.");
        } else if (e.code == 'invalid-email') {
          _showErrorSnack("Email adresi geçersiz.");
        } else {
          _showErrorSnack("Giriş başarısız. Lütfen tekrar deneyin.");
        }
      });
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel(
        email: user!.email,
        uid: user.uid,
        username: firstNameEditingController.text,
        timestamp: Timestamp.now(),
        userType: "organization");

    // writing all the values
    userModel.email = user.email!;
    userModel.uid = user.uid;
    userModel.username = firstNameEditingController.text;

    userModel.timestamp = Timestamp.now();
    userModel.userType = "organization";

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    FirebaseFirestore.instance.collection('organizations').doc(user.uid).set({
      'orgImg': "",
      'email': user.email,
      'orgId': user.uid,
      'orgDesc': '',
      'orgTitle': firstNameEditingController.text
    });

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}

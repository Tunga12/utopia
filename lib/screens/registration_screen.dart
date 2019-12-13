import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utopia/components/rounded_button.dart';
import 'package:utopia/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utopia/models/user.dart';
import 'package:utopia/screens/store-page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Container(
              //   height: 200.0,
              //   child: Image.asset('assets/logo.png'),
              // ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser.user != null) {
                      // create a user object
                      await _firestore.collection('users').add(
                        User(
                          uid: newUser.user.uid,
                          email: newUser.user.email,
                          boughtSongs: {},
                          language: {},
                          genre: {},
                          artist: {},
                          category: {}
                        ).toMap()
                      );
                      // navigate to store
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StorePage()));
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

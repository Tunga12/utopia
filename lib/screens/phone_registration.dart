import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utopia/components/rounded_button.dart';
import 'package:utopia/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:utopia/models/user.dart';
import 'package:utopia/screens/store-page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PhoneRegistrationScreen extends StatefulWidget {
  @override
  _PhoneRegistrationScreenState createState() =>
      _PhoneRegistrationScreenState();
}

class _PhoneRegistrationScreenState extends State<PhoneRegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  bool showSpinner = false;

  String phoneNo;
  String smsCode;
  String verificationId;
 
  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
 
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };
 
    final Function(AuthCredential user) verifiedSuccess = (AuthCredential user) {
      print('verified');
    };
 
    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

     await _auth.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter sms Code'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StorePage()));
                    } else {
                      Navigator.of(context).pop();
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }
 
  signIn() async {
    // _auth
    //     .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
    //     .then((user) {
    //   Navigator.of(context).pushReplacementNamed('/homepage');
    // }).catchError((e) {
    //   print(e);
    // });

    AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);

    await _auth
      .signInWithCredential(authCredential)
      .then((AuthResult result) async {
         final FirebaseUser currentUser = await _auth.currentUser();
         assert(result.user.uid == currentUser.uid);
         await _firestore.collection('users').add(User(
                          uid: result.user.uid,
                          boughtSongs: {},
                          language: {},
                          genre: {},
                          artist: {},
                          category: {}).toMap());
         print('signed in with phone number successful: user -> ${result.user}');
    });
  }

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
              Flexible(
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  phoneNo = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your phone number'),
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
                    await verifyPhone();
                    // if (newUser.user != null) {
                      // create a user object
                      // await _firestore.collection('users').add(User(
                      //     uid: newUser.user.uid,
                      //     boughtSongs: {},
                      //     language: {},
                      //     genre: {},
                      //     artist: {},
                      //     category: {}).toMap());
                      // navigate to store
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => StorePage()));
                    // }

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

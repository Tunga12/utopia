import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utopia/screens/gift_list.dart';
import 'package:utopia/screens/login_screen.dart';
import 'package:utopia/screens/my-library.dart';
import 'package:utopia/screens/phone_registration.dart';
// import 'package:utopia/screens/now-playing.dart';
import 'package:utopia/screens/registration_screen.dart';
import 'package:utopia/screens/store-page.dart';

class MyDrawer extends StatefulWidget {

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() { 
    super.initState();
    _getCurrentUser();
  }

  Future _getCurrentUser() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
          print(loggedInUser.email);
        });
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print('in get current user');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('Menu'),
                    decoration: BoxDecoration(
                      color: Color(0x555468FF),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.shop),
                    title: Text('Store'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StorePage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.library_music),
                    title: Text('My Library'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLibraryPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.play_circle_filled),
                    title: Text('Log out'),
                    onTap: () {
                      _auth.signOut();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Login'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Register'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Phone Registration'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneRegistrationScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Your gifts'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GiftList(user: loggedInUser,)));
                    },
                  ),
                ],
              ),
            );
  }
}
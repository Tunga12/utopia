import 'package:flutter/material.dart';
import 'package:utopia/screens/login_screen.dart';
import 'package:utopia/screens/my-library.dart';
// import 'package:utopia/screens/now-playing.dart';
import 'package:utopia/screens/registration_screen.dart';
import 'package:utopia/screens/store-page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('Menu'),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
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
                    title: Text('Now Playing'),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => NowPlayingPage()));
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
                ],
              ),
            );
  }
}
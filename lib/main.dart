import 'package:flutter/material.dart';
import 'package:utopia/screens/store-page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Utopia',
      theme: ThemeData(
        // primaryColor: Color(0xFF282C4B),
        primaryColor: Color(0xFFFEFEFE),
        accentColor: Color(0xFF5468FF),
        // textTheme: TextTheme(
        //   body1: TextStyle(
        //     color: Color(0xFFFEFEFE),
        //   ),
        // ),
      ),
      home: StorePage(),
    );
  }
}


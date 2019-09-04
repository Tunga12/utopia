import 'package:flutter/material.dart';
import 'package:utopia/screens/store-page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utopia',
      theme: ThemeData(primaryColor: Colors.white),
      home: StorePage(),
    );
  }
}


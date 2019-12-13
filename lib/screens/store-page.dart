import 'package:flutter/material.dart';
import 'package:utopia/screens/home-store.dart';
import 'package:utopia/screens/my-drawer.dart';
import 'package:utopia/screens/search.dart';

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store', style: TextStyle(),),
        elevation: 0,
        iconTheme: new IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xff5468FF),
            ),
            onPressed: () {
              showSearch(context: context, delegate: SearchPage());
            },
          )
        ],
      ),
      body: HomeStorePage(),
      drawer: MyDrawer(),
    );
  }
}

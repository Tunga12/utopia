import 'package:flutter/material.dart';
import 'package:utopia/screens/home-store.dart';
import 'package:utopia/screens/my-drawer.dart';
import 'package:utopia/screens/search.dart';

class StorePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Store'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.album)),
                Tab(icon: Icon(Icons.music_note)),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchPage());
                },
              )
            ],
          ),
          body: TabBarView(
            children: [
              HomeStorePage(),
              Icon(Icons.album),
              // AlbumPage(),
              Icon(Icons.music_note),
            ],
          ),
          drawer: MyDrawer(),
        ));
  }
}

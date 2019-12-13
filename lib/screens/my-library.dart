import 'package:flutter/material.dart';
import 'package:utopia/screens/library-album.dart';
import 'package:utopia/screens/library-artist.dart';
import 'package:utopia/screens/library-playlist.dart';
import 'package:utopia/screens/library-song.dart';
import 'package:utopia/screens/my-drawer.dart';

class MyLibraryPage extends StatefulWidget {
  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Library'),
          elevation: 0,
          iconTheme: new IconThemeData(color: Color(0xff5468FF)),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.music_note)),
              Tab(icon: Icon(Icons.playlist_play)),
              Tab(icon: Icon(Icons.album)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search,),
              onPressed: () {
                // showSearch(context: context, delegate: SearchPage());
              },
            )
          ],
        ),
        body: TabBarView(
          children: [
            LibrarySongPage(), 
            LibraryPlaylistPage(),
            LibraryAlbumPage(),
            LibraryArtistPage(),

          ],
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}

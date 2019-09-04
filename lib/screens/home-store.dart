// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:utopia/models/album.dart';
import 'package:utopia/screens/album_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

final _firestore = Firestore.instance;

class HomeStorePage extends StatefulWidget {
  @override
  _HomeStorePageState createState() => _HomeStorePageState();
}

class _HomeStorePageState extends State<HomeStorePage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // albumsStream();
  }

  void albumsStream() async {
    await for (var snapshot in _firestore.collection('albums').snapshots()) {
      for (var album in snapshot.documents) {
        print(album.data);
      }
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            'NEW RELEASES',
            style: TextStyle(
                color: Colors.black45,
                fontFamily: 'Source Sans Pro',
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            height: 160,
            child: _albumCardsFromStream(),
          ),
          Text(
            'DISCOVER',
            style: TextStyle(
                color: Colors.black45,
                fontFamily: 'Source Sans Pro',
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            height: 160,
            child: _albumCards(),
          ),
          Text(
            'TOP CHARTS',
            style: TextStyle(
                color: Colors.black45,
                fontFamily: 'Source Sans Pro',
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            height: 160,
            child: _albumCards(),
          ),
        ],
      ),
    );
  }

  Widget _albumCardsFromStream() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('albums').snapshots(),
        builder: (conetxt, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final albums = snapshot.data.documents;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            itemCount: albums.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  width: 100,
                  child: GestureDetector(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              // child: Image.network(albums[index].data['image']),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    Image.asset('assets/placeholderAlbum.png'),
                                imageUrl:
                                    albums[index].data['image'].toString(),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/placeholderAlbum.png'),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              albums[index].data['albumName'],
                              style: TextStyle(color: Colors.black87),
                            ),
                            Text(
                              albums[index].data['artistName'],
                              style: TextStyle(color: Colors.black26),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlbumPage(
                                  albumDoc: albums[index],
                                  loggedInUser: loggedInUser)));
                    },
                  ));
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 10.0,
            ),
          );
        });
  }
}

Widget _albumCards() {
  final List<String> entries = <String>['A', 'B', 'C', 'D'];

  return ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.all(8.0),
    itemCount: entries.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
          width: 100,
          child: GestureDetector(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset('assets/sample.jpg'),
                    SizedBox(height: 5.0),
                    Text(
                      'Album 1',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(
                      'Artist 1',
                      style: TextStyle(color: Colors.black26),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AlbumPage()));
            },
          ));
    },
    separatorBuilder: (BuildContext context, int index) => const SizedBox(
      width: 10.0,
    ),
  );
}

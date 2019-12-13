// import 'dart:convert';

import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utopia/components/custom_card.dart';
// import 'package:utopia/models/album.dart';
import 'package:utopia/models/user.dart';
// import 'package:utopia/models/album.dart';
import 'package:utopia/screens/album_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:utopia/screens/login_screen.dart';

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
    _getCurrentUser();
    // albumsStream();
  }

  // void albumsStream() async {
  //   await for (var snapshot in _firestore.collection('albums').snapshots()) {
  //     for (var album in snapshot.documents) {
  //       print(album.data);
  //     }
  //   }
  // }

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
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            'NEW RELEASES',
            style: TextStyle(
              color: Color(0xFF5468FF),
              fontFamily: 'Source Sans Pro',
              letterSpacing: 1.5,
            ),
          ),
          Container(
            height: 160,
            child: _albumCardsFromStream(),
          ),
          Text(
            'DISCOVER',
            style: TextStyle(
              color: Color(0xFF5468FF),
              fontFamily: 'Source Sans Pro',
              letterSpacing: 1.5,
            ),
          ),
          Container(height: 160, child: _discover()),
          Text(
            'TOP CHARTS',
            style: TextStyle(
              color: Color(0xFF5468FF),
              fontFamily: 'Source Sans Pro',
              letterSpacing: 1.5,
            ),
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
                    child: CustomCard(
                      imagePath: albums[index].data['image'].toString(),
                      albumName: albums[index].data['albumName'],
                      artistName: albums[index].data['artistName'],
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

  Future<List<DocumentSnapshot>> _randomAlbums(String userId) async {
    print('uid: $userId');

    // processing
    QuerySnapshot userMap = await _firestore
        .collection('users')
        .where('uid', isEqualTo: userId)
        .limit(1)
        .getDocuments();

    print(userMap.documents.first.data);

    User user = User.fromMap(userMap.documents.first.data);

    //generate random numbers
    var rnd = new Random();
    List<int> randomList = new List.generate(2, (_) => rnd.nextInt(10000));
    print("${randomList.first}, ${randomList[1]}");

    // reseed, get a number between 1 and 3
    // var randNum = Random().nextInt(3) + 1;
    // print(randNum);

    // by category
    List<String> categories = user.category.keys.toList();

    List<DocumentSnapshot> albumsBasedOnCategory = [];
    for (String category in categories) {
      // i need to make it random
      QuerySnapshot query = await _firestore
          .collection('albums')
          .where('category', isEqualTo: category)
          .where('random', isLessThanOrEqualTo: randomList.first)
          .limit(3)
          .getDocuments();
      albumsBasedOnCategory.addAll(query.documents);

      // print(query.documents.length);

      // if (query.documents.length < 3) {
      //   query = await _firestore
      //       .collection('albums')
      //       .where('category', isEqualTo: category)
      //       .where('random', isGreaterThan: randomList.first)
      //       .limit(3 - query.documents.length)
      //       .getDocuments();
      //   albumsBasedOnCategory.addAll(query.documents);
      // }
    }

    // by artist
    List<String> artistIds = user.artist.keys.toList();

    List<DocumentSnapshot> albumsBasedOnArtist = [];
    for (String artistId in artistIds) {
      // i need to make it random
      QuerySnapshot query = await _firestore
          .collection('albums')
          .where('artist', isEqualTo: artistId)
          .where('random', isLessThanOrEqualTo: randomList[1])
          .limit(3)
          .getDocuments();
      albumsBasedOnArtist.addAll(query.documents);

      // print(query.documents.length);

      // if (query.documents.length < 3) {
      //   query = await _firestore
      //       .collection('albums')
      //       .where('artist', isEqualTo: artistId)
      //       .where('random', isGreaterThan: randomList[1])
      //       .limit(3 - query.documents.length)
      //       .getDocuments();
      //   albumsBasedOnArtist.addAll(query.documents);
      // }
    }

    // by genre
    List<String> genres = user.genre.keys.toList();

    List<DocumentSnapshot> albumsBasedOnGenre = [];
    // for (String genre in genres) {
    //   // i need to make it random
    //   QuerySnapshot query = await _firestore
    //       .collection('albums')
    //       .where('genre', isEqualTo: genre)
    //       .where('random', isLessThanOrEqualTo: randomList[2])
    //       .limit(3)
    //       .getDocuments();
    //   albumsBasedOnGenre.addAll(query.documents);
    // }

    // by language
    List<String> languages = user.language.keys.toList();

    List<DocumentSnapshot> albumsBasedOnLanguage = [];
    // for (String language in languages) {
    //   // i need to make it random
    //   QuerySnapshot query = await _firestore
    //       .collection('albums')
    //       .where('language', isEqualTo: language)
    //       .where('random', isLessThanOrEqualTo: randomList[3])
    //       .limit(3)
    //       .getDocuments();
    //   albumsBasedOnLanguage.addAll(query.documents);
    // }

    List<DocumentSnapshot> albumsTotal = [
      ...albumsBasedOnArtist,
      ...albumsBasedOnCategory,
      ...albumsBasedOnGenre,
      ...albumsBasedOnLanguage
    ];

    print('albums randomly');
    for (var doc in albumsTotal) {
      print(doc.data['artistName']);
    }

    // List<Album> albums = albumsTotal.cast<Album>();
    return albumsTotal;
  }

  Widget _discover() {
    return FutureBuilder<List<DocumentSnapshot>>(
        future: _randomAlbums(loggedInUser.uid),
        builder: (conetxt, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          List<DocumentSnapshot> albums = snapshot.data;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            itemCount: albums.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  width: 100,
                  child: GestureDetector(
                    child: CustomCard(
                        imagePath: albums[index].data['image'].toString(),
                        albumName: albums[index].data['albumName'],
                        artistName: albums[index].data['artistName']),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlbumPage(
                                  albumDoc: snapshot.data[index],
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
            child: CustomCard(
              imagePath:
                  'https://cdn.pixabay.com/photo/2019/09/11/21/47/autumn-4470022_960_720.jpg',
              albumName: 'Album 1',
              artistName: 'Artist 1',
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

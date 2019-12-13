import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:utopia/models/artist.dart';

// import 'album_page.dart';

class Sample {
  String title;
}

class SearchPage extends SearchDelegate<Sample> {
  // final _firestore = Firestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Color(0xff5468FF),),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Color(0xff5468FF)),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      // shrinkWrap: true,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   'ARTISTS',
            //   style: TextStyle(
            //       color: Colors.black45,
            //       fontFamily: 'Source Sans Pro',
            //       letterSpacing: 1.5,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16.0),
            // ),
            SizedBox(
              height: 10.0,
            ),
            _artistResults(query),
            SizedBox(
              height: 10.0,
            ),
            // Text(
            //   'ALBUMS',
            //   style: TextStyle(
            //       color: Colors.black45,
            //       fontFamily: 'Source Sans Pro',
            //       letterSpacing: 1.5,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16.0),
            // ),
            _albumResults(query),
          ],
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

Widget _artistResults(String query) {
  return FutureBuilder(
    future: _searchArtist(query),
    builder: (context, AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
      if (!snapshot.hasData) {
        return Container();
      }

      // return ListView.builder(
      //   shrinkWrap: true,
      //   itemCount: snapshot.data.length,
      //   itemBuilder: (BuildContext ctx, int index) {
      //     AlgoliaObjectSnapshot snap = snapshot.data[index];

      //     return ListTile(
      //       leading: CircleAvatar(
      //         child: Text(
      //           (index + 1).toString(),
      //         ),
      //       ),
      //       title: Text(snap.data["name"]),
      //     );
      //   },
      // );

      List<Widget> listItems = [];
      for (var snap in snapshot.data) {
        listItems.add(ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(snap.data["name"]),
        ));
      }

      return ListBody(
        children: [
          Text(
            'ARTISTS',
            style: TextStyle(
                color: Colors.black45,
                fontFamily: 'Source Sans Pro',
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          ...listItems,
        ],
      );
    },
  );
}

Future<List<AlgoliaObjectSnapshot>> _searchArtist(String text) async {
  Algolia algolia = Algolia.init(
    applicationId: 'D04OGQVLK4',
    apiKey: '414dfa5ecaf4d1e5eacb457c2e181a07',
  );

  AlgoliaQuery query = algolia.instance.index('artist');
  query = query.search(text);

  List<AlgoliaObjectSnapshot> results = (await query.getObjects()).hits;

  print(results);
  return results;
}

Widget _albumResults(String query) {
  return FutureBuilder(
      future: _searchAlbum(query),
      builder: (context, AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        List<Widget> listItems = [];
        for (var snap in snapshot.data) {
          listItems.add(Column(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        Image.asset('assets/placeholderAlbum.png'),
                    imageUrl: snap.data['image'].toString(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/placeholderAlbum.png'),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                snap.data['albumName'],
                style: TextStyle(color: Colors.black87),
              ),
              Text(
                snap.data['artistName'],
                style: TextStyle(color: Colors.black26),
              )
            ],
          ));
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'ALBUMS',
              style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'Source Sans Pro',
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: listItems,
            ),
          ],
        );
      });
}

Future<List<AlgoliaObjectSnapshot>> _searchAlbum(String text) async {
  Algolia algolia = Algolia.init(
    applicationId: 'D04OGQVLK4',
    apiKey: '414dfa5ecaf4d1e5eacb457c2e181a07',
  );

  AlgoliaQuery query = algolia.instance.index('album');
  query = query.search(text);

  List<AlgoliaObjectSnapshot> results = (await query.getObjects()).hits;

  print(results);
  return results;
}

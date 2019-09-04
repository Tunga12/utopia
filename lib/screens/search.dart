import 'package:flutter/material.dart';

class Sample {
  String title;
}

class SearchPage extends SearchDelegate<Sample> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ARTISTS',
              style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'Source Sans Pro',
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            _artistResults(),
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

Widget _artistResults() {
  return Column(
    children: <Widget>[
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.blue[100],
        ),
        title: Text('Artist 1'),
      ),
      SizedBox(
        height: 5.0,
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.blue[100],
        ),
        title: Text('Artist 2'),
      )
    ],
  );
}

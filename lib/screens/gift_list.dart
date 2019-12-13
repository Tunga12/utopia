import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utopia/screens/album_page.dart';

class GiftList extends StatefulWidget {
  final FirebaseUser user;
  GiftList({@required this.user});

  @override
  _GiftListState createState() => _GiftListState();
}

class _GiftListState extends State<GiftList> {
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('gifts')
            .where('to', isEqualTo: widget.user.uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("You have no gifts"),
            );
          }
          List<DocumentSnapshot> gifts = snapshot.data.documents;

          return Container(
            child: ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (BuildContext context, int index) {
                // var gift = gifts[index].data;

                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.card_giftcard,
                        color: Color(0xff5468FF),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text(gifts[index].data['note'].toString()),
                      subtitle: Text(
                          "From: ${gifts[index].data['senderEmail'].toString()}"),
                      onTap: () async {
                        // go to download gift page
                        DocumentSnapshot albumDoc = await _firestore.collection('albums').document(gifts[index].data['albumId']).get();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumPage(
                                    albumDoc: albumDoc,
                                    loggedInUser: widget.user)));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.attachment),
                          Text(gifts[index].data['contentName'].toString())
                        ],
                      ),
                    ),
                    Divider()
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

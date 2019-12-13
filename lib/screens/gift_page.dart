import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:utopia/models/media.dart';
import 'package:utopia/models/user.dart';

class GiftPage extends StatefulWidget {
  final FirebaseUser sender;
  final DocumentSnapshot albumDoc;
  final Media media;
  final bool isAlbum;
  GiftPage(
      {@required this.sender,
      @required this.albumDoc,
      this.media,
      @required this.isAlbum});

  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  Firestore _firestore = Firestore.instance;
  // FirebaseAuth _auth = FirebaseAuth.instance;

  bool emailExists = true;
  bool showSpinner = false;

  String email;
  String note;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Center(
                        child: Text("Utopia",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                      ),
                      Center(
                        child: Text(
                          "Gift Card",
                          style: TextStyle(
                              fontFamily: 'Courgette',
                              color: Color(0xff5468FF),
                              fontSize: 50),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    elevation: 10,
                    color: Color(0xff282C4B),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Utopia",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              Text("Gift Card",
                                  style: TextStyle(
                                    fontFamily: 'Courgette',
                                    color: Color(0xff5468FF),
                                    fontSize: 15,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              widget.isAlbum
                                  ? Text("Gift an album",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ))
                                  : Text("Gift a song",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      )),
                              widget.isAlbum
                                  ? Text("15 birr",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ))
                                  : Text("5 birr",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100,
                            child: Image.asset('assets/placeholderAlbum.png'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Enter details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter recipient's email",
                          ),
                          onChanged: (value) {
                            email = value;
                          }),
                      TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter a message for your loved one",
                          ),
                          onChanged: (value) {
                            note = value;
                          }),
                      SizedBox(
                        height: 20,
                        child: emailExists == false
                            ? Text(
                                'Email does not exist.',
                                style: TextStyle(color: Colors.red),
                              )
                            : null,
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: () async {
                            await _giveAgift(email, note);
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF282C4B),
                                  Color(0xFF5468FF),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('Proceed',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _giveAgift(String email, String note) async {
    setState(() {
      showSpinner = true;
    });
    // check if email exists
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();

    User user;

    if (query.documents.length == 0) {
      // email does not exist
      setState(() {
        emailExists = false;
        showSpinner = false;
      });
    } else {
      user = User.fromMap(query.documents.first.data);

      List medias = [];
      if (widget.isAlbum) {
        for (var media in widget.albumDoc.data['medias']) {
          medias.add({'id': media['id'], 'name': media['name']});
        }
      } else {
        medias.add({'id': widget.media.id, 'name': widget.media.name});
      }

      String type;
      widget.isAlbum ? type = 'album' : type = 'media';

      String contentName;
      type == 'album'
          ? contentName = widget.albumDoc.data['albumName']
          : contentName = widget.media.name;

      await _firestore.collection('gifts').add({
        'from': widget.sender.uid,
        'to': user.uid,
        'albumId': widget.albumDoc.documentID,
        'medias': medias,
        'date': DateTime.now(),
        'note': note,
        'senderEmail': widget.sender.email,
        'contentName': contentName,
        'type': type
      });

      setState(() {
        showSpinner = false;
      });
    }
  }
}

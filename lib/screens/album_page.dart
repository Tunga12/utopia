// import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utopia/models/media.dart';
import 'package:utopia/models/user.dart';
// import 'package:dio/dio.dart';
import 'package:utopia/providers/album_dao.dart';
import 'package:utopia/providers/payment_service.dart';
import 'package:utopia/screens/gift_page.dart';
import 'package:utopia/screens/login_screen.dart';
// import 'package:utopia/providers/db_provider.dart';
import 'package:utopia/utilities/util.dart';
import 'package:utopia/models/album.dart';
import 'package:stripe_payment/stripe_payment.dart';

// final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class AlbumPage extends StatefulWidget {
  const AlbumPage({@required this.albumDoc, @required this.loggedInUser});

  final DocumentSnapshot albumDoc;
  final FirebaseUser loggedInUser;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_dTVWBYdVdlTlhTIFcAoe5GAQ008iyPBtUp",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        iconTheme: new IconThemeData(color: Color(0xff5468FF)),
        title: ListTile(
          title: Text(widget.albumDoc.data['albumName']),
          subtitle: Text(widget.albumDoc.data['artistName']),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          Image.asset('assets/placeholderAlbum.png'),
                      imageUrl: widget.albumDoc.data['image'],
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/placeholderAlbum.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(widget.albumDoc.data['albumName']),
                      SizedBox(height: 10.0),
                      Text('2019-09-09'),
                      SizedBox(height: 10.0),
                      Text('${widget.albumDoc.data['medias'].length} songs'),
                      RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Download Album'),
                        onPressed: () async {
                          // pay
                          PaymentMethod paymentMethod =
                              await StripePayment.paymentRequestWithCardForm(
                                  null);
                          
                          Token token = await StripePayment.createTokenWithCard(paymentMethod.card);

                          PaymentService.addCard(token);
                          print(paymentMethod.toJson());
                          //
                          print(widget.albumDoc.data);
                          // update user in firestore
                          var album = Album.fromMap(
                              widget.albumDoc.data, widget.albumDoc.documentID);
                          album.firestoreId = widget.albumDoc.documentID;

                          print(album.toMap());

                          var mediaList = album.medias;
                          if (widget.loggedInUser == null) {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }
                          updateUserInFirestore(
                              widget.loggedInUser.uid, album, mediaList);

                          // downloadAlbum
                          downloadAlbum(album, widget.albumDoc.documentID);
                        },
                        color: Color(0xff5468FF),
                        textColor: Colors.white,
                      ),
                      RaisedButton.icon(
                        // padding: EdgeInsets.all(8.0),
                        label: Text('Gift'),
                        icon: Icon(Icons.card_giftcard),
                        textColor: Colors.white,
                        color: Color(0xff5468FF),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GiftPage(
                                        sender: widget.loggedInUser,
                                        albumDoc: widget.albumDoc,
                                        isAlbum: true,
                                      )));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: _songList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _songList() {
    // final List<String> entries = <String>['A', 'B', 'C', 'D', 'B', 'C', 'D'];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.albumDoc.data['medias'].length,
      itemBuilder: (BuildContext context, int index) {
        var album =
            Album.fromMap(widget.albumDoc.data, widget.albumDoc.documentID);

        var mediaList = [album.medias[index]];

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Color(0x555468FF),
            child: Icon(
              Icons.music_note,
              color: Colors.white,
            ),
          ),
          title: Text(widget.albumDoc.data['medias'][index]['name'].toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Color(0xff5468FF),
                ),
                onPressed: () async {
                  // showProgress();

                  // update user in firestore
                  // var album = Album.fromMap(
                  //     widget.albumDoc.data, widget.albumDoc.documentID);
                  // var mediaList = [album.medias[index]];
                  updateUserInFirestore(
                      widget.loggedInUser.uid, album, mediaList);

                  downloadSingle(
                      album, album.medias[index], widget.albumDoc.documentID);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.card_giftcard,
                  color: Color(0xff5468FF),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GiftPage(
                                sender: widget.loggedInUser,
                                albumDoc: widget.albumDoc,
                                media: album.medias[index],
                                isAlbum: false,
                              )));
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
          // height: 5.0,
          ),
    );
  }

  Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();

    final directory = await getExternalStorageDirectory();

    return directory.path;
  }

  Future<String> downloadFiles(String url, File_Type type) async {
    var path = await _localPath;
    var audioPath = Util.urlToPath(url);
    var fileName = audioPath.substring(audioPath.lastIndexOf('/') + 1);
    print(fileName);

    var filePath;
    if (type == File_Type.image) {
      filePath = '$path/image/$fileName';
    } else if (type == File_Type.audio) {
      filePath = '$path/audio/$fileName';
    } else if (type == File_Type.video) {
      filePath = '$path/video/$fileName';
    }

    File(filePath);
    print(filePath);

    await dio.download(url, filePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      }
    });

    return filePath;
  }

  // void showProgress() {
  //   _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
  //     return Material(
  //       elevation: 4.0,
  //       child: new Container(
  //           child: new Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Padding(
  //             padding: EdgeInsets.all(16.0),
  //             child: Text('Downloading...'),
  //           ),
  //           LinearProgressIndicator(),
  //         ],
  //       )),
  //     );
  //   });
  // }

  Future<int> storeToDb(Album album) async {
    int id = await AlbumDao.insert(album);
    print('Added Successfully');

    return id;
  }

  createDirectories() async {
    var path = await _localPath;

    bool imageDir = await Directory('$path/image').exists();
    bool audioDir = await Directory('$path/audio').exists();
    bool videoDir = await Directory('$path/video').exists();

    if (!imageDir) {
      await Directory('$path/image').create();
    }

    if (!audioDir) {
      await Directory('$path/audio').create();
    }

    if (!videoDir) {
      await Directory('$path/video').create();
    }
  }

  downloadAlbum(Album album, String firestoreId) async {
    await createDirectories();

    // Album album = Album.fromMap(Album.mapToList(firestoreAlbum));

    // album.firestoreId = firestoreId;
    album.id = await storeToDb(album);

    print('album id: ${album.id}');

    String imagePath = await downloadFiles(album.image, File_Type.image);

    print('imagePath: $imagePath');

    // update image in db
    album.image = imagePath;
    await AlbumDao.update(album);

    File_Type type = album.type == 'audio' ? File_Type.audio : File_Type.video;

    album.medias.forEach((media) async {
      String dataPath = await downloadFiles(media.data, type);

      // update data of media in db
      media.data = dataPath;
      await AlbumDao.update(album);
      print(album.toMap());
    });

    // print(album.toMap());

    print('Download successful!!');
  }

  downloadSingle(Album album, Media media, String firestoreId) async {
    await createDirectories();

    // Album album = Album.fromMap(Album.mapToList(firestoreAlbum));
    // Media media = Media.fromMap(firestoreMedia);

    Album oldAlbum = await AlbumDao.getAlbumByFirestoreId(firestoreId);

    if (oldAlbum != null) {
      // there was already a song downloaded of this album
      oldAlbum.medias.add(media);
      await AlbumDao.update(oldAlbum);

      File_Type type =
          oldAlbum.type == 'audio' ? File_Type.audio : File_Type.video;

      String dataPath = await downloadFiles(media.data, type);

      // update data of media in db
      oldAlbum.medias.firstWhere((m) {
        return identical(m, media);
      }).data = dataPath;

      await AlbumDao.update(oldAlbum);
    } else {
      // the album is new
      album.medias = [media];
      album.firestoreId = firestoreId;
      album.id = await storeToDb(album);

      // download image
      String imagePath = await downloadFiles(album.image, File_Type.image);

      // update image in db
      album.image = imagePath;
      await AlbumDao.update(album);

      // download audio
      File_Type type =
          album.type == 'audio' ? File_Type.audio : File_Type.video;

      String dataPath = await downloadFiles(media.data, type);

      // update data of media in db
      album.medias.firstWhere((m) {
        return identical(m, media);
      }).data = dataPath;
      await AlbumDao.update(album);
    }

    print('Single downloaded successfully');
  }

  updateUserInFirestore(String uid, Album album, List<Media> mediaList) async {
    // we need the album for albumId, artist and category
    // the user might not be buying the whole song, so for others we use the mediaList

    QuerySnapshot userSnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .getDocuments();

    print(userSnapshot.documents[0].data);

    User user = User.fromMap(userSnapshot.documents[0].data);

    print(user);

    String albumId = album.firestoreId;

    List<String> mediaIdList = mediaList.map((media) => media.id).toList();
    List<String> mediaLangList =
        mediaList.map((media) => media.language).toList();
    List<String> mediaGenreList =
        mediaList.map((media) => media.genre).toList();

    //boughtSongs
    if (user.boughtSongs.containsKey(albumId)) {
      user.boughtSongs[albumId].addAll(mediaIdList);
      user.boughtSongs[albumId] = user.boughtSongs[albumId].toSet().toList();
    } else {
      user.boughtSongs.addAll({albumId: mediaIdList});
    }

    // language
    mediaLangList.forEach((language) {
      if (user.language.containsKey(language)) {
        // language already exists
        user.language[language] = user.language[language] + 1;
      } else {
        // first time listening to this language
        user.language[language] = 1;
      }
    });

    // genre
    mediaGenreList.forEach((genre) {
      if (user.genre.containsKey(genre)) {
        // genre already exists
        user.genre[genre] = user.genre[genre] + 1;
      } else {
        // first time listening to this genre
        user.genre[genre] = 1;
      }
    });

    //artist
    if (user.artist.containsKey(album.artist)) {
      // the user listened mediaList.length songs of the artist
      user.artist[album.artist] = user.artist[album.artist] + mediaList.length;
    } else {
      user.artist[album.artist] = mediaList.length;
    }

    // category
    if (user.category.containsKey(album.category)) {
      user.category[album.category] =
          user.category[album.category] + mediaList.length;
    } else {
      user.category[album.category] = mediaList.length;
    }

    // await _firestore
    //     .collection('users')
    //     .document(userSnapshot.documents[0].documentID)
    //     .updateData(User(
    //       uid: user.uid,
    //       boughtSongs: user.boughtSongs,
    //       language: user.language,
    //       genre: user.genre,
    //       artist: user.artist,
    //       category: user.category,
    //     ).toMap());

    // album.medias.forEach((media) {
    //   if (mediaIdList.contains(media.id)) {
    //     media.numOfDownloads++;
    //   }
    // });

    // var updatedAlbum = Album(
    //         albumName: album.albumName,
    //         artist: album.artist,
    //         artistName: album.artistName,
    //         category: album.category,
    //         description: album.description,
    //         image: album.image,
    //         type: album.type,
    //         medias: album.medias)
    //     .toMap();

    // updatedAlbum.remove('id');
    // updatedAlbum.remove('firestoreId');

    // await _firestore
    //     .collection('albums')
    //     .document(album.firestoreId)
    //     .updateData(updatedAlbum);

    await _firestore.runTransaction((Transaction tx) async {
      await tx.update(
          _firestore
              .collection('users')
              .document(userSnapshot.documents[0].documentID),
          User(
            uid: user.uid,
            boughtSongs: user.boughtSongs,
            language: user.language,
            genre: user.genre,
            artist: user.artist,
            category: user.category,
          ).toMap());

      // update number of downloads
      // or add an entry to the sold collection

      // album.medias.forEach((media) {
      //   if (mediaIdList.contains(media.id)) {
      //     media.numOfDownloads = media.numOfDownloads + 1;
      //     print(media.numOfDownloads);
      //   }
      // });

      // var updatedAlbum = Album(
      //         albumName: album.albumName,
      //         artist: album.artist,
      //         artistName: album.artistName,
      //         category: album.category,
      //         description: album.description,
      //         image: album.image,
      //         type: album.type,
      //         medias: album.medias)
      //     .toMap();

      // updatedAlbum.remove('id');
      // updatedAlbum.remove('firestoreId');

      // print(album.firestoreId);
      // await tx.update(
      //     _firestore.collection('albums').document(album.firestoreId),
      //     updatedAlbum);
    });
  }
}

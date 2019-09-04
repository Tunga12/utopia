// import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:utopia/models/media.dart';

class Album {
  int id;
  String firestoreId;
  String albumName;
  String artist;
  String artistName;
  String category;
  String description;
  String image;
  String type;

  List<Media> medias = [];
  // Map<String, Media> medias;

  Album({@required this.albumName, @required this.artist, @required this.artistName, 
  @required this.category, @required this.description, @required this.image, @required this.type,
  @required this.medias });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firestoreId': firestoreId,
      'albumName': albumName,
      'artist': artist,
      'artistName': artistName,
      'category': category,
      'description': description,
      'image': image,
      'type': type,
      'medias': medias.map((media) => media.toMap()).toList(),
    };
  }

  Album.fromMap(Map<dynamic, dynamic> map, [String docId]) {
    // map = mapToList(map);

    var newMap = Map<String, dynamic>.from(map);

    firestoreId = docId == null ? newMap['firestoreId'] : docId;
    albumName = newMap['albumName'];
    artist = newMap['artist'];
    artistName = newMap['artistName'];
    category = newMap['category'];
    description = newMap['description'];
    image = newMap['image'];
    type = newMap['type'];
    medias = newMap['medias']
        .map((mapping) => Media.fromMap(Map<String, dynamic>.from(mapping)))
        .toList()
        .cast<Media>();
  }

  static mapToList(Map<String, dynamic> map) {
    var newMap = Map<String, dynamic>.from(map);

    print(newMap['medias'].runtimeType);
    // Map<String, Map<String, String>> medias = Map.from(map['medias']).cast<String, Map<String, String>>();

    Map medias = newMap['medias'];

    List<Map<String, String>> mediaList = [];
    medias.forEach((key, mediaMap) {
      // mediaList.add(mediaMap);
      mediaList.add(Map.castFrom<dynamic, dynamic, String, String>(mediaMap));
    });

    newMap['medias'] = mediaList;

    return newMap;
  }
}

Map<String, dynamic> firebaseAlbum = {
  'category': 'secular',
  'albumName': 'ALFGFGFH',
  'description': 'WOWWW',
  'medias': {
    '1': {
      'length': '12:56',
      'genre': 'genre 1',
      'data':
          'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/album%2FDani%2FALFGFGFH%2FG%23.mp3?alt=media&token=47eef9e8-c236-49a2-a505-df082dac4364',
      'language': 'language 1',
      'name': 'H'
    },
    '0': {
      'length': '15:15',
      'genre': 'genre 1',
      'data':
          'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/album%2FDani%2FALFGFGFH%2FG.mp3?alt=media&token=d53ccdfd-674f-4a3c-85d6-34f6648dd9c2',
      'language': 'language 1',
      'name': 'g'
    }
  },
  'image':
      'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/cover%2Fmeee.jpg?alt=media&token=e3a13000-4249-45ca-b2d8-7c4273d39f04',
  'artist': 'IlumLDttnjKbr0lD9E91',
  'type': 'audio',
  'artistName': 'Dani'
};

Map<String, dynamic> newFirebaseAlbum = {
  'category': 'secular',
  'albumName': 'ALFGFGFH',
  'description': 'WOWWW',
  'medias': [
    {
      'id': 1,
      'length': '12:56',
      'genre': 'genre 1',
      'data':
          'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/album%2FDani%2FALFGFGFH%2FG%23.mp3?alt=media&token=47eef9e8-c236-49a2-a505-df082dac4364',
      'language': 'language 1',
      'name': 'H'
    },
    {
      'id': 2,
      'length': '15:15',
      'genre': 'genre 1',
      'data':
          'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/album%2FDani%2FALFGFGFH%2FG.mp3?alt=media&token=d53ccdfd-674f-4a3c-85d6-34f6648dd9c2',
      'language': 'language 1',
      'name': 'g'
    }
  ],
  'image':
      'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/cover%2Fmeee.jpg?alt=media&token=e3a13000-4249-45ca-b2d8-7c4273d39f04',
  'artist': 'IlumLDttnjKbr0lD9E91',
  'type': 'audio',
  'artistName': 'Dani'
};

// Map<String, Map<String, String>> media =  {
//     '1': {
//       'length': '12:56',
//       'genre': 'genre 1',
//       'data':
//           'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/album%2FDani%2FALFGFGFH%2FG%23.mp3?alt=media&token=47eef9e8-c236-49a2-a505-df082dac4364',
//       'language': 'language 1',
//       'name': 'H'
//     },
//     '0': {
//       'length': '15:15',
//       'genre': 'genre 1',
//       'data':
//           'https://firebasestorage.googleapis.com/v0/b/utopia-3e894.appspot.com/o/album%2FDani%2FALFGFGFH%2FG.mp3?alt=media&token=d53ccdfd-674f-4a3c-85d6-34f6648dd9c2',
//       'language': 'language 1',
//       'name': 'g'
//     }
//   };

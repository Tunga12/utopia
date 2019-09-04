
import 'package:flutter/foundation.dart';
import 'package:utopia/models/album.dart';

class Playlist{

  int id;
  String name;
  List<Album> albums;

  Playlist({@required this.name, @required this.albums});
  

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'albums': albums.map((album) => album.toMap()).toList(),
    };
  }


  Playlist.fromMap(Map<String, dynamic> map) {

    id = map['id'];
    name = map['name'];
    albums = map['albums'].map((mapping) => Album.fromMap(mapping)).toList().cast<Album>();

  }

}
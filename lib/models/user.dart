class User {
  String uid;
  Map<String, List<String>> boughtSongs;
  Map<String, int> language;
  Map<String, int> genre;
  Map<String, int> artist;
  Map<String, int> category;

  User({this.uid, this.boughtSongs, this.language, this.genre, this.artist, this.category});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'boughtSongs': boughtSongs,
      'language': language,
      'genre': genre,
      'artist': artist,
      'category': category,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    boughtSongs = Map<String, List<dynamic>>.from(map['boughtSongs']).map((albumId, listOfMedias){
      var list = List<String>.from(listOfMedias);
      return MapEntry(albumId, list);
    });
    language = Map<String, int>.from(map['language']);
    genre =  Map<String, int>.from(map['genre']);
    artist = Map<String, int>.from(map['artist']);
    category = Map<String, int>.from(map['category']);
  }

  

  _mapToList(Map<String, dynamic> boughtSongs) {
    boughtSongs = Map.castFrom<String, dynamic, String, Map<String, dynamic>>(
        boughtSongs);

    boughtSongs.map((albumId, mediaMap) {
      List mediaIndexList = [];
      mediaMap.forEach((index, mediaIndex) {
        mediaIndexList.add(mediaIndex);
      });

      return MapEntry(albumId, mediaIndexList);
    });

    print(boughtSongs);
  }


  _listToMap(Map<String, List<String>> boughtSongs){

    boughtSongs.map((albumId, mediaIndexList){

      Map<String, String> newMap = mediaIndexList.asMap().map((key, value){
        return MapEntry(key.toString(), value);
      });
      return MapEntry(albumId, newMap);
    });
  }
}

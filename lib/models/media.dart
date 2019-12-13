
class Media{

  String id;
  String name;
  String data;
  String genre;
  String language;
  String length;
  bool heart;
  List<int> playlists = [];
  num numOfDownloads;
 

  Media.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        genre = json['genre'],
        data = json['data'],
        length = json['length'],
        language = json['language'],
        // i have to handle the following values: null, true, false. null because this property does not exist in firestore
        heart = (json['heart'] != true) ? false : true,
        playlists = json['playlists'] == null ? [] : List<int>.from(json['playlists']),
        numOfDownloads = json['numOfDownloads'];


  Map<String, dynamic> toMap() =>
    {
      'id': id,
      'name': name,
      'data': data,
      'genre': genre,
      'language': language,
      'length': length,
      'heart': heart,
      'playlists': playlists,
      'numOfDownloads': numOfDownloads,
    };

}
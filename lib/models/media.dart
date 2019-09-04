
class Media{

  String id;
  String name;
  String data;
  String genre;
  String language;
  String length;
  num numOfDownloads;
 

  Media.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        genre = json['genre'],
        data = json['data'],
        length = json['length'],
        language = json['language'],
        numOfDownloads = json['numOfDownloads'];


  Map<String, dynamic> toMap() =>
    {
      'id': id,
      'name': name,
      'data': data,
      'genre': genre,
      'language': language,
      'length': length,
      'numOfDownloads': numOfDownloads,
    };

}
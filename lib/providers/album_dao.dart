import 'package:dio/dio.dart';
import 'package:sembast/sembast.dart';
import 'package:utopia/models/album.dart';
import 'package:utopia/providers/app.database.dart';

class AlbumDao {
  static const String ALBUM_STORE_NAME = 'albums';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  static final _albumStore = intMapStoreFactory.store(ALBUM_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await AppDatabase.instance.database;

  static Future<int> insert(Album album) async {
    var id = await _albumStore.add(await _db, album.toMap());
    return id;
  }

  static Future update(Album album) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(album.id));
    await _albumStore.update(
      await _db,
      album.toMap(),
      finder: finder,
    );
  }

  static Future delete(Album album) async {
    final finder = Finder(filter: Filter.byKey(album.id));
    await _albumStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<Album>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _albumStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Album> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final album = Album.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      album.id = snapshot.key;
      return album;
    }).toList();
  }

  static Future<Album> getAlbumByFirestoreId(String firestoreId) async {
    // Finder object can also sort data.
    final finder = Finder(filter: Filter.equals('firestoreId', firestoreId));

    final recordSnapshot = await _albumStore.findFirst(
      await _db,
      finder: finder,
    );

    // no album with this firestoreId is found
    if(recordSnapshot == null){
      return null;
    }

    final album = Album.fromMap(recordSnapshot.value);
    // An ID is a key of a record from the database.
    album.id = recordSnapshot.key;
    return album;
  }
}

Dio dio = new Dio();

enum File_Type { image, audio, video }

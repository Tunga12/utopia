import 'package:sembast/sembast.dart';
// import 'package:utopia/models/album.dart';
import 'package:utopia/models/playlist.dart';
import 'package:utopia/providers/app.database.dart';

class PlaylistDao {
  static const String PLAYLIST_STORE_NAME = 'playlists';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _playlistStore = intMapStoreFactory.store(PLAYLIST_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  PlaylistDao();

  Future<int> insert(Playlist playlist) async {
    var id = await _playlistStore.add(await _db, playlist.toMap());
    return id;
  }

  Future update(Playlist playlist) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(playlist.id));
    await _playlistStore.update(
      await _db,
      playlist.toMap(),
      finder: finder,
    );
  }

  Future delete(Playlist playlist) async {
    final finder = Finder(filter: Filter.byKey(playlist.id));
    await _playlistStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Playlist>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _playlistStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<playlist> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final playlist = Playlist.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      playlist.id = snapshot.key;
      return playlist;
    }).toList();
  }
}

PlaylistDao playlistDao = PlaylistDao();

import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:utopia/models/album.dart';
import 'package:utopia/models/media.dart';
// import 'package:utopia/components/custom_grid.dart';
import 'package:utopia/models/playlist.dart';
import 'package:utopia/providers/album_dao.dart';
import 'package:utopia/providers/playlist_dao.dart';

import 'now-playing.dart';

class LibraryPlaylistPage extends StatefulWidget {
  @override
  _LibraryPlaylistPageState createState() => _LibraryPlaylistPageState();
}

class _LibraryPlaylistPageState extends State<LibraryPlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GridView.count(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoriteView()));
              },
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: RandomColor().randomColor(
                              colorSaturation: ColorSaturation.lowSaturation,
                              colorBrightness: ColorBrightness.light,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(
                            'assets/playlist4.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        // 'Playlist ${index + 1}',
                        'Favorites',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: playlistDao.getAllSortedByName(),
          builder: (context, AsyncSnapshot<List<Playlist>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.data.length == 0) {
              // return Center(
              //   child: Text('The are no playlist'),
              // );
              return Container();
            }
            return GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(snapshot.data.length, (index) {
                return GestureDetector(
                  onTap: () {
                    // for (var album in snapshot.data[index].albums) {
                    //   print(album.toMap());
                    // }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaylistView(
                                  playlist: snapshot.data[index],
                                )));
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              decoration: BoxDecoration(
                                color: RandomColor().randomColor(
                                  colorSaturation:
                                      ColorSaturation.lowSaturation,
                                  colorBrightness: ColorBrightness.light,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                'assets/playlist4.png',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            // 'Playlist ${index + 1}',
                            '${snapshot.data[index].name}',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class PlaylistView extends StatelessWidget {
  final Playlist playlist;
  PlaylistView({@required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(playlist.name),
        ),
        body: FutureBuilder(
          future: AlbumDao.getAlbumsOfPlaylist(playlist.id),
          builder: (context, AsyncSnapshot<List<Album>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                List<ListTile> list = [];
                print(snapshot.data.first.toMap());
                for (Media media in snapshot.data[index].medias) {
                  list.add(ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(media.name),
                    subtitle: Text(snapshot.data[index].artistName),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NowPlayingPage(
                                    albums: snapshot.data,
                                    media: media,
                                  )));
                    },
                  ));
                }

                return Column(
                  children: list,
                );
              },
            );
          },
        ));
  }
}

class FavoriteView extends StatelessWidget {
  FavoriteView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: FutureBuilder(
          future: AlbumDao.getFavorites(),
          builder: (context, AsyncSnapshot<List<Album>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            // if (snapshot.data.isEmpty) {
            //   return Center(
            //     child: Text('There are no songs in Favorites.'),
            //   );
            // }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                List<ListTile> list = [];
                print(snapshot.data.first.toMap());
                for (Media media in snapshot.data[index].medias) {
                  list.add(ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(media.name),
                    subtitle: Text(snapshot.data[index].artistName),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NowPlayingPage(
                                    albums: snapshot.data,
                                    media: media,
                                  )));
                    },
                  ));
                }

                return Column(
                  children: list,
                );
              },
            );
          },
        ));
  }
}

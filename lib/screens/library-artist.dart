import 'package:flutter/material.dart';
// import 'package:utopia/components/custom-list.dart';
import 'package:utopia/models/album.dart';
import 'package:utopia/providers/album_dao.dart';

import 'now-playing.dart';

class LibraryArtistPage extends StatefulWidget {
  @override
  _LibraryArtistPageState createState() => _LibraryArtistPageState();
}

class _LibraryArtistPageState extends State<LibraryArtistPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AlbumDao.getAllSortedByName(),
      builder: (context, AsyncSnapshot<List<Album>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.data.length == 0) {
          return Center(
            child: Text('The are no artists'),
          );
        }
        
        var artistIds = [];
        for (var album in snapshot.data) {
          artistIds.add(album.artist);
        }
        // to get only unique ids
        artistIds = artistIds.toSet().toList();


        return ListView.builder(
          shrinkWrap: true,
          itemCount: artistIds.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              leading: CircleAvatar(
                backgroundColor: Color(0x555468FF),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(snapshot.data.firstWhere((album) {
                return artistIds[index] == album.artist;
              }).artistName),
              subtitle: Text('${getAllSongsByArtist(artistIds[index], snapshot.data)} songs'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ArtistView(
                    albums: getAllAlbumsByArtist(artistIds[index], snapshot.data),
                  )
                ));
              },
            );
          },
        );
      },
    );
  }

  int getAllSongsByArtist(String artistId, List<Album> albums){
    
    // List<Album> albumsOfTheArtist = albums.where((album){
    //   return album.artist == artistId;
    // }).toList();

    List<Album> albumsOfTheArtist = getAllAlbumsByArtist(artistId, albums);

    int numOfSongs = 0;
    albumsOfTheArtist.forEach((album){
      numOfSongs += album.medias.length;
    });

    return numOfSongs;
  }

  List<Album> getAllAlbumsByArtist(String artistId, List<Album> albums){

    List<Album> albumsOfTheArtist = albums.where((album){
      return album.artist == artistId;
    }).toList();

    return albumsOfTheArtist;
  }
}


class ArtistView extends StatelessWidget {
  final List<Album> albums;
  ArtistView({@required this.albums});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albums[0].artistName),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: albums.length,
        itemBuilder: (BuildContext context, int index) {
          List<ListTile> list = [];
          for (var media in albums[index].medias) {
            list.add(ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              leading: CircleAvatar(
                child: Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
              ),
              title: Text(media.name),
              subtitle: Text(albums[index].artistName),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NowPlayingPage(
                              albums: albums,
                              media: media,
                            )));
              },
            ));
          }

          return Column(
            children: list,
          );
        }
      ),
    );
  }
}

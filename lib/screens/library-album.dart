import 'package:flutter/material.dart';
// import 'package:utopia/components/custom_grid.dart';
import 'package:utopia/models/album.dart';
import 'package:utopia/providers/album_dao.dart';
// import 'package:utopia/screens/library-playlist.dart';

import 'now-playing.dart';

class LibraryAlbumPage extends StatefulWidget {
  @override
  _LibraryAlbumPageState createState() => _LibraryAlbumPageState();
}

class _LibraryAlbumPageState extends State<LibraryAlbumPage> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: CustomGrid(
    //     imagePath: 'assets/album.png',
    //     title: 'Album',
    //     subtitle: 'Artist - 10 songs',
    //   ),
    // );

    return FutureBuilder(
      future: AlbumDao.getAllSortedByName(),
      builder: (context, AsyncSnapshot<List<Album>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.data.length == 0) {
          return Center(
            child: Text('The are no playlist'),
          );
        }
        
        return GridView.count(
          crossAxisCount: 2,
          children: List.generate(snapshot.data.length, (index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AlbumView(
                    album: snapshot.data[index],
                  )
                ));
              },
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: const Color(0x11000000),
                          child: Image.asset(
                            'assets/album.png',
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        snapshot.data[index].albumName,
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text(
                        '${snapshot.data[index].artistName} - ${snapshot.data[index].medias.length}',
                        style: TextStyle(color: Colors.black26),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}


class AlbumView extends StatelessWidget {
  final Album album;
  AlbumView({@required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.albumName),
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: album.medias.length,
        itemBuilder: (BuildContext context, int index) {
         return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              leading: CircleAvatar(
                child: Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
              ),
              title: Text(album.medias[index].name),
              subtitle: Text(album.artistName),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NowPlayingPage(
                              albums: [album],
                              media: album.medias[index],
                            )));
              },
            );
          
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
            // height: 5.0,
            ),
      ),
    );
  }
}

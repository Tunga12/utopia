import 'package:flutter/material.dart';
import 'package:utopia/models/album.dart';
import 'package:utopia/providers/album_dao.dart';
import 'package:utopia/screens/now-playing.dart';

class LibrarySongPage extends StatefulWidget {
  @override
  _LibrarySongPageState createState() => _LibrarySongPageState();
}

class _LibrarySongPageState extends State<LibrarySongPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: AlbumDao.getAllSortedByName(),
        builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data != null ? snapshot.data.length : 0,
            itemBuilder: (BuildContext context, int index) {
              List<ListTile> list = [];
              for (var media in snapshot.data[index].medias) {
                list.add(ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  leading: CircleAvatar(
                    backgroundColor: Color(0x555468FF),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(media.name),
                  subtitle: Text(snapshot.data[index].artistName),
                  onTap: () {
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => NowPlayingPage(
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
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
                    // height: 5.0,
                    ),
          );
        },
      ),
    );
  }

  
}


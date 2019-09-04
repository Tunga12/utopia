import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:utopia/models/album.dart';
import 'package:utopia/models/media.dart';
import 'package:utopia/models/playlist.dart';
import 'package:utopia/providers/playlist_dao.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

Key scaffoldKey = Key('now_playing_scaffold');

class NowPlayingPage extends StatefulWidget {
  final List<Album> albums;

  final mediaController = StreamController<Media>();

  NowPlayingPage({@required this.albums, @required media}) {
    mediaController.add(media);
  }

  @override
  _NowPlayingPageState createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  _NowPlayingPageState() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => duration = d);
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: ${p.inMilliseconds}');
      setState(() => position = p);
    });

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      setState(() => playerState = s);

      // must automatically go to the next song and play it
      if (s == AudioPlayerState.COMPLETED) {
        // widget.mediaController.add(getNextMedia());
        position = Duration(milliseconds: 0);
      }
    });

    // audioPlayer.onPlayerCompletion.listen((event) {
    //   setState(() {
    //     position = duration;
    //     sleep(Duration(milliseconds: 500));
    //     position = Duration(milliseconds: 0);
    //   });
    // });
  }

  final AudioPlayer audioPlayer = new AudioPlayer();

  bool imageView = true;

  Duration duration = Duration(milliseconds: 0);
  Duration position = Duration(milliseconds: 0);
  AudioPlayerState playerState;
  bool repeat = false;
  bool shuffle = false;
  bool favorite = false;

  List<Album> list;

  @override
  void initState() {
    super.initState();
    chooseList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Media>(
        stream: widget.mediaController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(snapshot.data.name),
                  subtitle: Text(widget.albums.firstWhere((album) {
                    return album.medias.contains(snapshot.data);
                  }).artistName),
                ),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.queue_music),
                    onPressed: () {
                      setState(() {
                        imageView = !imageView;
                      });
                    },
                  ),
                  PopupMenuButton<WhyFarther>(
                    onSelected: (WhyFarther result) async {
                      await _addToPlaylist(snapshot.data);
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<WhyFarther>>[
                      const PopupMenuItem<WhyFarther>(
                        value: WhyFarther.harder,
                        child: Text('Add To Playlist'),
                      )
                    ],
                  )
                ],
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: imageView
                        ? Image.file(
                            File(widget.albums.firstWhere((album) {
                              return album.medias.contains(snapshot.data);
                            }).image),
                            fit: BoxFit.fitHeight,
                          )
                        : _songList(),
                  ),
                  Material(
                    elevation: 16.0,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: shuffle
                                  ? Icon(
                                      Icons.shuffle,
                                      color: Colors.blueAccent,
                                    )
                                  : Icon(
                                      Icons.shuffle,
                                    ),
                              onPressed: () {
                                setState(() {
                                  shuffle = !shuffle;
                                  chooseList();
                                });
                              },
                            ),
                            IconButton(
                              icon: favorite
                                  ? Icon(Icons.star, color: Colors.yellow[800])
                                  : Icon(Icons.star_border),
                              onPressed: () async {
                                setState(() {
                                  favorite = !favorite;
                                });

                                if (favorite) {
                                  await storeToFavoritePlaylist(snapshot.data);
                                  List<Playlist> playlists =
                                      await playlistDao.getAllSortedByName();

                                  playlists.forEach((playlist) {
                                    print(playlist.toMap());
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: repeat
                                  ? Icon(
                                      Icons.repeat,
                                      color: Colors.blueAccent,
                                    )
                                  : Icon(
                                      Icons.repeat,
                                    ),
                              onPressed: () async {
                                setState(() {
                                  repeat = !repeat;
                                });
                                if (repeat) {
                                  await audioPlayer
                                      .setReleaseMode(ReleaseMode.LOOP);
                                } else {
                                  await audioPlayer
                                      .setReleaseMode(ReleaseMode.RELEASE);
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: <Widget>[
                              Slider(
                                value: calculateProgress(),
                                onChanged: (newValue) {
                                  // position = newValue;
                                },
                              ),
                              // LinearProgressIndicator(
                              //   value: calculateProgress(),
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(position.toString().substring(
                                      0, position.toString().length - 7)),
                                  Text(duration.toString().substring(
                                      0, duration.toString().length - 7)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              iconSize: 50.0,
                              icon: Icon(Icons.skip_previous),
                              onPressed: () {
                                widget.mediaController
                                    .add(getPreviousMedia(snapshot.data));
                                position = Duration(milliseconds: 0);
                              },
                            ),
                            IconButton(
                              iconSize: 75.0,
                              icon: playerState == AudioPlayerState.PLAYING
                                  ? Icon(Icons.pause_circle_filled)
                                  : Icon(Icons.play_circle_filled),
                              onPressed: () {
                                if (playerState == AudioPlayerState.PLAYING) {
                                  audioPlayer.pause();
                                } else if (playerState ==
                                    AudioPlayerState.PAUSED) {
                                  audioPlayer.resume();
                                } else {
                                  audioPlayer.play(snapshot.data.data,
                                      isLocal: true);
                                }
                              },
                            ),
                            IconButton(
                              iconSize: 50.0,
                              icon: Icon(Icons.skip_next),
                              onPressed: () {
                                var newMedia = getNextMedia(snapshot.data);
                                // print(newMedia.toMap());
                                widget.mediaController.add(newMedia);
                                position = Duration(milliseconds: 0);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  Widget _songList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.albums.length,
      itemBuilder: (BuildContext context, int index) {
        List<ListTile> list = [];
        for (var media in widget.albums[index].medias) {
          list.add(ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            leading: CircleAvatar(
              child: Icon(
                Icons.music_note,
                color: Colors.white,
              ),
            ),
            title: Text(media.name),
            subtitle: Text(widget.albums[index].artistName),
            onTap: () {
              // change the color of the text and play the audio
              audioPlayer.stop();
              audioPlayer.play(media.data, isLocal: true);
            },
          ));
        }

        return Column(
          children: list,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
          // height: 5.0,
          ),
    );
  }

  Future<void> _addToPlaylist(Media currentMedia) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Add to playlist'),
            children: <Widget>[
              _listOfPlaylist(currentMedia),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      _newPlaylist();
                    },
                    child: const Text('NEW PLAYLIST'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> _newPlaylist() async {
    final playlistNameController = TextEditingController();

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('New playlist'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(hintText: 'Name'),
                  controller: playlistNameController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Playlist newPlaylist = Playlist(
                        name: playlistNameController.text,
                        albums: <Album>[],
                      );
                      await playlistDao.insert(newPlaylist);
                      Navigator.pop(context);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Playlist created!'),
                      ));
                    },
                    child: const Text('CREATE PLAYLIST'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  double calculateProgress() {
    var played =
        position.inMilliseconds.toDouble() / duration.inMilliseconds.toDouble();

    played = double.parse(played.toStringAsFixed(2));
    print('calculating... $played');
    if (played.isInfinite) {
      return 1;
    }

    if (played.isNaN) {
      return 0.000001;
    }

    if (played > 0.90) {
      return 1;
    }

    return played;
  }

  void chooseList() {
    if (shuffle) {
      list = shuffleList();
    } else {
      list = widget.albums;
    }

    // list.forEach((album) {
    //   print(album.toMap());
    // });

    // return list;
  }

  Media getNextMedia(currentMedia) {
    var albums = list;

    Album currentAlbum = albums.firstWhere((album) {
      return album.medias.contains(currentMedia);
    });

    var indexOfCurrentMedia = currentAlbum.medias.indexOf(currentMedia);

    if (indexOfCurrentMedia == currentAlbum.medias.length - 1) {
      /* the current media is the last media from this album
                     so go to the next album
                  */
      var indexOfNextAlbum = albums.indexOf(currentAlbum) + 1;

      /* if the current album is the last album, 
                    go to the first album 
                  */
      if (indexOfNextAlbum > albums.length - 1) {
        return albums.first.medias.first;
      }
      Album nextAlbum = albums[indexOfNextAlbum];

      return nextAlbum.medias.first;
    } else {
      return currentAlbum.medias[indexOfCurrentMedia + 1];
    }
  }

  Media getPreviousMedia(currentMedia) {
    var albums = list;

    Album currentAlbum = albums.firstWhere((album) {
      return album.medias.contains(currentMedia);
    });

    var indexOfCurrentMedia = currentAlbum.medias.indexOf(currentMedia);

    // if the current media is the first one in the current album
    if (indexOfCurrentMedia == 0) {
      // go to previous album, last media
      var indexOfPreviousAlbum = albums.indexOf(currentAlbum) - 1;

      if (indexOfPreviousAlbum == -1) {
        return albums.last.medias.last;
      }
      return albums[indexOfPreviousAlbum].medias.last;
    }

    return currentAlbum.medias[indexOfCurrentMedia - 1];
  }

  List<Album> shuffleList() {
    List<Album> shuffledAlbums = widget.albums;
    shuffledAlbums.forEach((album) {
      album.medias.shuffle();
    });

    shuffledAlbums.shuffle();

    return shuffledAlbums;
  }

  Future storeToFavoritePlaylist(Media currentMedia) async {
    Playlist favoritePlaylist;

    List<Playlist> playlists = await playlistDao.getAllSortedByName();

    favoritePlaylist = playlists.firstWhere((playlist) {
      return playlist.name == 'Favorites';
    }, orElse: () {
      return null;
    });

    if (favoritePlaylist == null) {
      var playlist = Playlist(
        name: 'Favorites',
        albums: <Album>[],
      );
      await playlistDao.insert(playlist);
      return;
    }

    Album currentAlbum = list.firstWhere((album) {
      return album.medias.contains(currentMedia);
    });

    Album oldAlbum = favoritePlaylist.albums.firstWhere((album) {
      return album.id == currentAlbum.id;
    }, orElse: () {
      return null;
    });
    if (oldAlbum == null) {
      // there is no song corresponding to that album
      currentAlbum.medias = [currentMedia];
      favoritePlaylist.albums.add(currentAlbum);
    } else {
      // that album exists with previously favorite songs so add the new song
      oldAlbum.medias.add(currentMedia);
      favoritePlaylist.albums.forEach((album) {
        if (album.id == oldAlbum.id) {
          album = oldAlbum;
        }
      });
    }
    await playlistDao.update(favoritePlaylist);
  }

  void deleteFromFavoritePlaylist() {}

  Widget _listOfPlaylist(Media currentMedia) {
    return FutureBuilder(
      future: playlistDao.getAllSortedByName(),
      builder: (context, AsyncSnapshot<List<Playlist>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
          case ConnectionState.active:
            return Text('');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      title: Text(snapshot.data[index].name),
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.playlist_add,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () async {
                        await _addSongToPlaylistDb(
                            currentMedia, snapshot.data[index]);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }

  Future _addSongToPlaylistDb(Media currentMedia, Playlist playlist) async {
    Album currentAlbum = list.firstWhere((album) {
      return album.medias.contains(currentMedia);
    });

    Album oldAlbum = playlist.albums.firstWhere((album) {
      return album.id == currentAlbum.id;
    }, orElse: () {
      return null;
    });

    if (oldAlbum == null) {
      // there is no song corresponding to that album
      currentAlbum.medias = [currentMedia];
      playlist.albums.add(currentAlbum);
    } else {
      // that album exists with previously favorite songs so add the new song
      oldAlbum.medias.add(currentMedia);
      playlist.albums.forEach((album) {
        if (album.id == oldAlbum.id) {
          album = oldAlbum;
        }
      });
    }
    await playlistDao.update(playlist);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Song added to Playlist!'),
    ));
  }
}

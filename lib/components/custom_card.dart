
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  CustomCard({@required this.imagePath, @required this.albumName, @required this.artistName});

  final String imagePath;
  final String albumName;
  final String artistName;

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) =>
                      Image.asset('assets/placeholderAlbum.png'),
                  imageUrl: imagePath,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/placeholderAlbum.png'),
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              albumName,
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              artistName,
              style: TextStyle(color: Colors.black26),
            )
          ],
        );
  }
}
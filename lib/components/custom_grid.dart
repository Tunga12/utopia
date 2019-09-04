import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {

  const CustomGrid({@required this.imagePath, @required this.subtitle, @required this.title});

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(10, (index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: const Color(0x11000000),
                    child: Image.asset(
                      this.imagePath,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  this.title,
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  this.subtitle,
                  style: TextStyle(color: Colors.black26),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
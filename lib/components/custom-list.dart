import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  final IconData iconData;
  final Widget title;
  final Widget subtitle;

  const CustomList(
      {@required this.iconData, @required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    // final List<String> entries = <String>['A', 'B', 'C', 'D', 'B', 'C', 'D'];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          leading: CircleAvatar(
            child: Icon(
              this.iconData,
              color: Colors.white,
            ),
          ),
          title: this.title,
          subtitle: this.subtitle,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
          // height: 5.0,
          ),
    );
  }
}

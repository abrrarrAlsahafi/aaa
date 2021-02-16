import 'package:flutter/material.dart';
import 'Screen/profile.dart';

class AppBarWidget extends StatelessWidget {
  final name;

  AppBarWidget({Key key, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff336699),
      leading: null,
      automaticallyImplyLeading: false,
      title: Text("$name"),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                        ),
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      foregroundColor: Colors.white,
                      child: Text('AH'),
                    ))),
          ],
        ),
      ],
    );
  }
}

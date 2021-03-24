import 'package:flutter/material.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/meetings.dart';

class MeetingsScreen extends StatefulWidget {
  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
 List meetings,expandList=List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.kAccentColor,
      appBar: AppBar(),
      body: Container(

        child: ListView.builder(

            itemCount: meetings.length,
            itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CartTask(
              click: expandList[index],
              onTap: () {
                setState(() {
                  expandList[index] =
                  expandList[index] ? false : true;
                });
              },
              child: Container(),
              proirty: IconButton(
                  icon: Icon(Icons.star),
                  color: Color(0xffe9a14e),
                  onPressed: () {}),
              item: meetings[index],
            ),
          );
        }),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     meetings = List.generate(
        4, (index) => Meetings(
          taskName: 'Meeting $index',
        )
     );

     expandList = List.generate(meetings.length, (index) => false);

  }
}


import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/meetings.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';

class TopicScreen extends StatelessWidget {
  final Meetings item;
    final index;
  const TopicScreen({Key key, this.item, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
       title: Text(item.tobics[index].titel, style: MyTheme.kAppTitle)),
      backgroundColor: MyTheme.kAccentColor,
      body: Container(
        margin: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
color: Colors.white,
//padding: EdgeInsets.all(16),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            SizedBox(height: 30),
            Text('${item.tobics[index].titel} is by ${item.tobics[index].source}'),
            SizedBox(height: 22,),
            Text('${item.tobics[index].desc}'),
            Container(
              margin: EdgeInsets.all(10),height: 300,
              padding: EdgeInsets.all(22),
              width:MediaQuery.of(context).size.width ,
              decoration:   BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black26)],
                    color: Colors.white,
                    //  boxShadow:BoxShadow. ,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: MyTheme.kAccentColor,
                      width: 0.5,
                    )),
              //shape:,
              child: Text('Recommendations'),
            )
          ],
        ),


      ),
floatingActionButton: FlatActionButtonWidget(
  onPressed: ()=>Navigator.pop(context),
  icon: Icons.playlist_add_check_outlined,
));
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/Screen/topic.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/meetings.dart';
import 'package:management_app/model/topic.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/expanded_selection.dart';
import 'package:management_app/widget/slide_left.dart';
import 'package:management_app/widget/slide_right.dart';
import 'package:provider/provider.dart';

class MeetingsScreen extends StatefulWidget {
  final bordName;

  const MeetingsScreen({Key key, this.bordName}) : super(key: key);
  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
 List <Meetings>meetings;
 bool proi=false;
     List  expandList=List(), topicExpand=List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.kAccentColor,
      appBar: AppBar(backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_outlined, color: MyTheme.kPrimaryColorVariant,)),
      title: Text(widget.bordName, style: MyTheme.kAppTitle,)),
      body: Container(
        child: ListView.builder(
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              topicExpand=List.generate(meetings[index].tobics.length, (index) => false);
              return Container(
            padding: const EdgeInsets.all(8.0),
            child: Dismissible(
              key: Key('${meetings[index].taskName}'),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final bool res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialogPM(
                            index: meetings[index],
                            dearection: false,
                            title: Text("Replay",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ));

                      });
                  print('resors ... $res');
                } else if (direction == DismissDirection.startToEnd) {
                  final bool res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialogPM(
                            index: meetings[index],
                            dearection: false,
                            title: Text("Replay",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ));
                      });}
              },
              background: SlideRightBackgroundWidget(),
              secondaryBackground: SlideLeftWidget(
                icon: Icons.redo,
                title: (Provider.of<UserModel>(context).user.isAdmin)
                    ? "Send"
                    : "Assign",
              ),
              child: CartTask(
                click: expandList[index],
                onTap: () {
                  setState(() {
                    expandList[index] =
                    expandList[index] ? false : true;
                  });
                },
                child: Container(
                  height: meetings[index].tobics.length*110.0,
                  //Topics item
                  padding: EdgeInsets.all(8),
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, i){
                        return TextButton(onPressed:() => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TopicScreen(item: meetings[index],index: i))
                        ),
                            child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    boxShadow: [BoxShadow(color: Colors.black26)],
                                    color: Colors.white,
                                    //  boxShadow:BoxShadow. ,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: MyTheme.kAccentColor,
                                      width: 0.5,
                                    )),
                                child: ListTile(
                                    dense: true,
                                    title: Text("${meetings[index].tobics[i].titel}",
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    subtitle: Text("by ${ meetings[ index].tobics[i].source}",
                                        style: TextStyle(fontSize: 10))),
                              ),
                            );

                      },
                      separatorBuilder: (context, i) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ), itemCount: topicExpand.length),
                ),
                listTile: ListTile(

                    dense: true,
                    title: Text( meetings[ index].taskName,
                        style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(
                        "No. ${meetings[ index].namber} is ${meetings[index].taskStage} \non ${ DateFormat.yMd().add_jm().format(DateTime.now())}",
                        style: TextStyle(fontSize: 10))),
              ),
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
           tobics:[Topic(titel: 'Topic 1',desc: 'Topic 1 descriptions', source: 'IT'
           ),Topic(titel: 'Topic 1',desc: 'Topic 1 descriptions', source: 'Financial'),
             Topic(titel: 'T 3',desc: 'Topic 3 descriptions', source: 'HR')],
           taskName: 'Season $index',
           createDate: "${DateTime.now()}",
           taskStage:'Approval',
       namber: 8822,

     )
     );
     expandList = List.generate(meetings.length, (index) => false);
  }
}

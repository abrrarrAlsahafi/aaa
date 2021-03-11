import 'dart:async';
import 'package:management_app/Screen/create_meeting.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/expanded_selection.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  bool isAdmin;
  final projectid;
  TaskScreen({Key key, this.isAdmin, this.projectid}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}
List stageList = ['New', 'Assign', 'In Progress', 'Done', 'Canceled'];
List<bool> expandList;//=[false,false,false];
List<Task> taskList=List();//.generate(6, (index) => Task(taskName: 'task$index'));
class _TaskScreenState extends State<TaskScreen> with TickerProviderStateMixin {
  String dropdownValue; //= 'New';
  List listStageTask = List();
  bool _disposed = false;
  TabController _tabController;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    taskHistory();
    _tabController = TabController(vsync: this, length: stageList.length);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  taskGeneriate(){
}
  Future<void> taskHistory() async {
    taskList =
    await Provider.of<TaskModel>(context, listen: false).getUserTasks(widget.projectid);
    expandList=List.generate(taskList.length, (index) => false);

    setState(() {});
  }
bool click = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }


  Widget slideRightBackground() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.circular(8.0),
        color: MyTheme.kPrimaryColorVariant,

      ),
      child: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(  width: 10 ),
            Icon(
              Icons.reply,
              color: Colors.white
            ), 
            SizedBox(  width: 10 ),
            Text(
              "Reply",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left
            ),
          ],
        ),
        alignment: Alignment.centerLeft
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
    borderRadius:  BorderRadius.circular(8.0),color: Color(0xffe9a14e)),
      child: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[


            Icon(
              (Provider.of<UserModel>(context).user.isAdmin)? Icons.person_add_outlined:Icons.redo,
              color: Colors.white,
            ),
            Text(
              (Provider.of<UserModel>(context).user.isAdmin)?" Assign to": "Next State",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(width: 12),

            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context,myTask,_) {
        //myTask.userTasks.;
        return  Scaffold(
          appBar: AppBar(),
                  backgroundColor: MyTheme.kAccentColor,
                  floatingActionButton: FlatActionButtonWidget(
                    icon: Icons.playlist_add,
                    onPressed: () =>
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            CreateMeetings(
                              isTask: true, projectid: widget.projectid,)))
                            .then((value) {
                          setState(() {
                            taskList;
                          });
                        }),
                    tooltip: 'task',
                  ), //:Container(),
                  body: taskList.isEmpty
                      ? Center(
                    child: Text('No Task..'),
                  ) :
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                          itemCount: taskList.length,
                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.symmetric(vertical: 6,horizontal: 1),
                                child: Dismissible(
                                    key: Key('${taskList[index].taskName}'),
                                    child: CartTask(
                                        click: expandList[index],
                                        onTap: () {
                                          setState(() {
                                            expandList[index] =
                                            expandList[index] ? false : true;
                                          });
                                        },
                                        item: taskList[index] // listOftask(stageList[i],  stageList, taskList)[index],
                                    ),
                                    background:
                                    slideRightBackground(),
                                    secondaryBackground: slideLeftBackground(),
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        final bool res = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialogPM(
                                                  index: taskList[index],
                                                  dearection: true,
                                                  title: Text((Provider
                                                      .of<UserModel>(
                                                      context, listen: false)
                                                      .user
                                                      .isAdmin)
                                                      ?
                                                  "You want to assgin ${taskList[index]
                                                      .taskName} task to?"
                                                      : "Log note"));
                                            });
                                        await Provider.of<TaskModel>(
                                            context, listen: false)
                                            .assginTaskTo(Provider
                                            .of<TaskModel>(
                                            context, listen: false)
                                            .uidAssigind, 12);
                                      } else if (direction ==
                                          DismissDirection.startToEnd) {
                                        final bool res = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialogPM(
                                                  index: taskList[index],
                                                  dearection: false,
                                                  title: Text((Provider
                                                      .of<UserModel>(
                                                      context, listen: false)
                                                      .user
                                                      .isAdmin) ?
                                                  "Log note" : "Replay"));
                                            });
                                      }
                                    }));
                          }))
              );


      } );
  }


}
class AlertDialogPM extends StatefulWidget {
  final index;
final title;
final content;
final dearection;

AlertDialogPM({Key key, this.title, this.content, this.dearection, this.index}) : super(key: key);

  @override
  _AlertDialogPMState createState() => _AlertDialogPMState();
}

class _AlertDialogPMState extends State<AlertDialogPM> {
final _formKey = GlobalKey<FormState>();

bool _autoValidate = false;
bool massgeReseve=false;
String lognot;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: widget.title, //,
        content:
       widget.dearection?
          Container(
          width: double.minPositive,
          height: 300,
          child: ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: Colors.black12,
              ),
            ),
            shrinkWrap: true,
            itemCount: Provider.of<FollowingModel>(context,listen: false).followList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text( Provider.of<FollowingModel>(context,listen: false).followList[index].name),
                onTap: () {
setState(() {
  Provider.of<TaskModel>(context, listen: false).uidAssigind=
      Provider.of<FollowingModel>(context,listen: false).followList[index].id;
});                  Navigator.of(context).pop();
                  ///Todo: edit assigin to new employee
                },
              );
            },
          ),
        )
        : Container(
          width: double.minPositive,
          height: 120,
          child:Column(
            children: [
              Expanded(
                child:  Container(
                    child: Form(
                      key: _formKey,
                      //autovalidate: _autoValidate,
                      child: TextFormField(

                        validator: (value) {
                          if (value.isEmpty) {
                            return S.of(context).empty;
                          } else return null;
                        },
                        onSaved: (String value) {
                          lognot = value;
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,

                          contentPadding: new EdgeInsets.only(
                              left: 10.0,
                              top: 10.0,
                              bottom: 10.0,
                              right: 10.0),
                          hintText: 'add review',
                          hintStyle: new TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.0,
                            //fontFamily: 'helvetica_neue_light',
                          ),
                        ),
                      ),
                    )),
                flex: 2,
              ),

              // dialog bottom
               Container(
                // padding: new EdgeInsets.all(16.0),
                decoration: new BoxDecoration(
                    color: MyTheme.kPrimaryColorVariant
                    //borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child:massgeReseve?Icon(Icons.check_circle_rounded, color: Color(0xffe9a14e)): FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                     await Provider.of<TaskModel>(context, listen: false).logNot(lognot, 1//index.id
                      );
                     setState(() {
                       massgeReseve=true;
                     });
                        Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Okay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ) ],
          ),
        )
    );  }
}


getTab(index, child, _selectedTab) {
  return Tab(
    child: SizedBox.expand(
      child: Container(
        child: Center(
          child: Text(
            child,
            style: TextStyle(fontSize: 11),
          ),
        ),
        decoration: BoxDecoration(
            color: (_selectedTab == index ? Colors.white : Color(0xfff3f6fc)),
            borderRadius: _generateBorderRadius(index, _selectedTab)),
      )
    )
  );
}

_generateBorderRadius(index, _selectedTab) {
  if ((index + 1) == _selectedTab)
    return BorderRadius.only(bottomRight: Radius.circular(10.0));
  else if ((index - 1) == _selectedTab)
    return BorderRadius.only(bottomLeft: Radius.circular(10.0));
  else
    return BorderRadius.zero;
}

class CartTask extends StatelessWidget {
  final item;
  final onTap;
  final click;
 // final isProject;
   CartTask({Key key, this.item, this.onTap, this.click,this.onTapstar}) : super(key: key);
    final onTapstar;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              boxShadow:[ BoxShadow(color: Colors.black26)],
              color: Colors.white,
    //  boxShadow:BoxShadow. ,
    borderRadius:  BorderRadius.circular(8.0),
    border: Border.all(
    color: MyTheme.kAccentColor,
    width: 0.5,
    )),
              child: Column(
                children: [
                //  SizedBox(height: 22),
                //  ListTile(leading :Text('Project name: ', ), title: Text(task.project.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),dense: true  ),
                  ListTile(leading: Icon(Icons.star_border, color: Color(0xffe9a14e)),
                      dense: true,
                      title: Text(item.project==null?'':item.project.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                      subtitle:Text( item.taskName,  style:TextStyle(fontWeight: FontWeight.w300, fontSize: 16))),
             ExpandedSection(
                    child: Column(
                      children: [

                        ListTile(leading:Icon(Icons.date_range),
                          title: Text( "Created by  ${item.createBy}  on  ${item.createDate}",
                              style:TextStyle(fontWeight: FontWeight.w300, fontSize: 13)
                          ),// subtitle: Text( item.desc==null?'Task Description ':item.desc,
                          // style:TextStyle(fontWeight: FontWeight.w300, fontSize: 18)
                          //  )
                        ),
                        ListTile(leading:Icon(Icons.date_range),
                                title: Text( "Created by  ${item.createBy}  on  ${item.createDate}",
                                    style:TextStyle(fontWeight: FontWeight.w300, fontSize: 13)
                                ),// subtitle: Text( item.desc==null?'Task Description ':item.desc,
                                 // style:TextStyle(fontWeight: FontWeight.w300, fontSize: 18)
                            //  )
             ),
                      ],
                    ),
                    expand: click,
                  )
                ],
              ),
            ),
    );
  }
}

///todo:
Color taskColor(String a){
  List stageList = ['New', 'Assign', 'In Progress', 'Done', 'Canceled'];
  // return Color
}

List listOftask(String s, sList, tList) {
  for (int i = 0; i < sList.length; i++) {
    if (s == sList[i]) {
      return tList.where((element) => element.state == s).toList();
    }
  }
}

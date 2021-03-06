import 'dart:async';
import 'package:management_app/Screen/create_meeting.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/expanded_selection.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  bool isAdmin;
  TaskScreen({Key key, this.isAdmin}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}
List stageList = ['New', 'Assign', 'In Progress', 'Done', 'Canceled'];
List<bool> expandList=[false,false,false];
List<Task> taskList=List();//.generate(2, (index) => Task(taskName: 'a$index'));
class _TaskScreenState extends State<TaskScreen> with TickerProviderStateMixin {
  String dropdownValue; //= 'New';
  List listStageTask = List();
  bool _disposed = false;
  TabController _tabController;

  int _selectedTab = 0;

  @override
  void initState() {
    //Timer(Duration(seconds: 1), () {  if (!_disposed) this.taskHistory();});
    super.initState();
    taskGeneriate();
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
    expandList.where((item) => item == false).length;//=List.generate(taskList.length, (index) => ()=>expandList[i])
}
  Future<void> taskHistory() async {
    taskList = await Provider.of<TaskModel>(context, listen: false).getUserTasks();
    listStageTask = listOftask(dropdownValue, stageList, taskList);
    setState(() {});
  }
bool click = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
 // final itemsList = List<String>.generate(10, (n) => "List item ${n}");


  Widget slideRightBackground() {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.green,
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
      color: Color(0xffe9a14e),
      child: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

            Text(
              (Provider.of<UserModel>(context).user.isAdmin)?" Assign to": "Next State",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(width: 12),
            Icon(
              (Provider.of<UserModel>(context).user.isAdmin)? Icons.person_add_outlined:Icons.redo,
              color: Colors.white,
            ),
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
    return Scaffold(
      appBar: AppBar(),
backgroundColor: hexToColor('#F3F6FC'),
      body: FutureBuilder<void>(builder: (context, snapshot) {
        print(taskList.toString());
        if (snapshot.hasError || taskList == null){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
        else {
          return Scaffold(
            floatingActionButton: FlatActionButtonWidget(
              icon: Icons.playlist_add,
                onPressed: ()=> Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CreateMeetings(isTask:true,))).then((value) {
                      setState(() {
                        taskList;
                    });}),
                tooltip: 'task',
              ),//:Container(),
            body: taskList.isEmpty
                ? Center(
                    child: Text('No Task..'),
                  ):
                 Padding(
              padding: const EdgeInsets.all(12.0),
                        child: ListView.builder(
                            itemCount: taskList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(12),
                                child: Dismissible(
                                  key:Key('${taskList[index].taskName}') ,
                                  child: CartTask(
                                            click:expandList[index],
                                            onTap:  (){
                                              setState(() {
                                                expandList[index]=expandList[index]?false:true;
                                              });
                                            },
                                      item:taskList[index]// listOftask(stageList[i],  stageList, taskList)[index],
                                    ),
                                  background: Provider.of<UserModel>(context).user.isAdmin?Container():
                                    slideRightBackground(),
                                  secondaryBackground: slideLeftBackground(),
                                  confirmDismiss: (direction) async {
                                    if (direction == DismissDirection.endToStart) {
                                      final bool res = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialogWidget(index,direction);
                                          });
                                      return res;
                                    } else if(direction == DismissDirection.startToEnd){
                                      final bool res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
      title: Text( "Why you want to redirct task to?"),
      content:  Container(
      width: double.minPositive,
      height: 120,
      child:Column(
        children: [
          Expanded(
            child: new Container(
                child: new TextField(
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: new EdgeInsets.only(
                        left: 10.0,
                        top: 10.0,
                        bottom: 10.0,
                        right: 10.0),
                    hintText: ' add review',
                    hintStyle: new TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.0,
                      fontFamily: 'helvetica_neue_light',
                    ),
                  ),
                )),
            flex: 2,
          ),

          // dialog bottom
            new Container(
             // padding: new EdgeInsets.all(16.0),
              decoration: new BoxDecoration(
                color: const Color(0xffe9a14e),
                borderRadius: BorderRadius.all(Radius.circular(18))
              ),
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: 'helvetica_neue_light',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ) ],
      ),
      ));
      }); } },

                              ));
                            }))
 );
        }
      }),
    );
  }

  Widget AlertDialogWidget(index, direction) {
    return AlertDialog(
        title: Text((Provider.of<UserModel>(context).user.isAdmin)? "You want to assgin ${taskList[index].taskName} task to?":"Log note"),
        content:(Provider.of<UserModel>(context).user.isAdmin)? Container(
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
                    taskList.removeAt(direction.index);
                  });
                  Navigator.of(context).pop();
                  ///Todo: edit assigin to new employee
                },
              );
            },
          ),
        ):
        Container(
    width: double.minPositive,
    height: 120,
    child:Column(
    children: [
    Expanded(
    child: new Container(
    child: new TextField(
    decoration: new InputDecoration(
    border: InputBorder.none,
    filled: false,
    contentPadding: new EdgeInsets.only(
    left: 10.0,
    top: 10.0,
    bottom: 10.0,
    right: 10.0),
    hintText: ' add review',
    hintStyle: new TextStyle(
    color: Colors.grey.shade500,
    fontSize: 12.0,
    fontFamily: 'helvetica_neue_light',
    ),
    ),
    )),
    flex: 2,
    ),

    // dialog bottom
    new Container(
    // padding: new EdgeInsets.all(16.0),
    decoration: new BoxDecoration(
    color: const Color(0xffe9a14e),
    borderRadius: BorderRadius.all(Radius.circular(18))
    ),
    child: FlatButton(
    onPressed: (){
    Navigator.pop(context);
    },
    child: Text(
    'Okay',
    style: TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontFamily: 'helvetica_neue_light',
    ),
    textAlign: TextAlign.center,
    ),
    ),
    ) ],
    ),
        )
    );
  }
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
      ),
    ),
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
            decoration: BoxDecoration(
    //  boxShadow:BoxShadow. ,
    borderRadius:  BorderRadius.circular(8.0),
    border: Border.all(
    color: Colors.grey,
    width: 0.5,
    )),
              child: Column(
                children: [
                //  SizedBox(height: 22),
               //   ListTile(leading :Text('Project name: ', ), title: Text(task.project.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),dense: true  ),
                  ListTile(leading: Icon(Icons.star_border, color: Color(0xffe9a14e)),
                      dense: true,
                     // title: Text(item.project.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                      subtitle:Text( item.taskName,  style:TextStyle(fontWeight: FontWeight.w300, fontSize: 16))),
             ExpandedSection(
                    child: ListTile(leading:Icon(Icons.date_range),
                            title: Text( "Created by  ${item.createBy}  on  ${item.createDate}",
                                style:TextStyle(fontWeight: FontWeight.w300, fontSize: 13)
                            ), subtitle: Text( item.desc==null?'Task Description ':item.desc,
                              style:TextStyle(fontWeight: FontWeight.w300, fontSize: 18)
                          ) ),
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

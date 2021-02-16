import 'dart:async';
import 'package:intl/intl.dart';
import 'package:management_app/Screen/create_meeting.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/model/task.dart';
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
bool expand= false;
class _TaskScreenState extends State<TaskScreen> with TickerProviderStateMixin {
  List stageList = ['New', 'Assign', 'In Progress', 'Done', 'Canceled'];
  String dropdownValue; //= 'New';
  List<Task> taskList; //= List();
  List listStageTask = List();
  bool _disposed = false;
  TabController _tabController;

  int _selectedTab = 0;

  @override
  void initState() {
     Timer(Duration(seconds: 1), () {
      if (!_disposed) this.taskHistory();
    });
    super.initState();

    _tabController = TabController(vsync: this, length: stageList.length);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  Future<void> taskHistory() async {
    taskList =
        await Provider.of<TaskModel>(context, listen: false).getUserTasks();
    listStageTask = listOftask(dropdownValue, stageList, taskList);
    setState(() {});
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(builder: (context, snapshot) {
      if (snapshot.hasError || taskList == null) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      } else {
        return Scaffold(
           /* floatingActionButton:widget.isAdmin? FlatActionButtonWidget(
              onPressed: ()=> Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CreateTask())),
              tooltip: 'task',
            ):Container(),*/
          body: taskList.isEmpty
              ? Center(
                  child: Text('No Task..'),
                )
              : DefaultTabController(
                  length: stageList.length,
                  child: Column(
                    children: <Widget>[
                      Material(
                        // color: Colors.grey.shade300,
                        child: TabBar(
                            indicatorWeight: 5.0,
                            labelPadding: EdgeInsets.zero,
                            unselectedLabelColor: Color(0xff336699),
                            labelColor: Color(0xffe9a14e),
                            indicatorColor: Color(0xffe9a14e),
                            controller: _tabController,
                            tabs: [
                              for (int i = 0; i < stageList.length; i++)
                                getTab(i, stageList[i], _selectedTab),
                            ]),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              for (int i = 0; i < stageList.length; i++)
                                SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: ListView.builder(
                                        itemCount: listOftask(stageList[i],
                                                stageList, taskList)
                                            .length,
                                        itemBuilder: (context, index) {
                                          // print('${ listOftask(stageList[i]).length}');
                                          return CartTask(
                                            onTap:
                                                false,
                                            task: listOftask(stageList[i],
                                                stageList, taskList)[index],
                                          );
                                        }))
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
        );
      }
    });
  }
}

getTab(index, child, _selectedTab) {
  // child=S.of(context).
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
  final Task task;
  final onTap;
  const CartTask({Key key, this.task, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            clipBehavior: Clip.none,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              children: [
                ListTile(leading :Text('Project name: '), title: Text(task.project.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),dense: true  ),
                ListTile(leading:Text('Task:') ,
                    dense: true,
                    title:Text(
    task.taskName,
    style:TextStyle(fontWeight: FontWeight.w300, fontSize: 16)
    )),
           onTap?     ListTile(leading:Text('Create by: ') ,
                    dense: true,
                    title:Text( task.createBy,
                       style:TextStyle(fontWeight: FontWeight.w300, fontSize: 16)
                    ), subtitle: Text(
                      task.createDate),):
               Container()

              ],
            ),
          ),
        ],
      ),
    );
  }
}

List listOftask(String s, sList, tList) {
  for (int i = 0; i < sList.length; i++) {
    if (s == sList[i]) {
      return tList.where((element) => element.state == s).toList();
    }
  }
}

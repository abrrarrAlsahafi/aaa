import 'dart:async';
import 'package:intl/intl.dart';
import 'package:management_app/Screen/create_meeting.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/note.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/buttom_widget.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/expanded_selection.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'chat/chat_list.dart';

class TaskScreen extends StatefulWidget {
  bool isAdmin;
  final projectid;
  final TabController tabController;

  TaskScreen({Key key, this.isAdmin, this.projectid, this.tabController})
      : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

List stageList = ['New', 'Assign', 'In Progress', 'Done', 'Canceled'];
List<bool> expandList; //=[false,false,false];

class _TaskScreenState extends State<TaskScreen> with TickerProviderStateMixin {
  String dropdownValue; //= 'New';
  List listStageTask = List();
  bool _disposed = false;
  TabController _tabController;
  List<Task> taskList;
  int _selectedTab = 0;
  Future<TaskModel> _calculation;

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

  taskHistory() async {
    // print("frist $taskList");
    taskList = await Provider.of<TaskModel>(context, listen: false)
        .getUserTasks(widget.projectid.id);

    expandList = List.generate(taskList.length, (index) => false);
    setState(() {});
    // });
    //  return taskList;
  }

  bool click = false;

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this.taskHistory());
    _disposed = true;
    taskList.clear();
    super.dispose();
  }

  Widget slideRightBackground() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: MyTheme.kPrimaryColorVariant,
      ),
      child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              Icon(Icons.reply, color: Colors.white),
              SizedBox(width: 10),
              Text("Reply",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left),
            ],
          ),
          alignment: Alignment.centerLeft),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: Color(0xffe9a14e)),
      child: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              (Provider.of<UserModel>(context).user.isAdmin)
                  ? Icons.person_add_outlined
                  : Icons.redo,
              color: Colors.white,
            ),
            Text(
              (Provider.of<UserModel>(context).user.isAdmin)
                  ? " Assign to"
                  : "Next State",
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

  bool addTask = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                  ),
                  color: MyTheme.kPrimaryColorVariant,
                  onPressed: () {
                    Navigator.pop(context, addTask);
                  })),
          title: Text(widget.projectid.name, style: MyTheme.kAppTitle),
        ),
        backgroundColor: MyTheme.kAccentColor,
        floatingActionButton: FlatActionButtonWidget(
          icon: Icons.playlist_add,
          onPressed: () async {
            var result = await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => new CreateMeetings(
                    isTask: true,
                    projectid: widget.projectid.id,
                  ),
                  fullscreenDialog: true,
                ));
            setState(() {
              addTask = result;
            });
          },
          tooltip: 'task',
        ), //:Container(),
        body: FutureBuilder<void>(builder: (BuildContext context, snapshot) {
          if (snapshot.hasData || taskList == null) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff336699),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          } else if (taskList.isEmpty) {
            return Center(
                child: Column(
              children: [
                SizedBox(height: 50),
                Icon(Icons.playlist_add,
                    size: MediaQuery.of(context).size.width / 2,
                    color: Colors.grey[300]),
                SizedBox(height: 50),
                ContentApp(
                  code: 'noTask',
                  style: MyTheme.bodyTextTask,
                ),
              ],
            ));
          } else {
            return bodyTask();
          }
        }));
    //));
  }

  bool proi = false;

  bodyTask() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 1),
                  child: Dismissible(
                      key: Key('${taskList[index].taskName}'),
                      child: CartTask(
                        child: TaskNote(note: [
                          Note(
                              name: 'Shaya',
                              messege: 'Assigned to:System Muhammad Faizal NS'),
                          Note(
                              name: 'Shaya',
                              messege:
                              'Dear customer,\nThank you for your enquiry.\nIf you have any questions,\nplease let us know.Thank you,\nread more')
                        ] //,Note(messege: 'assiiiii'),Note(id: 0,sender:,messege: 'aaaaaa' )],
                        ),
                          click: expandList[index],
                          onTap: () {
                            setState(() {
                              expandList[index] =
                                  expandList[index] ? false : true;
                            });
                          },
                          //proi: proi,

                          proirty: IconButton(
                              icon: Icon(proi ? Icons.star : Icons.star_border),
                              color: Color(0xffe9a14e),
                              onPressed: () {
                                setState(() {
                                  proi = proi ? proi : false;
                                });
                              }),
                          item: taskList[ index]
                          ),
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialogPM(
                                    // taskId: taskList[index],
                                    index: taskList[index],
                                    dearection: true,
                                    title: Text(
                                      (Provider.of<UserModel>(context,
                                                  listen: false)
                                              .user
                                              .isAdmin)
                                          ? "You want to assgin ${taskList[index].taskName} task to?"
                                          : "Log note",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ));
                              });
                          await Provider.of<TaskModel>(context, listen: false)
                              .assginTaskTo(
                                  uid: Provider.of<TaskModel>(context,
                                          listen: false)
                                      .uidAssigind,
                                  tid: taskList[index].taskId);
                        } else if (direction == DismissDirection.startToEnd) {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialogPM(
                                    index: taskList[index],
                                    dearection: false,
                                    title: Text(
                                      (Provider.of<UserModel>(context,
                                                  listen: false)
                                              .user
                                              .isAdmin)
                                          ? "Log note"
                                          : "Replay",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ));
                              });
                        }
                      }));
            }));
  }
}

class AlertDialogPM extends StatefulWidget {
  final index;
  final title;
  final content;
  final dearection;

  AlertDialogPM(
      {Key key, this.title, this.content, this.dearection, this.index})
      : super(key: key);

  @override
  _AlertDialogPMState createState() => _AlertDialogPMState();
}

class _AlertDialogPMState extends State<AlertDialogPM> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  bool massgeReseve = false;
  String lognot;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: widget.title,
        content: widget.dearection
            ? Provider.of<UserModel>(context, listen: false).user.isAdmin
                ? Container(
                    width: MediaQuery.of(context).size.width /
                        5, //double.minPositive,
                    height: MediaQuery.of(context).size.height / 3,
                    child: massgeReseve
                        ? Icon(Icons.check_circle_rounded,
                            size: 66, color: Color(0xffe9a14e))
                        : ListView.separated(
                            separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Divider(
                                color: Colors.black12,
                              ),
                            ),
                            shrinkWrap: true,
                            itemCount: Provider.of<FollowingModel>(context,
                                    listen: false)
                                .followList
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(Provider.of<FollowingModel>(context,
                                        listen: false)
                                    .followList[index]
                                    .name),
                                onTap: () {
                                  setState(() {
                                    massgeReseve = true;
                                    Provider.of<TaskModel>(context,
                                                listen: false)
                                            .uidAssigind =
                                        Provider.of<FollowingModel>(context,
                                                listen: false)
                                            .followList[index]
                                            .id;
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                  )
                : alertDialogAddnote()
            : alertDialogAddnote());
  }

  alertDialogAddnote() {
    return Container(
      width: MediaQuery.of(context).size.width / 2, //double.minPositive,
      height: MediaQuery.of(context).size.height / 3,
      child: massgeReseve
          ? Icon(Icons.check_circle_rounded, size: 66, color: Color(0xffe9a14e))
          : Column(
              children: [
                Expanded(
                  child: Container(
                      child: Form(
                    key: _formKey,
                    //autovalidate: _autoValidate,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return S.of(context).empty;
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        lognot = value;
                      },
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: new EdgeInsets.only(
                            left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                        hintText: 'add review',
                        hintStyle: new TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.0,
                          //fontFamily: 'helvetica_neue_light',
                        ),
                      ),
                    ),
                  )),
                  // flex: 2,
                ),

                // dialog bottom
                ButtonWidget(
                  // padding: new EdgeInsets.all(16.0),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      await Provider.of<TaskModel>(context, listen: false)
                          .logNot(lognot, widget.index.taskId //index.id
                              );
                      setState(() {
                        massgeReseve = true;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
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
  )));
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
  final proirty;
  final child;

  // final isProject;
  CartTask(
      {Key key,
      this.item,
      this.onTap,
      this.click,
      this.onTapstar,
      this.proirty, this.child})
      : super(key: key);
  final onTapstar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        child: Column(
          children: [
            //  SizedBox(height: 22),
            //  ListTile(leading :Text('Project name: ', ), title: Text(task.project.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),dense: true  ),
            ListTile(
                leading: proirty,
                dense: true,
                title: Text(item.taskName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(
                    "by ${item.createBy}  on  ${DateFormat.yMMMd().format(item.createDate == null ? DateTime.now() : DateTime.parse(item.createDate))} \nTo ${item.assignedTo}",
                    style: TextStyle(fontSize: 10))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: Colors.black12,
              ),
            ),

            ExpandedSection(
              child: Column(
                children: [

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),
                  Container(
                    height: 200,
                    // decoration: Bo,
                    //   color: Colors.grey[100],
                    child: child
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
Color taskColor(String a) {
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

class TaskNote extends StatelessWidget {
  final List<Note> note;

  const TaskNote({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List items =
        List.generate(note.length, (index) => MessageItem(note[index], true));
    return ListView.separated(
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Divider(
          color: Colors.black12,
        ),
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: EdgeInsets.all(12),
          color: MyTheme.kAccentColor,
          child: ListTile(
            dense: false,
            leading: CircleAvatar(
                radius: 18,
                backgroundColor: MyTheme.kPrimaryColorVariant,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
            title: item.buildTitle(context),
            subtitle: Text(
              note[index].messege,
              style: MyTheme.bodyTextMessage,
            ), //item.buildSubtitle(context),
            // trailing: item.buildTrailing(context),
          ),
        );
      },
    );
  }
}

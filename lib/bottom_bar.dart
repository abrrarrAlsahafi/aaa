import 'dart:async';
import 'package:flutter/material.dart';
import 'package:management_app/Screen/login_page.dart';
import 'package:management_app/Screen/project.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/widget/my_tab_bar.dart';
import 'package:provider/provider.dart';
import 'Screen/chat/chat_list.dart';
import 'Screen/tasks.dart';
import 'common/constant.dart';
import 'generated/I10n.dart';
import 'model/channal.dart';
import 'model/massege.dart';
import 'model/user.dart';
import 'route.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key key}) : super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

int selectedIndex = 0;

bool search = false;

List<RouteApp> allDestinations;
String t1, t2, t3, t4, t5;
bool isLoggedIn = false;
NewMessages newMessege;
int totalMessges = 0;

class _BottomBarState extends State<BottomBar>  with TickerProviderStateMixin{
  String nameUser;
  Timer timer;
  String s;
  TabController tabController;
  int currentTabIndex = 0;

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
      print(currentTabIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      onTabChange();
    });
    Future.delayed(Duration(seconds: 2), () {
      //this._getAppTitle();
      this.checkForNewSharedLists();
      this.config();
    });
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      print('the total bottom bar $totalMessges');
      checkForNewSharedLists();
    });
  }

  config() async {
    await Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
    await Provider.of<FollowingModel>(context, listen: false)
        .getfollowingList();
  }

  checkForNewSharedLists() async {
    newMessege = await Provider.of<NewMessagesModel>(context,
        listen: false) //.newMessages
        .newMessagesList();
    setState(() {
      totalMessges = newMessege.totalNewMessages;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    tabController.addListener(() {
      onTabChange();
    });
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar:appBar(),
        backgroundColor: hexToColor('#F3F6FC'),
        body: Column(
              children: [
                MyTabBar(tabController: tabController),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: TabBarView(
                      controller: tabController,
                      children: [
                       ChatList(),
                        Projects()
                      ],
                    ),
                  ),
                )
              ],

      ),
    ))
        : LoginPage();
  }

  appBar() {
    return  AppBar(
      backgroundColor: Color(0xff336699),
      leading: IconButton(icon: Icon(Icons.menu_outlined,color: Colors.white), onPressed:() => Navigator.pushNamed(context, '/d'),
    ),
      automaticallyImplyLeading: false,
      title: Align(
          alignment: Alignment.topLeft,
          child:
          Text("${Provider
              .of<UserModel>(context)
              .user
              .name}")),
      actions: <Widget>[

            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  search=search?false:true;
                //  serchTask=serchTask?
                });
              },
            )
      ],

    );
  }
}

String getInitials(String n) {

  return n.toString().substring(0, 2);
}


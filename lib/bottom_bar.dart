import 'dart:async';
import 'package:flutter/material.dart';
import 'package:management_app/Screen/project.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/widget/my_tab_bar.dart';
import 'package:provider/provider.dart';
import 'Screen/board.dart';
import 'Screen/chat/chat_list.dart';

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
//NewMessages newMessege;
int totalMessges;

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
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
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      onTabChange();
    });
    Future.delayed(Duration(seconds: 1), () {
      this.checkForNewSharedLists(context);
    });
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      checkForNewSharedLists(context);
      print('the total bottom bar $totalMessges');
    });
  }

  @override
  void setState(fn) {
    if (mounted) {

      super.setState(fn);
    }
  }


  checkForNewSharedLists(context) async {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    totalMessges = await Provider.of<NewMessagesModel>(context, listen: false)
        .newMessagesList(context);

    if (mounted) {
      setState(() {});
    }

    if(totalMessges>0){
      getnewMasseges(context);

    }

    // });
    /* newMessege = await Provider.of<NewMessagesModel>(context, listen: false).newMessagesList();
   setState(() {
      totalMessges = newMessege.totalNewMessages;
  });*/
  }


  getnewMasseges(context)  {
    checkForNewSharedLists(context);
    if (Provider.of<NewMessagesModel>(context, listen: false).newMessages.totalNewMessages > 0) {
      List<ChannelMessages> newMsList =  Provider.of<NewMessagesModel>(context, listen: false).newMessages.channelMessages;
      newMsList.forEach((element) {
        Provider.of<ChatModel>(context,listen: false).chatsList.forEach((e) {
          if (e.id == element.channelId) {
            e.newMessage = true;
            e.lastMessage = element.lastMessage;
            e.lastDate = element.lastDate;
            Provider.of<ChatModel>(context, listen: false).orderByLastAction();

          }
          else {
            e.newMessage = false;
           // Provider.of<ChatModel>(context, listen: false)
            Provider.of<ChatModel>(context, listen: false).orderByLastAction();
          }
        });

      });
    }
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: appBar(),
            backgroundColor: MyTheme.kAccentColor,
            body: FutureBuilder<void>(builder: (context, asyncProduct) {
              if (asyncProduct.hasError || totalMessges == null) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xff336699),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                return Column(
                    children: [
                      MyTabBar(
                          tabController: tabController,
                          totalmassege: totalMessges == null
                              ? 0
                              : totalMessges),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery
                              .of(context)
                              .size
                              .width / 60),
                          color: MyTheme.kAccentColor,
                          child: TabBarView(
                            controller: tabController,
                            children: [ChatList(),Projects(),BoardScreen()],
                          ),
                        ),
                      )
                    ],
                    //)))
                  );
              }
            })));
  }
  appBar() {
    return AppBar(
      elevation: 0.5,
      backgroundColor:Color(0xff336699),
      leading: IconButton(
        icon: Icon(Icons.menu_outlined, color:Colors.white
        ),
        onPressed: () => Navigator.pushNamed(context, '/d'),
      ),
      automaticallyImplyLeading: false,
      title: Align(
          alignment: Alignment.topLeft,
          child: Text("${Provider
              .of<UserModel>(context)
              .user
              .name}",style: TextStyle(color: Colors.white),)),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color:Colors.white,
          ),
          onPressed: () {
            setState(() {
              search = search ? false : true;
            });
          },
        )
      ],
    );
  }


  String getInitials(String n) {
    return n.toString().substring(0, 2);
  }
}
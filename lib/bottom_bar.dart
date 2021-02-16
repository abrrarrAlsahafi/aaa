import 'dart:async';
import 'package:flutter/material.dart';
import 'package:management_app/model/folowing.dart';
import 'package:provider/provider.dart';
import 'Screen/chat/chat_list.dart';
import 'Screen/profile.dart';
import 'Screen/tasks.dart';
import 'common/constant.dart';
import 'generated/I10n.dart';
import 'model/channal.dart';
import 'model/massege.dart';
import 'model/user.dart';
import 'route.dart';

class BottomBar extends StatefulWidget {

  const BottomBar({
    Key key
  }) : super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

bool search = false;

List<RouteApp> allDestinations;
String t1, t2, t3, t4, t5;
int selectedIndex = 0;
PageController pageController;
bool isLoggedIn = false;
NewMessages newMessege;
int totalMessges = 0;

class _BottomBarState extends State<BottomBar> {
  String nameUser;
  // bool _disposed = false;
  List<Chat> chatHestoryList;
  Timer timer;

  String s;

 @override
  void initState() {
    super.initState();

    getUserLangouge();
    Future.delayed(Duration(seconds: 1), () {
      this._getAppTitle();
      this.checkForNewSharedLists();
this.config();
    });
    selectedIndex = 0;
    pageController = PageController();
    timer = Timer.periodic(
        Duration(seconds: 5
        ), (Timer t) => checkForNewSharedLists());
  }
config() async {
  await Provider.of<ChatModel>(context, listen: false)
      .getChannalsHistory();

  await Provider.of<FollowingModel>(context, listen: false)
      .getfollowingList();
}


  checkForNewSharedLists() async {

    newMessege = await Provider.of<NewMessagesModel>(context,
            listen: false) //.newMessages
        .newMessagesList();
    setState(() {
      totalMessges = newMessege.totalNewMessages;
    //  print(totalMessges);
    });


  }

  @override
  void dispose() {
    timer?.cancel();
    //_disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // print('$selectedIndex');
 /*   return FutureBuilder<void>(builder: (context, asyncProduct) {
      if (asyncProduct.hasError || allDestinations == null) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Color(0xff336699),
              leading: null,
              automaticallyImplyLeading: false),
          backgroundColor: hexToColor('#F3F6FC'),
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff336699),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      } else {*/
        //setState(() {});
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff336699),
            leading: null,
            automaticallyImplyLeading: false,
            title: Align(
                alignment: Alignment.topLeft,
                child: Text("${Provider.of<UserModel>(context).user.name}")),
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
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 28,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: totalMessges == 0
                                ? Container()
                                : Container(
                                    height: 15,
                                    width: 19,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffe9a14e)),
                                    child: Center(
                                      child: Text(
                                        '$totalMessges',
                                        //  "    ${Provider.of<NewMessagesModel>(context).newMessages.totalNewMessages}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ), /**/
                                  ),
                          )
                          // : Container()
                        ],
                      ),
                      onPressed: () {
                        onItemTapped(1);
                      } // => Navigator.push(  context, MaterialPageRoute(builder: (context) => Profile()),
                      //  ).then((value) {
                      //   _getAppTitle();
                      // }),
                      ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()),
                              ),
                          child: CircleAvatar(
                            backgroundColor: Colors.black26,
                            foregroundColor: Colors.white,
                            child: Text(
                                '${getInitials(Provider.of<UserModel>(context).user.name)}'),
                          ))),
                ],
              ),
            ],
          ),
          backgroundColor: hexToColor('#F3F6FC'),
          body: FutureBuilder<void>(builder: (context, asyncProduct) {
            if (asyncProduct.hasError || allDestinations == null) {
              return CircularProgressIndicator(
                backgroundColor: Color(0xff336699),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              );
            }
            else {
              return PageView(
                controller: pageController,
                children: allDestinations.map<Widget>((RouteApp routeApp) {
                  return RootPage(route: routeApp);
                }).toList(),
                onPageChanged: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            }

          }), bottomNavigationBar: allDestinations==null? Container():BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.grey,
            elevation: 2,
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
              });
              onItemTapped(index);
            },
            items: allDestinations.map((RouteApp routeApp) {
              return BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(routeApp.icon),
                  title: routeApp.tabbartitle);
            }).toList(),
          ),
        );
      }
  //  });
//  }

  void _getAppTitle() {
    t3 = S.of(context).chat;
    t4 = S.of(context).task;
    setState(() {
      allDestinations = <RouteApp>[
        RouteApp(
          tabbartitle: Text("$t4"),
          icon: Icons.fact_check_outlined,
          page: TaskScreen(isAdmin: Provider.of<UserModel>(context ,listen: false).user.isAdmin),
        ),
        RouteApp(
          tabbartitle: Text("$t3"),
          icon: Icons.chat_bubble_outline,
          page: ChatList(
            name: 'Abrar',
          )
        )
      ];
    });
  }

  void getUserLangouge() {
    /*  if( Provider.of<UserModel>(context).userLangouge()=='en'){
                      Locale newLocale = Locale();
                       MyApp.setLocale(context, newLocale);    
  }*/
  }
}

String getInitials(String n) {
 // String name = n;
 // List<String> names = name.split(" ");
  //String initials = "";

  return n.toString().substring(0, 2);
}

void onItemTapped(int index) {
  pageController.animateToPage(index,
      duration: Duration(milliseconds: 200), curve: Curves.easeIn);
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

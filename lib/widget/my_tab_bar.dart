import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    Key key,
    @required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
     // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      height: 60,
      color: MyTheme.kPrimaryColorVariant,
      child: TabBar(
        controller: tabController,
        labelPadding: EdgeInsets.zero,

        //shape: UnderlineInputBorder(),
        indicatorColor: Colors.white,
        tabs: [
          Tab(

            child:  Stack(
              alignment: Alignment.center,

              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    //  Expanded(child: SizedBox(height: 1)),
                    //  Stack(
                    // children: [
                    Icon(Icons.chat, color: Colors.white,size: 23),

                    //
                    // Expanded(child: SizedBox(height: 1)),
                    ContentApp(
                      code: "chat",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //   Expanded(child: SizedBox(height: 1)),
                  ],
                ),
                Provider.of<NewMessagesModel>(context,listen: false).totalm>0?  Positioned(
                  top: 0.0,
                  left:12,
                  right: 0.0,
                  bottom: 27,
                  // padding: EdgeInsets.all(12),
                  //alignment: Alignment.center,
                  child: //Provider.of<NewMessagesModel>(context,listen: false).totalm == 0
                  //  ? Container()
                  // :
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffe9a14e)),
                    child: Center(
                      child: Text(
                        '${Provider.of<NewMessagesModel>(context,listen: false).totalm}',
                        //  "    ${Provider.of<NewMessagesModel>(context).newMessages.totalNewMessages}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // )
                  // ],
                ):Container(),
              ],
            ),
          //  icon:
          ),
          Tab(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.playlist_add_check_outlined, size: 25),

                    ContentApp(
                      code:"tasks",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              /*  Provider.of<NewMessagesModel>(context,listen: false).totalm>0?
                Positioned(
                  top: 1.0,
                  left:13,
                  right: 0.0,
                  bottom: 30,
                  // padding: EdgeInsets.all(12),
                  //alignment: Alignment.center,
                  child: //Provider.of<NewMessagesModel>(context,listen: false).totalm == 0
                  //  ? Container()
                  // :
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffe9a14e)),
                    child: Center(
                      child: Text(
                        '${Provider.of<NewMessagesModel>(context,listen: false).totalm}',
                        //  "    ${Provider.of<NewMessagesModel>(context).newMessages.totalNewMessages}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // )
                  // ],
                ):Container(),
             */ ],
            ),
          ),
        ],
      ),
    );
  }
}

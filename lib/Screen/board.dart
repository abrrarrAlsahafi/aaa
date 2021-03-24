import 'package:flutter/material.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/board.dart';
import 'package:management_app/widget/card_list.dart';
import 'package:management_app/widget/subtitel_wedget.dart';

import '../app_theme.dart';
import '../bottom_bar.dart';
import 'meetings.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

List<Board> meetings = List();

class _BoardScreenState extends State<BoardScreen> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    meetings = List.generate(4, (index) =>
        Board(
          name: 'Board $index',
          noOfTask: index,
          // 'AAA'
        ));

    _userDetails=meetings;
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name.contains(text) ||
          userDetail.name.toLowerCase().contains(text))
        _searchResult.add(userDetail);
    });
    setState(() {});
  }

  List<Board> _searchResult = [];
  List<Board> _userDetails = [];
  goToSecondScreen({project})async {
    var result = await Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => MeetingsScreen(),
      //new SecondScreen(context),
      fullscreenDialog: true,)
    );
    // setState(() {
    //project.noOfTask=result;
    //});
    AppModel().config(context);

    if(result) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("there is new task added to ${project.name}", style: MyTheme.Snacbartext,), duration: Duration(seconds: 4),backgroundColor: MyTheme.kUnreadChatBG,));
    }//return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      search
          ? ListTile(
        leading: new Icon(Icons.search),
        title: new TextField(
          controller: controller,
          decoration: new InputDecoration(
              hintText: 'Search', border: InputBorder.none),
          onChanged: onSearchTextChanged,
        ),
        trailing: new IconButton(
          icon: new Icon(Icons.close),
          onPressed: () {
            setState(() {
              search = false;
            });
            controller.clear();
            onSearchTextChanged('');
          },
        ),
      )
          : Container(),
      Expanded(
          child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 1.49,
              child: ListView.builder(
                  itemCount: _searchResult.length != 0 ||
                      controller.text.isNotEmpty
                      ? _searchResult.length
                      : _userDetails.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () =>  goToSecondScreen(project: _userDetails[index]),

                        child: CardListWidget(
                          countName: 'meetings',
                          countNumber: Text(
                              '${_userDetails[index].noOfTask == null
                                  ? 0
                                  : _userDetails[index].noOfTask}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                          titelCollunm: Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  _searchResult.length != 0 ||
                                      controller
                                          .text.isNotEmpty
                                      ? _searchResult[index].name
                                      : _userDetails[index].name,
                                  style: MyTheme.bodyText1,
                                ),
                                // dense: true,
                                SizedBox(height: 6),
                                Container(
                                    child: SubTitelWidjet(
                                        code: 'progectManeger',
                                        titl: ":  ${_searchResult.length != 0 ||
                                            controller.text.isNotEmpty
                                            ? _searchResult[index].managerName
                                            : _userDetails[index].managerName ==
                                            null ? '' : _userDetails[index]
                                            .managerName}")),
                                Container(
                                    child: SubTitelWidjet(
                                        code: 'editor',
                                        titl: ":  ${_searchResult.length != 0 ||
                                            controller.text.isNotEmpty
                                            ? _searchResult[index].managerName
                                            : _userDetails[index].managerName ==
                                            null ? '' : _userDetails[index]
                                            .managerName}")), Container(
                                    child: SubTitelWidjet(
                                        code: 'approval',
                                        titl: ":  ${_searchResult.length != 0 ||
                                            controller.text.isNotEmpty
                                            ? _searchResult[index].managerName
                                            : _userDetails[index].managerName ==
                                            null ? '' : _userDetails[index]
                                            .managerName}")),
                              ],
                            ),
                          ),
                        ));
                  })))
    ]);

  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:provider/provider.dart';

import '../bottom_bar.dart';

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

bool serchTask = false;

class _ProjectsState extends State<Projects> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getMyProjects();
  }

  Future<void> getMyProjects() async {
    await Provider.of<ProjectModel>(context, listen: false)
        .getUserProjects();
    Provider.of<ProjectModel>(context, listen: false)
        .projectManegerName(context);
    setState(() {});
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

  List<Project> _searchResult = [];
  List<Project> _userDetails = [];

  List<bool> fillStar = List.filled(22, false);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectModel>(
        builder: (context, myProject, _) {
      _userDetails = myProject.userProject;
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
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              )
            : Container(),
        Expanded(
            child: Container(
                height: MediaQuery.of(context).size.height / 1.49,
                child: ListView.builder(
                    itemCount: _searchResult.length != 0 || controller.text.isNotEmpty
                            ? _searchResult.length
                            : _userDetails.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                      onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => TaskScreen(
                      projectid: _userDetails[index].id)),
                      ),
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          child: ClipPath(

                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _searchResult.length != 0 ||
                                                    controller.text.isNotEmpty
                                                ? _searchResult[index].name
                                                : _userDetails[index].name,
                                            style: MyTheme.bodyText1,
                                          ),
                                          // dense: true,
                                          SizedBox(height: 6),
                                          Container(
                                              child: projectDitails(
                                                  code: 'progectManeger',
                                                  titl:
                                                      ":  ${_searchResult.length != 0 || controller.text.isNotEmpty ? _searchResult[index].projectManger : _userDetails[index].projectManger == null ? '' : _userDetails[index].projectManger}")),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        height: 70,
                                        width: 3,
                                        color: MyTheme.kUnreadChatBG),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            child: Center(
                                                child: Text(
                                                    '${_userDetails[index].taskCount == null ? 0 : _userDetails[index].taskCount}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    MyTheme.kPrimaryColorVariant),
                                          ),
                                          SizedBox(height: 6),
                                          ContentApp(
                                              code: 'tasks',
                                              style: MyTheme.heading2)
                                        ])
                                  ],
                                ),
                                height: 100,
                                //  decoration: BoxDecoration(  border: Border(right: BorderSide(color: Color(0xffe9a14e), width: 5))),
                              ),

                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3))),
                          )));
                    })))
      ]);
    });
  }

  projectDitails({code, titl}) {
    return Row(children: [
      ContentApp(
        code: code,
        style: MyTheme.bodyText2,
      ),
      Text(titl),
    ]);
  }
}

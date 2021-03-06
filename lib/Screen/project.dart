import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/main.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:provider/provider.dart';

import '../bottom_bar.dart';

class Projects extends StatefulWidget {

  @override
  _ProjectsState createState() => _ProjectsState();
}
bool serchTask=false;

class _ProjectsState extends State<Projects> {
  TextEditingController controller = new TextEditingController();
  List<Project> projList= List();
  @override
  void initState() {
    super.initState();
    getMyProjects();
// getUserDetails();
  }

  Future<void> getMyProjects() async {
    projList = await Provider.of<ProjectModel>(context, listen: false).getUserProjects();
    setState(() {});
    _userDetails=projList;
  }
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name.contains(text) || userDetail.name.toLowerCase().contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }


List<Project> _searchResult = [];
List<Project> _userDetails = [];

List<bool> fillStar=List.filled(22, false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        search? ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                controller: controller,

                decoration: new InputDecoration(
                    hintText: 'Search', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
              trailing: new IconButton(icon: new Icon(Icons.close), onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },),
            ):Container(),
        Expanded(
          child: new Container(
            height: MediaQuery.of(context).size.height/1.49,
            child:
            ListView.builder(
            itemCount:_searchResult.length != 0 || controller.text.isNotEmpty?_searchResult.length: _userDetails.length,
                      itemBuilder: (context, index) {
                        return Card(
                            margin: EdgeInsets.all(12),
                            elevation: 2,
                            child: ClipPath(
                              child: Container(
                                child: ListTile(
                                  onTap:() => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TaskScreen()),
                                  ),
                                  title:Text(_searchResult.length != 0 || controller.text.isNotEmpty?_searchResult[index].name:_userDetails[index].name),
                                 // subtitle: Text('Task: '),
                                 // leading: Icon(fillStar[index]?Icons.star:Icons.star_border, color: Color(0xffe9a14e),),
                                ),
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border(left: BorderSide(color: Color(0xffe9a14e), width: 5))),
                              ),
                              clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                            ),
                          );
                      })))]
    );
  }
}

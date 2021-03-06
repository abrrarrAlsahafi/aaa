import 'package:flutter/material.dart';
import 'package:management_app/services/emom_api.dart';

class Project {
  int id;
  String name;
  int managerId;

  Project({this.id, this.name, this.managerId});

  Project.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    name = json['name'];
    managerId = json['manager_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['manager_id'] = this.managerId;
    return data;
  }
}

class ProjectModel with ChangeNotifier {
  List<Project> userProject;
  ProjectModel(this.userProject);

  getUserProjects() async {
    userProject= await EmomApi().getMyProjects();
    return userProject;
  }

}
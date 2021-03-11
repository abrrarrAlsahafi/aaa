import 'package:flutter/material.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

class Project {
  int id;
  String name;
  int managerId;
  int taskCount;
  String projectManger;

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
    userProject.forEach((element) async {
      element.taskCount= await taskCount(element.id);
    });
    return userProject;
  }

  taskCount(proId) async {
   List tasks=await EmomApi().getUserTask(proId);
    return tasks.length;
  }

  nameOfProject(pid){
    String nameProject;//=List();
    userProject.forEach((element) {
    if(element.id==pid)  {
       nameProject=element.name;
      }
    });

    return nameProject;
  }
  projectManegerName(context){
    userProject.forEach((el)  {
       Provider.of<FollowingModel>(context,listen: false).followList.forEach((element) {
         if(el.managerId==element.id) el.projectManger=element.name;
        // if(el.managerId!=element.id) el.projectManger='';
       });
    });
  }
}
import 'package:flutter/material.dart';
import 'package:management_app/services/emom_api.dart';

class Task {
  int taskId;
  String taskName;
  String desc;
  String assignedTo;
  bool taskStage;
  String project;
  String createDate;
  String createBy;
  Task(
      {this.taskId,
        this.taskName,
        this.assignedTo,
        this.taskStage,
        this.project,
        this.createDate,
        this.createBy});

  Task.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskName = json['task_name'];
    assignedTo = json['assigned_to'];
    taskStage = json['task_stage']=="true"?true:false;
    project = json['project'];
    createDate = json['create_date'];
    createBy = json['create_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['task_name'] = this.taskName;
    data['assigned_to'] = this.assignedTo;
    data['task_stage'] = this.taskStage;
    data['project'] = this.project;
    data['create_date'] = this.createDate;
    data['create_by'] = this.createBy;
    return data;
  }
}

class TaskModel with ChangeNotifier {
  int uidAssigind;
   List<Task> userTasks;
  TaskModel(this.userTasks);
  getUserTasks(projectid) async {
    userTasks= await EmomApi().getUserTask(projectid);
    return userTasks;
  }

  Future<void> creatNewTask(createTask,projectid ) async {
    await EmomApi().createTask(taskName: createTask,projId: projectid);
      getUserTasks(projectid);

  }


  Future<void> logNot(mas, id) async{
   await EmomApi().logNote(mas, id);

  }


  Future<void> assginTaskTo({uid, tid}) async{
    await EmomApi().assignTask(uid:uid, tid: tid);

  }
}

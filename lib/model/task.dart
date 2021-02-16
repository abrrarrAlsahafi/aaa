import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/services/emom_api.dart';

class Task {
  String taskName;
  String assignedTo;
  String state;
  String project;
  String createDate;
  String createBy;

  Task(
      {this.taskName,
      this.assignedTo,
      this.state,
      this.project,
      this.createDate,
      this.createBy});

  Task.fromJson(Map<String, dynamic> json) {
    taskName = json['task_name'];
    assignedTo = json['assigned_to'];
    state = json['task_stage'];
    project = json['project'].toString();
    createDate = DateFormat('yMMMd').format(DateTime.parse(json['create_date']));
    createBy = json['create_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_name'] = this.taskName;
    data['assigned_to'] = this.assignedTo;
    data['task_stage'] = this.state;
    data['project'] = this.project;
    data['create_date'] = this.createDate;
    data['create_by'] = this.createBy;
    return data;
  }
}

class TaskModel with ChangeNotifier {
  final List<Task> userTasks;
  TaskModel(this.userTasks);
  getUserTasks() async {
    return await EmomApi().getUserTask();
  }
}

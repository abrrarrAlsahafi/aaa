import 'package:flutter/material.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

class Board {
  int id;
  String name;
  int managerId;
  String managerName;
  int noOfTask;

  Board({this.id, this.name, this.managerId, this.managerName, this.noOfTask});

  Board.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    managerId = json['manager_id'];
    managerName = json['manager_name'];
    noOfTask = json['no_of_task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['manager_id'] = this.managerId;
    data['manager_name'] = this.managerName;
    data['no_of_task'] = this.noOfTask;
    return data;
  }}

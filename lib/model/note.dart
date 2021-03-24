import 'package:management_app/model/folowing.dart';

class Note {
  int id;
  String name;
  String messege;

  Note({this.id, this.name,this.messege});

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    return data;
  }
}

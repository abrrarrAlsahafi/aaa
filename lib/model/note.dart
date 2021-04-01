
class Note {
  int taskId;
  String date;
  String user;
  String body;

  Note({this.taskId, this.date, this.user, this.body});

  Note.fromJson(Map<String, dynamic> json) {
    taskId = int.parse(json['task_id']);
    date = json['date'];
    user = json['user'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['date'] = this.date;
    data['user'] = this.user;
    data['body'] = this.body;
    return data;
  }
}

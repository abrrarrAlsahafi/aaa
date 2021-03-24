
class Meetings {
  int taskId;
  String taskName;
  String assignedTo;
  bool taskStage;
  String project;
  String createDate;
  String createBy;

  Meetings(
        {this.taskId,
        this.taskName,
        this.assignedTo,
        this.taskStage,
        this.project,
        this.createDate,
        this.createBy});

  Meetings.fromJson(Map<String, dynamic> json) {
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

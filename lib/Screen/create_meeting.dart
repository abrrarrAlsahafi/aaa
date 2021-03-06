import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/meettings.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/textfild_wedjet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CreateMeetings extends StatefulWidget {
  final isTask;

  const CreateMeetings({Key key, this.isTask}) : super(key: key);

  @override
  _CreateMeetingsState createState() => _CreateMeetingsState();
}

class _CreateMeetingsState extends State<CreateMeetings> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  MeettingsModel _meettingsModel=MeettingsModel();
  Task _task=Task();
  String _selectedItem;
  List<DropdownMenuItem<String>> _dropdownMenuItems;

  List<String>_dropdownItems=List();
  _CreateMeetingsState();
  void initState() {
    super.initState();
    //_dropdownItems=['Project X','Project B'];
   // _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
   // _selectedItem=_dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);

    return Scaffold(
        appBar: AppBar(title: Text('Add meeting')),
   backgroundColor: hexToColor('#F3F6FC'),
     body: Padding(
     padding: const EdgeInsets.all(12.0),
     child: Form(
       key: _formKey,
       autovalidate: _autoValidate,
       //autovalidateMode: AutovalidateMode.onUserInteraction,
       child: ListView(
         children: [
        widget.isTask? Container(
          decoration: BoxDecoration(
              color: Color(0xfff3f6fc), borderRadius: BorderRadius.circular(22)),
          padding: const EdgeInsets.all(9.0),
            child:  DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                isExpanded: true,
                value: _selectedItem,
                style: TextStyle(color:Colors.black38),
                isDense: true,

                //itemHeight:500,
                items: <String>[
                  'Android',
                  'IOS',
                  'Flutter',
                  'Node',
                  'Java',
                  'Python',
                  'PHP',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                dropdownColor: hexToColor('#F3F6FC'),
                hint: Text(
                  "Please choose a Project",
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onChanged: (String value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
              ),
            ):
           TextFormFieldWidget(
             textInputAction: TextInputAction.next,
             onEditingComplete: () => focus.nextFocus(),
             keyboardType: TextInputType.text,
           onChanged: (str) {
             setState(() {
               _autoValidate=false;
             });
           },

           validator: (value) {
             if (value.isEmpty) {
               return S.of(context).empty;
             }
           },
           onSave: (String value) {
            widget.isTask? _task.project=value: _meettingsModel.title = value;
           },
             hintText:widget.isTask? S.of(context).projectTitle: S.of(context).title,
       ),
           TextFormFieldWidget(
             keyboardType: TextInputType.text,
             textInputAction: TextInputAction.next,
             onEditingComplete: () => focus.nextFocus(),
             onChanged: (str) {
               setState(() {
                 _autoValidate=false;
               });
             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               widget.isTask?_task.taskName=value: _meettingsModel.location = value;
             },

             hintText: widget.isTask? S.of(context).projectTask:S.of(context).location, //: str,

             suffixIcon:widget.isTask?null: InkWell(
                 onTap: (){},
                   child: Icon(Icons.pin_drop_outlined)),
           ),
           TextFormFieldWidget(
               textInputAction: TextInputAction.next,
               onEditingComplete: () => focus.nextFocus(),
               onChanged: (str) {
                 setState(() {
                   _autoValidate=false;
                 });               },
             keyboardType: TextInputType.text,
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               widget.isTask? _task.desc=value:
               _meettingsModel.date = value;
             },
               hintText:widget.isTask?S.of(context).description:S.of(context).date,
               suffixIcon:widget.isTask?null:InkWell(
                   onTap: (){},
                   child:Icon(Icons.calendar_today))
           ),
           (Provider.of<UserModel>(context).user.isAdmin)?
           TextFormFieldWidget(
             textInputAction: TextInputAction.next,
             onEditingComplete: () => focus.nextFocus(),
             keyboardType: TextInputType.text,
             onChanged: (str) {
               setState(() {
                 _autoValidate=false;
               });             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               widget.isTask?_task.assignedTo=value:_meettingsModel.time = value;
             },
             hintText:widget.isTask?S.of(context).assignedTo:S.of(context).time,
           ):
           Container(
             padding: EdgeInsets.symmetric(horizontal: 9, vertical: 18),
             child:  Text('Assigned To\n ${(Provider.of<UserModel>(context).user.name)}', style: TextStyle(fontSize: 16,color: Colors.black),),
           ),
           widget.isTask? Container():TextFormFieldWidget(
             textInputAction: TextInputAction.next,
             onEditingComplete: () => focus.nextFocus(),
             keyboardType: TextInputType.text,
             onChanged: (str) {  setState(() {
               _autoValidate=false;
             }); },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) =>
               _meettingsModel.duration = value,
             hintText:S.of(context).duration,
           ),
           widget.isTask?Container():TextFormFieldWidget(
             textInputAction: TextInputAction.next,
             onEditingComplete: () => focus.nextFocus(),
             keyboardType: TextInputType.text,
             onChanged: (str) {
               setState(() {
                 _autoValidate=false;
               });
             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.members = value;
             },

             hintText:S.of(context).member, //: str,

            // prefixIcon: Icon(Icons.perm_identity),

             //  )
           ),
           widget.isTask?Container(): TextFormFieldWidget(
             textInputAction: TextInputAction.next,
             onEditingComplete: () => focus.nextFocus(),
             keyboardType: TextInputType.text,
             onChanged: (str) {
               setState(() {
                 _autoValidate=false;
               });
             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.agenda = value;
             },

             hintText:S.of(context).agenda, //: str,

            // prefixIcon: Icon(Icons.perm_identity),

             //  )
           ),
           widget.isTask?Container(): TextFormFieldWidget(
               textInputAction: TextInputAction.next,
               onEditingComplete: () => focus.nextFocus(),
             keyboardType: TextInputType.text,
             onChanged: (str) {
               setState(() {
                 _autoValidate=false;
               });
             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.agreement = value;
             },
             hintText:S.of(context).agreement,
               suffixIcon:InkWell(
                   onTap: (){},
                   child:Icon(Icons.add))
           ),

         ],
       ),
     ),
   ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color(0xffe9a14e),
        onPressed: () async {  if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if(widget.isTask){
            _task.state='New';
            print(_task.toString());
              taskList.add(_task);
              expandList.add(false);
             await Provider.of<TaskModel>(context,listen: false).creatNewTask(_task.taskName);//.userTasks.add(_task);
            Navigator.of(context).pop();
          }else{
            _meettingsModel.state='Schedule';
            print(_meettingsModel.toString());
            Navigator.of(context).pop();
          }
        }else {
          setState(() {
            _autoValidate = true;
          });
        }
        },
        child:Icon(
            Icons.playlist_add_rounded,
            color: Colors.white,
        ),
      ),
 );
  }
}


class CreateTask extends StatefulWidget {
  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  @override
  Widget build(BuildContext context) {

//    return FormWidget();
  }
}
/*

class FormWidget extends StatelessWidget {
  List minForm;
  List taskForm;
  final isTask;
   FormWidget({Key key, this.isTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    taskForm=[S.of(context).projectTitle, S.of(context).projectTask,S.of(context).description, S.of(context).assignedTo];
    minForm=isTask?taskForm:[S.of(context).title, S.of(context).location,S.of(context).date, S.of(context).time, S.of(context).duration, S.of(context).agenda, S.of(context).agreement, S.of(context).member];

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        color: hexToColor('#F3F6FC'),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: minForm.length,
            itemBuilder: (context, index){
          return TextFormFieldWidget(
            validator: (String s){
              return S.of(context).empty;
            },
            hintText:minForm[index],// 'Title',
            onChanged: (String s){},
            onSave: (String s){},
            prefixIcon: Container(),
            suffixIcon: InkWell(
               //onTap: _toggle,
               child:Icon(Icons.add)
            ),
          );

    ));
  }
}
*/


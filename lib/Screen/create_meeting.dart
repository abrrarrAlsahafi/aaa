import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/textfild_wedjet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  final item;
  final projectid;

  const CreateScreen({Key key, this.item, this.projectid}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Task _task = Task();
  String _selectedItem;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String projectName;
  List<String> _dropdownItems = [];

  void initState() {
    super.initState();
    projectName = Provider.of<ProjectModel>(context, listen: false)
        .nameOfProject(widget.projectid);
    //_dropdownItems=['Project X','Project B'];
    // _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    // _selectedItem=_dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items =[];
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
  bool isManeger=false;
  @override
  Widget build(BuildContext context) {
    if (widget.item.runtimeType == Task) return buildTaskForm();
  }

  buildTaskForm() {

    final focus = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
          title: ContentApp(
        code: 'addTask',
      )),
      backgroundColor: hexToColor('#F3F6FC'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              TextFormFieldWidget(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => focus.nextFocus(),
                  onChanged: (str) {
                    setState(() {
                      _autoValidate = false;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).empty;
                    }
                  },
                  onSave: (String value) {
                    _task.taskName = value;
                  },
                  hintText: S.of(context).projectTask,
                  //: str,

                  suffixIcon: null),
              TextFormFieldWidget(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => focus.nextFocus(),
                  onChanged: (str) {
                    setState(() {
                      _autoValidate = false;
                    });
                  },
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).empty;
                    }
                  },
                  onSave: (String value) {
                    // widget.isTask? _task.desc=value:
                    _task.description = value;
                  },
                  hintText: S.of(context).description,
                  suffixIcon: null),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffe9a14e),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

       int id=  await Provider.of<TaskModel>(context, listen: false)
                .creatNewTask(_task, widget.projectid );

            expandList.add(false);
          //  Navigator.pushReplacementNamed(context, "/task");
            Navigator.pop(context, true);
          //  setState(() {  addTask = result;  });
          } else {
            setState(() {
              _autoValidate = true;
            });
          }
        },
        child: Icon(
          Icons.playlist_add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  buildBord() {}

  buildMeeting() {

  }
}

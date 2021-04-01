import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/meettings.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/textfild_wedjet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateMeetings extends StatefulWidget {
  final isTask;
  final projectid;

  const CreateMeetings({Key key, this.isTask, this.projectid})
      : super(key: key);

  @override
  _CreateMeetingsState createState() => _CreateMeetingsState();
}

class _CreateMeetingsState extends State<CreateMeetings> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  MeettingsModel _meettingsModel = MeettingsModel();
  Task _task = Task();
  String _selectedItem;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String projectName;
  List<String> _dropdownItems = List();

  _CreateMeetingsState();

  void initState() {
    super.initState();
    projectName = Provider.of<ProjectModel>(context, listen: false)
        .nameOfProject(widget.projectid);
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
                  widget.isTask
                      ? _task.taskName = value
                      : _meettingsModel.location = value;
                },

                hintText: widget.isTask
                    ? S.of(context).projectTask
                    : S.of(context).location,
                //: str,

                suffixIcon: widget.isTask
                    ? null
                    : InkWell(
                        onTap: () {}, child: Icon(Icons.pin_drop_outlined)),
              ),
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
                    _meettingsModel.date = value;
                  },
                  hintText: widget.isTask
                      ? S.of(context).description
                      : S.of(context).date,
                  suffixIcon: widget.isTask
                      ? null
                      : InkWell(
                          onTap: () {}, child: Icon(Icons.calendar_today))),
              widget.isTask
                  ? Container()
                  : TextFormFieldWidget(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => focus.nextFocus(),
                      keyboardType: TextInputType.text,
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
                      onSave: (String value) =>
                          _meettingsModel.duration = value,
                      hintText: S.of(context).duration,
                    ),
              widget.isTask
                  ? Container()
                  : TextFormFieldWidget(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => focus.nextFocus(),
                      keyboardType: TextInputType.text,
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
                        _meettingsModel.members = value;
                      },

                      hintText: S.of(context).member, //: str,

                      // prefixIcon: Icon(Icons.perm_identity),

                      //  )
                    ),
              widget.isTask
                  ? Container()
                  : TextFormFieldWidget(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => focus.nextFocus(),
                      keyboardType: TextInputType.text,
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
                        _meettingsModel.agenda = value;
                      },

                      hintText: S.of(context).agenda, //: str,

                      // prefixIcon: Icon(Icons.perm_identity),

                      //  )
                    ),
              widget.isTask
                  ? Container()
                  : TextFormFieldWidget(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => focus.nextFocus(),
                      keyboardType: TextInputType.text,
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
                        _meettingsModel.agreement = value;
                      },
                      hintText: S.of(context).agreement,
                      suffixIcon:
                          InkWell(onTap: () {}, child: Icon(Icons.add))),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffe9a14e),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            if (widget.isTask) {
              await Provider.of<TaskModel>(context, listen: false)
                  .creatNewTask(_task, widget.projectid);
              Provider.of<TaskModel>(context, listen: false)
                  .userTasks
                  .add(_task);
              //await Provider.of<TaskModel>(context,listen: false).getUserTasks(widget.projectid);

              expandList.add(false);
              Navigator.pop(context, true);
            } else {
              _meettingsModel.state = 'Schedule';
              // print(_meettingsModel.toString());
              Navigator.of(context).pop();
            }
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
}

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
 // MeettingsModel _meettingsModel = MeettingsModel();
  Task _task = Task();
  String _selectedItem;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String projectName;
  List<String> _dropdownItems = List();

  void initState() {
    super.initState();
    projectName = Provider.of<ProjectModel>(context, listen: false)
        .nameOfProject(widget.projectid);
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
             /* isManeger? TextFormFieldWidget(
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
                    _task.assignedTo = value;
                  },
                  hintText: S.of(context).assignedTo,
                  suffixIcon: null):
              Container(),*/
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
            Provider.of<TaskModel>(context, listen: false).userTasks.add(_task);
            //await Provider.of<TaskModel>(context,listen: false).getUserTasks(widget.projectid);

            expandList.add(false);
            Navigator.pop(context, true);
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
    /*

    widget.isTask? Container():TextFormFieldWidget(
    textInputAction: TextInputAction.next,
    onEditingComplete: () => focus.nextFocus(),
    keyboardType: TextInputType.text,
    onChanged: (str) { setState(() {
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
     */
  }
}

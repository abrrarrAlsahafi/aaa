import 'package:management_app/common/constant.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/meettings.dart';
import 'package:management_app/widget/buttom_widget.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/textfild_wedjet.dart';
import 'package:flutter/material.dart';


class CreateMeetings extends StatefulWidget {
  @override
  _CreateMeetingsState createState() => _CreateMeetingsState();
}

class _CreateMeetingsState extends State<CreateMeetings> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  MeettingsModel _meettingsModel=MeettingsModel();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('Add meeting')),
   backgroundColor: hexToColor('#F3F6FC'),
   body: Padding(
     padding: const EdgeInsets.all(12.0),
     child: Form(
       key: _formKey,
      autovalidate: _autoValidate,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
       child: ListView(
         children: [
           TextFormFieldWidget(
           keyboardType: TextInputType.text,

           onChanged: (str) {

           },
           validator: (value) {
             if (value.isEmpty) {
               return S.of(context).empty;
             }
           },
           onSave: (String value) {
             _meettingsModel.title = value;
           },

             hintText:S.of(context).title, //: str,

           //  prefixIcon: Icon(Icons.perm_identity),

         //  )
       ),
           TextFormFieldWidget(
             keyboardType: TextInputType.text,
             onChanged: (str) {

             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.location = value;
             },

             hintText:S.of(context).location, //: str,

             suffixIcon: InkWell(

                 onTap: (){},
                   child:Icon(Icons.pin_drop_outlined)),


             //  )
           ),
           TextFormFieldWidget(
             keyboardType: TextInputType.text,
             onChanged: (str) {

             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.date = value;
             },

             hintText:S.of(context).date, //: str,

               suffixIcon:InkWell(
                   onTap: (){},
                   child:Icon(Icons.calendar_today))

             //  )
           ),
           TextFormFieldWidget(
             keyboardType: TextInputType.text,
             onChanged: (str) {

             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.time = value;
             },

             hintText:S.of(context).time, //: str,

            // prefixIcon: Icon(Icons.perm_identity),

             //  )
           ),
           TextFormFieldWidget(
             keyboardType: TextInputType.text,
             onChanged: (str) {

             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.duration = value;
             },

             hintText:S.of(context).duration, //: str,

            // prefixIcon: Icon(Icons.perm_identity),

             //  )
           ),
           TextFormFieldWidget(
             keyboardType: TextInputType.text,
             onChanged: (str) {

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
           ),       TextFormFieldWidget(
             keyboardType: TextInputType.text,
             onChanged: (str) {

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
           ),       TextFormFieldWidget(
             keyboardType: TextInputType.text,
             onChanged: (str) {

             },
             validator: (value) {
               if (value.isEmpty) {
                 return S.of(context).empty;
               }
             },
             onSave: (String value) {
               _meettingsModel.agreement = value;
             },

             hintText:S.of(context).agreement, //: str,

               suffixIcon:InkWell(
                   onTap: (){},
                   child:Icon(Icons.add))

             //  )
           ),

           ButtonWidget(
             onPressed:(){

    if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
    _meettingsModel.state='Schedule';
  //  mList.add(_meettingsModel);
    setState(() {

    });
Navigator.of(context).pop();
    }else {
      setState(() {
        _autoValidate = true;
        // error = '';
      });
    }
             },
             child: ContentApp(
               code: 'addmeeting',
               style:  TextStyle(
                   fontSize: 18, fontWeight: FontWeight.bold)),

             ),


         ],
       ),
     ),
   )
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
    return FormWidget();
  }
}


class FormWidget extends StatelessWidget {
  final List<FormClass>formlist;

   FormWidget({Key key, this.formlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: hexToColor('#F3F6FC'),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index){
          return TextFormFieldWidget(
            validator: (String s){},
            hintText: 'Title',
            onChanged: (String s){},
            onSave: (String s){},
          //  prefixIcon: Container(),
            suffixIcon: InkWell(
               //onTap: _toggle,
               child:Icon(Icons.add)
            ),
          );
        }),
      ),
    );
  }
}


class FormClass{
  final onChanged;
  final validator;
  final hintText;
  final onSave;
  final prefixIcon;
  FormClass({Key key, this.onChanged, this.validator, this.hintText, this.onSave, this.prefixIcon});

}
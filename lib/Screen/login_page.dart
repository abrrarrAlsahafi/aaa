import 'dart:async';

import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bottom_bar.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isoffline = false;
  bool _isSelected = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Timer timer;
  User model = User();
  String error = '';
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    timer =Timer.periodic(Duration(seconds: 2), (Timer t) {
    setState(() {
      isoffline=false;
    });
    });
    super.initState();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff3f6fc),
        body: ListView(
            children: <Widget>[
          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                isoffline? Container(
                    child:errmsg()
                  //to show internet connection message on isoffline = true.
                ):Container(),
                Padding(
                  padding:EdgeInsets.all(MediaQuery.of(context).size.width/6.5),
                  child: Stack(
                      alignment: Alignment.topCenter,
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/bgimgs.png'),
                              fit: BoxFit.fitWidth,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.03),
                                  BlendMode.dstIn),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              alignment: Alignment.center,
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      const AssetImage('assets/images/logo.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
                        Positioned(
                          top: 190,
                          child: Align(
                              //heightFactor: 4.0,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 352.0,
                                  height: 71.0,
                                  child: Text(
                                    'Board Meetings & Communication',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xff336699),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )),
                        ),

                      ]),
                ),
                //SizedBox(height: MediaQuery.of(context).size.width/5.5),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: getEmail().toString(),
                      // autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (str) {
                        setState(() {
                          error = '';
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return S.of(context).validationusername;
                       else return null;
                      },
                      onSaved: (String value) {
                        model.username = value;
                      },
                      cursorColor: const Color(0xff336699),
                      // onChanged: ()=>,
                      decoration: InputDecoration(
                        // labelText: 'Email',
                        labelStyle: TextStyle(
                          color: const Color(0xff336699),
                          fontSize: 12,
                        ),
                        hintText: //str == null ?
                            S.of(context).username, //: str,
                        hintStyle: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ),

                        prefixIcon: Icon(Icons.perm_identity),
                      )
                      //  )
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    cursorColor: const Color(0xff336699),
                    decoration: InputDecoration(
                      hintText: S.of(context).password,
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: InkWell(
                        onTap: _toggle,
                        child: Icon(Icons.remove_red_eye),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) return S.of(context).validationpassword;
                      else return null;
                    },
                    onSaved: (String value) {
                      model.pass = value;
                    },
                  ),
                ), //),
                Text("$error",
                    style: TextStyle(
                      color: Colors.red,
                    )),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: InkWell(
                          child: ContentApp(
                            code: 'forgotpassword',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xff336699),
                            ),
                            // textAlign: TextAlign.left,
                          ),
                          onTap: () {},
                        ))),
                Row(
                  children: <Widget>[
                    Checkbox(
                      activeColor: Color(0xffe9a14e),
                      value: _isSelected,
                      onChanged: (bool newValue) {
                        setState(() {
                          _isSelected = newValue;
                          saveEmail(_isSelected, model.username);
                        });
                      },
                    ),
                    Expanded(
                        child: ContentApp(
                      code: 'rememberme',
                      style: TextStyle(
                        //fontSize: 14,
                        color: Colors.black45,
                      ),
                      // textAlign: TextAlign.left,
                    )),
                  ],
                ),
                Container(
                  height: 80.0,
                  width: 500.0,
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Color(0xff336699),
                    onPressed: () => validateInput(),
                    child: ContentApp(
                        code: 'bottonlogin',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold,)),
                  ),
                )
              ],
            ),
          )
        ]));
  }

  Future<void> validateInput() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      dynamic result =
          await EmomApi().login(username: model.username, password: model.pass);
      if (result.runtimeType != User) {
        if(result.toString().contains('Failed host')){
          setState(() {
            isoffline=true;
          });
          //errmsg();
          //print('network connct');
        }else{
        setState(() {
          error = S
              .of(context)
              .loginValidatin; //'The password or username is incorrect';
        });}
      } else {
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        userModel.saveUser(result);
        setState(() {
          isLoggedIn = true;
        });
        Navigator.push(context, new MaterialPageRoute(builder: (context) => BottomBar()));
        if (_isSelected) {
          // saveEmail(model.username);
        }
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }



  Widget errmsg(){
    //error message widget.

      //if error is true then show error message box
      return Container(
      padding: EdgeInsets.all(10.00),
      //  margin: EdgeInsets.only(bottom: 10.00),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

          Text("No Internet Connection Available", style: TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );


  }

  Future<void> saveEmail(bool saved, email) async {
    if(email!=null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email',email);
    }
  }
 String getEmail() {
    //if(email!=null){
     /// SharedPreferences prefs = await SharedPreferences.getInstance();
   //String email=prefs.getString('email');
   // }
    return email==null?'':email;
  }
}
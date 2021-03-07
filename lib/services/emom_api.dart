import 'dart:convert' as convert;
import 'dart:convert';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class EmomApi implements BaseServices {
  var _client= "http://demo.ewady.com/";
   var _db='ewady_production';//listMember
  connect() async {
   // _client = OdooClient('');
  //  _client.connect().then((version) {
 //     print("Connected $version");
  //  });
  }

  _setHeaders(id) => {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Cookie': 'frontend_lang=en_US; session_id=$id'
      };

  String headers;

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers = (index == -1) ? rawCookie : rawCookie.substring(11, index);
    }
  }

  @override
  Future<User> createUser({
    id,
    firstName,
    lastName,
    email,
    password,
    // passwordconfirmation,
  }) async {
    try {
      // print("create user .. ${firstName}");
      var response = await http.post(
        '',
        body: convert.jsonEncode({
          "First_Name": firstName,
          "Last_Name": lastName,
          "Email": email,
          "password": password,
          "password_confirmation": password
        }),
        //  headers: _setHeaders(id)
      );
      if (response.statusCode == 200) {
        // var body = convert.jsonDecode(response.body);
        // print('code response : ${response.statusCode}, $body');
        return await this.login(username: email, password: password);
      } else {
        final body = convert.jsonDecode(response.body);
        List error = body["messages"];
        if (error != null && error.isNotEmpty) {
          throw Exception(error[0]);
        } else {
          throw Exception("Can not create user");
        }
      }
    } catch (err) {
      print('$err');
      rethrow;
    }
  }


  @override
  Future<void> logOut({username, password}) async {
    try {
      var response = await http.post(
        '${_client}/session/destroy',
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db, "login": username, "password": password}
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
      );
      print('code logout response : ${response.statusCode}, $response');

    } catch (err) {
      print('$err');
      rethrow;
    }
  }

  @override
  Future<User> getUserInfor(cookie) async {
    var res = await http
        .get(_client, headers: {'Content-Type': 'application/json' + cookie});
    // print('user info: ${res.body}');
    return null; //User.fromOpencartJson(convert.jsonDecode(res.body), cookie);
  }

  @override
  Future<dynamic> login({username, password}) async {
    connect();
    print(_client);
    try {
      var response = await http.post(
      "${_client}web/session/authenticate",
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db, "login": username, "password": password}
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }); //_setHeaders());
        updateCookie(response);
      final body = convert.jsonDecode(response.body);
      if (!response.body.contains("error")) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('session_id', headers);
        localStorage.setInt('uid', body['result']['uid']);
        localStorage?.setBool("isLoggedIn", true);

        return User.fromJson(body['result']);
      } else {
        final body = convert.jsonDecode(response.body);
        return Exception(body["message"] =
                body['error']['data']['message'] //: "Can not get token"
            );
      } /**/ // Network is unreachable,
    } catch (err) {
      // print("network error $err");
       return err;
     // rethrow;
    }
  }
  @override
  Future<int> createNewChannal(
      String channelName, List memberIds, isChat, isPrivate) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post(
        "${_client}chat/add_new_channel",
        headers: _setHeaders(id),
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "channel_name": channelName,
            "member_ids": memberIds,
            "channel_type": isChat ? "chat" : "channel",
            "public": isPrivate ? "private" : "public"
          }
        }),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        String strNum= "${body['result'].toString()}";
        final iReg = RegExp(r'(\d+)');
        String s =iReg.allMatches(strNum).map((m) => m.group(0)).join(' ');
        var newid=int.parse(s.substring(4));
        print(iReg.allMatches(strNum).map((m) => m.group(0)).join(' '));
        return newid;
      }
 // String strNum= "{\"code\": 200, \"message\": \"Channel Created\", \"channel_id\": 32}";


    // final iReg = RegExp(r'(\d+)');

    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<bool> postNewMessage(int channalid, String massege) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post(
        "${_client}chat/post_new_messages",
        headers: _setHeaders(id),
        body: convert.jsonEncode(
          {
            "jsonrpc": "2.0",
            "params": {"message": "$massege", "channel_id": channalid}
          },
        ),
      );
     // print("post massege  ${response.body}");
      if (response.statusCode == 200) {
        return response.body.contains('messages Created');
      } else{
       // print("post massege  ${response.body}");
        return false;
      }
    } catch (e) {
      rethrow;
    }
  } //User.fro

  @override
  Future<List<Chat>> chatHistory() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}chat/get_user_channels/",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Chat> list = [];
      // var respData = json.decode(response.body);

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Chat.fromJson(item));
        }
        //  saveToLocal(list, 'chat_list');

      }

      return list;
    } catch (e) {
      rethrow;
    }
  } //User.fromOpencartJson(convert.jsonDecode(res.body), cookie);

  @override
  Future<List<Task>> getUserTask(projectId) async {
     // var params ={"project_id" : "$projectId".toString() };//{"jsonrpc" : "2.0" ,  "params" : {"project_id" : "$projectId".toString() }};
    //  Uri uri=Uri.parse("${_client}project/get_task_details");
     // final newURI = uri.replace(queryParameters: params);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.post(
          "${_client}project/get_task_details",
      body:convert.jsonEncode({
        "jsonrpc": "2.0",
        "params": {"project_id" : "$projectId"}
        },
      )
      , headers: _setHeaders(id));
             List<Task> list = [];
      //var finalData = str.(/\\/g, "");
      //if (response.statusCode == 200)
      //  print("${response.body.replaceAll('"\"', "")}");
/*
      // var respData = json.decode(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Task.fromJson(item));
        }
      }*/
     // print('');
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Folowing>> getfollowingList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}chat/get_user_list/",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Folowing> list = [];

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Folowing.fromJson(item));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Massege>> getMassegesContent(var masgId) async {
    //print(masgId);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}chat/get_chanel_messages?channel_id=$masgId",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Massege> list = [];
      // var respData = json.decode(response.body);0

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Massege.fromJson(item));
        }
       // if(masgId==33)  print("chanals  list ${list}");

      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  saveToLocal(List list, str) async {
    SharedPreferences prf = await SharedPreferences.getInstance();
    await prf.setString(str, Chat.encode(list));
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.getString(str);
  }

  @override
  Future<NewMessages> newMasseges() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}chat/get_new_messages",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
         NewMessages newMessages;
      if (response.statusCode == 200) {
        newMessages = NewMessages.fromJson(json.decode(response.body)['data']);
        //   }
      }
      return newMessages;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> createTask({taskName}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post(
        "${_client}project/create_task",
        headers: _setHeaders(id),
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "task_name":"$taskName"
          }
        }),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        String strNum= "${body['result'].toString()}";
        final iReg = RegExp(r'(\d+)');
        String s =iReg.allMatches(strNum).map((m) => m.group(0)).join(' ');
        var newid=int.parse(s.substring(4));
        print(iReg.allMatches(strNum).map((m) => m.group(0)).join(' '));
        return newid;
      }
    } catch (e) {
      rethrow;
    }

  }

  Future<List<Project>> getMyProjects() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}project/get_my_projects",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
   List<Project> myProject=List();
     // final body = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          myProject.add(Project.fromJson(item));
        }
      }
      return myProject;
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> addMembers(channelId, memberId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    var res = await http
        .post("${_client}chat/add_members",
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "member_ids" : memberId ,
            "channel_id" : channelId
          }
        }),
        headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
  }

  @override
  Future<void> logNote(message, taskId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    var res = await http
        .post("${_client}project/log_note",
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "message" : message ,
            "task_id" : taskId
          }
        }),
        headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});

  }

  @override
  Future sginOut({username, password}) {
    // TODO: implement sginOut
    throw UnimplementedError();
  }
}

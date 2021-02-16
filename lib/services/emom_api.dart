import 'dart:convert' as convert;
import 'dart:convert';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
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
        'Accept': 'application/json',
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
     // print("login method  ${response.body}");
      if (!response.body.contains("error")) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('session_id', headers);
        localStorage.setInt('uid', body['result']['uid']);
        localStorage?.setBool("isLoggedIn", true);
     //   print(body['result']['user_context']);

        return User.fromJson(body['result']);
      } else {
        final body = convert.jsonDecode(response.body);
        //print("body... ${body['error']['data']['message']}");
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
  Future<void> createNewChannal(
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
      final body = json.decode(response.body); //.jsonDecode();
      print("chat create ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
      }
      return body['result'];
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
  Future<List<Task>> getUserTask() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response =
          await http.get("${_client}project/get_task_details",
              //'https://it.gulfrange.com/project/get_task_details',
              headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Task> list = [];
      // var respData = json.decode(response.body);
      // print(response.body);
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Task.fromJson(item));
        }
      }
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
//print(response.body);
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Massege.fromJson(item));
        //  print("chanals  list ${item}");
        }
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
      //print("chat list ${response.body}");
     // var respData = json.decode(response.body);
     // print("chat list ${respData.runtimeType}");
      if (response.statusCode == 200) {
        //  for (var item in convert.jsonDecode(response.body)["data"]) {
        newMessages = NewMessages.fromJson(json.decode(response.body)['data']);
        //   }
      }
      //   print("chat list ${newMessages.totalNewMessages}");
      return newMessages;
    } catch (e) {
      rethrow;
    }
  }
}

class Data {
  String code;
  String message;
  String channelId;

  Data({this.code, this.message, this.channelId});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    channelId = json['channel_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['channel_id'] = this.channelId;
    return data;
  }
}

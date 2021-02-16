import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';

import 'emom_api.dart';

abstract class BaseServices {
  Future<User> createUser({
    id,
    firstName,
    lastName,
    email,
    password,
  });

  Future<dynamic> login({username, password});
  Future<dynamic> chatHistory();
  Future<List<Folowing>> getfollowingList();
  Future<List<Task>> getUserTask();
}

class Services implements BaseServices {
  BaseServices serviceApi = EmomApi();
  //Stream<Locale> get localLangouge {
   // var localeSubject = BehaviorSubject<Locale>();

    //  (localeSubject.sink )
    //    ? localeSubject.sink.add(Locale('ar', 'AR'))
    //     : localeSubject.sink.add(Locale('en', 'US'));

    //  return localeSubject.stream.distinct();
//  }

  Stream<User> get user {
    //return _auth.onAuthStateChanged.map(_userFormFirebaceUser);
  }
  @override
  Future<User> createUser({
    id,
    firstName,
    lastName,
    email,
    password,
  }) {
    throw serviceApi.createUser();
  }

  @override
  Future<dynamic> login({username, password}) {
    throw serviceApi.login();
  }

  @override
  Future<dynamic> chatHistory() {
    throw serviceApi.chatHistory();
  }

  @override
  Future<List<Task>> getUserTask() {
    throw serviceApi.getUserTask();
  }

  @override
  Future<List<Folowing>> getfollowingList() {
    // TODO: implement getfollowingList
    throw serviceApi.getfollowingList();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

import 'folowing.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Chat {
  int id;
  String name;
  String image;
  String lastMessage;
  String lastDate;
  bool newMessage;
  List members;
  int adminId;
  bool isChat;

  Chat(
      {this.id,
      this.name,
      this.image,
      this.lastMessage,
      this.lastDate,
      this.newMessage,
      this.members,
      this.adminId,
      this.isChat});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['channel_name'];
    image = json['image'];
    lastMessage = json['last_message'];
    lastDate = json['last_date'];
    members = json['member_ids'];
    adminId = json['admin_id'];
    isChat = json['is_chat'];
  }

  static Map<String, dynamic> toJson(Chat chat) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = chat.id;
    data['channel_name'] = chat.name;
    data['image'] = chat.image;
    data['last_message'] = chat.lastMessage;
    data['last_date'] = chat.lastDate;
    data['member_ids'] = chat.members;
    data['admin_id'] = chat.adminId;
    data['is_chat'] = chat.isChat;
    return data;
  }

  static String encode(List<Chat> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => Chat.toJson(music))
            .toList(),
      );

  static List<Chat> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Chat>((item) => Chat.fromJson(item))
          .toList();
}

class ChatModel with ChangeNotifier {
  List<Chat> chatsList;

  ChatModel();
  getChannalsHistory() async {
    chatsList = await EmomApi().chatHistory();
    notifyListeners();
  }

  getChatInfo(channalId, context) {
    print("channalId $channalId");
    List<Folowing> channalMember = List();
    List ids;
    List<Folowing> user =
        Provider.of<FollowingModel>(context, listen: false).followList;

    //Provider.of<ChatModel>(context).chatsList;
    for (int i = 0;
        i < Provider.of<ChatModel>(context, listen: false).chatsList.length;
        i++) {
      if (Provider.of<ChatModel>(context, listen: false).chatsList[i].id ==
          channalId) {
        ids =
            Provider.of<ChatModel>(context, listen: false).chatsList[i].members;
      }
    }
    print("ids $ids");
    for (int i = 0; i < user.length && i < ids.length; i++) {
      if (user[i].id == ids[i]) channalMember.add(user[i]);
    }
    //print("ccc ${channalMember}");
    return channalMember;
  }

  addNewChat(chat) => chatsList.add(chat);
  createChannal(chat, isCaht, isPrivate) async {
    // chatsList.removeLast();
    await EmomApi().createNewChannal(chat.name, chat.members, isCaht,isPrivate);

    await getChannalsHistory();
  }

  chatMassege(i, newmassege) => chatsList[i].lastMessage = newmassege;
}

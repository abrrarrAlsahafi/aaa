import 'package:flutter/material.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:management_app/Screen/chat/chat_list.dart';
import 'package:provider/provider.dart';

import '../member_list.dart';

class ChatInfo extends StatefulWidget {
  final channalId;
  final sender;
  final groupchat;

  ChatInfo({Key key, this.sender, this.groupchat, this.channalId})
      : super(key: key);

  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  List<Folowing> members = List();
  List<ListItem> items = List();
  Folowing admin = Folowing();
  @override
  void initState() {
    super.initState();
    if (widget.channalId == null) {
      //widget.sender=
    //  members=List.generate(3, (index) => Folowing(image: 'False',id: 12,name: 'abrar', isAddmin: false));
      print("is chat ${widget.sender.isChat}");
    } else {
      buildItem(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6fc),
      body: Column(
        children: [
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width,
            color: hexToColor('#336699'),
            child: Column(
              children: [
                SizedBox(height: 22),
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                Expanded(
                    child: SizedBox(
                  height: 12,
                )),
                Container(
                  height: 100,
                  width: 100,
                  //borderRadius: BorderRadius.circular(33.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: MembertImage(item: widget.sender)),
                ),
                SizedBox(height: 12),
                // Image.memory()
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    widget.sender.name.toString(),
                    style: TextStyle(fontSize: 33, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          widget.sender.isChat
              ? Container()
              : MembersList(member: members, admin: widget.sender.adminId)
        ],
      ),
      floatingActionButton:widget.groupchat? FlatActionButtonWidget(
            onPressed:(){
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ListUsers()));
            },
            icon: Icons.person_add_alt_1_outlined
      ):Container(),
    );
  }

  buildItem(context) {
    var memberss =
        widget.sender.members != null ? widget.sender.members : widget.sender;
    members = Provider.of<FollowingModel>(context, listen: false)
        .getMembersChat(memberss, widget.sender.adminId);

  }
}

import 'dart:async';

import 'package:management_app/Screen/chat/chat_info.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/bottom_bar.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_message_tile.dart';

class MyDirectChatDetailPage extends StatefulWidget {
  var mid;
  final member;
  final title;
  final chatDetils; //chat object
  final currentUser;
  final newChat;
  final isChat;

  // final ischatGroup;
  final isPrivetGroup;

  MyDirectChatDetailPage({
    //this.ischatGroup,
    this.isPrivetGroup,
    this.title,
    this.newChat,
    this.mid,
    this.chatDetils,
    this.currentUser,
    this.member,
    this.isChat,
  });

  @override
  _MyDirectChatDetailPageState createState() => _MyDirectChatDetailPageState();
}

bool addnewChat = false;

class _MyDirectChatDetailPageState extends State<MyDirectChatDetailPage> {
  final double minValue = 8.0;
  final double iconSize = 28.0;
  bool _disposed = false;
  List<Massege> myMessages = List();
  FocusNode _focusNode;
  TextEditingController _txtController = TextEditingController();
  bool isCurrentUserTyping = false;
  ScrollController _scrollController;

  Timer timer;
  Chat newChatRom;
  String message = '';
  List m = List();
  int uid;

  checkMember() {
    uid = Provider.of<UserModel>(context, listen: false).user.uid;
    if (widget.isChat == false) {
      for (var item in widget.member) {
        m.add(item.id);
      }
    } else {
      m.add(widget.member.id);
      m.add(uid);
    }
    return m;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.newChat == false && (widget.isChat)) {
      getMasseges();
    }
    if (widget.newChat && widget.isChat == false) {
      createGroup();
      // setState(() {  addnewChat = true;});
    } else {
      //myMessages = Provider.of<ChatModel>(context, listen: false).chatMasseges( widget.mid);
      getMasseges();
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        //  if (Provider.of<NewMessagesModel>(context, listen: false).totalm > 0){
        if (Provider.of<NewMessagesModel>(context, listen: false)
                .newMessages
                .totalNewMessages >
            0) {
          this.newDirctMassege();
          // setState(() {});
        }
      });
    }
  }

/*
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
*/
  @override
  void dispose() {
    timer?.cancel();

    _disposed = true;
    super.dispose();
  }

  getMasseges() {
    if (Provider.of<NewMessagesModel>(context, listen: false)
            .newMessages
            .totalNewMessages >
        0) {
      newDirctMassege();
    } else {
      myMessages = Provider.of<ChatModel>(context, listen: false)
          .chatMasseges(widget.mid);
      //Provider.of<ChatModel>(context).is
    }
  }

  /*checkForNewsMs() async {
    await Provider.of<NewMessagesModel>(context,
        listen: false) //.newMessages
        .newMessagesList();

    if (Provider.of<NewMessagesModel>(context, listen: false)
        .totalm > 0) {
      newDirctMassege();
    }
  }*/

  newDirctMassege() async {
    myMessages = await Provider.of<MassegesContent>(context, listen: false)
        .getMassegesContext(widget.mid);
    setState(() {});
  }

  var id;

  createGroup() async {
    newChatRom = Chat(
        members: checkMember(),
        //widget.member.id,
        name: widget.title,
        // widget.member.last.name + ',',
        image: 'False',
        //widget.member.last.image,
        isChat: widget.isChat,
        adminId: uid,
        lastMessage: '');
    // print( "new channal ${newChatRom.adminId}, ${newChatRom.name} ${newChatRom.members}");
    id = await Provider.of<ChatModel>(context, listen: false)
        .createChannal(newChatRom, widget.isChat, widget.isPrivetGroup);
    setState(() {
      widget.mid = id;
    });
//print(widget.mid);
    // myMessages= await Provider.of<ChatModel>(context).chatMasseges(id);
    //await
    message = S.of(context).welcomems;
    _sendMessage();
    // await Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
    // print(i);
    setState(() {});
  }

  createChat() async {
    newChatRom = Chat(
      members: checkMember(),
      //widget.member.id,
      name: widget.member.name,
      image: widget.member.image,
      //lastDate: DateTime.now().toString(),
      isChat: true,
      adminId: uid,
      //  lastMessage: ''
    );

    widget.mid = await Provider.of<ChatModel>(context, listen: false)
        .createChannal(newChatRom, widget.isChat, widget.isPrivetGroup);
    //await Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
    setState(() {});
  }

  void onTextFieldTapped() {}

  void _onMessageChanged(String value) {
    setState(() {
      message = value;
      if (value.trim().isEmpty) {
        isCurrentUserTyping = false;
        return;
      } else {
        isCurrentUserTyping = true;
      }
    });
  }

  bool newmasseg = false;

  Future<void> _sendMessage() async {
    if (message.isNotEmpty) {
      if (widget.mid == null && widget.isChat) {
        createChat();
        myMessages.insert(0, (Massege(message, DateTime.now(), 'Me', true)));
        newmasseg = await EmomApi().postNewMessage(widget.mid, message);
      } else {
        myMessages.insert(0, (Massege(message, DateTime.now(), 'Me', true)));
        print(myMessages.first);
        newmasseg = await EmomApi().postNewMessage(widget.mid, message);
        // getMasseges();
      }

      // Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
      //myMessages.insert( 0, (Massege(message,DateTime.now()), 'Me',true)));
      // myMessages = Provider.of<MassegesContent>(context).l
      setState(() {
        // Provider.of<ChatModel>(context).chatsList.add(newChatRom);
        message = '';
        _txtController.text = '';
      });
      _scrollToLast();
    }
  }

  void _scrollToLast() {
    //  print('object');
    _scrollController.animateTo(
      0.3,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildBottomSection() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 52,
            margin: EdgeInsets.all(minValue),
            padding: EdgeInsets.symmetric(horizontal: minValue),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(minValue * 3)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    // FocusNode:ـ focusNode,
                    //autofocus: true,
                    keyboardType: TextInputType.text,
                    controller: _txtController,
                    onChanged: _onMessageChanged,
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 12),
                        hintText: "Type Something..."),
                    //onTap: () => onTextFieldTapped(),
                  ),
                ),
                GestureDetector(
                  //  backgroundColor: Theme.of(context).primaryColor,
                  onTap: () => _sendMessage(),
                  //   onPressed: () => isCurrentUserTyping ? _sendMessage() : _like(),
                  // child: Icon(isCurrentUserTyping ? Icons.send : Icons.thumb_up),
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //  print(widget.mid);
    return WillPopScope(
      onWillPop: () async => false,
      /* child: Consumer<MassegesContent>(
          builder: (context,directMassege,child)  {
            //print(directMassege.massegesContent);
            myMessages= directMassege.massegesContent;
            //.getMassegesContext(widget.mid);
            return child;
          },
*/
      child: Scaffold(
        backgroundColor: const Color(0xfff3f6fc),
        appBar: _myDetailAppBar(),
        body: //myMessages==null? Container():
            buildBody(),
      ),
      //  ),
    );
  }

  @override
  Widget _myDetailAppBar() {
    return AppBar(
      actions: [
        GestureDetector(
            onTap: widget.newChat
                ? () {}
                : () => Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ChatInfo(
                                  channalId: widget.mid,
                                  sender: widget.chatDetils,
                                  //member: widget.member,
                                  //  groupchat: widget.isChat,
                                )))
                        .then((value) {
                      setState(() {});
                    }),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(33.0),
                  child: MembertImage(
                      item: widget.chatDetils == null
                          ? newChatRom
                          : widget.chatDetils)),
            ))
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.title == null
              ? Expanded(
                child: Text(widget.chatDetils.name,// style: MyTheme.kAppTitle
          ),
              )
              : Expanded(
                  child: Text('${widget.title}', //style: MyTheme.kAppTitle
                  ))
          //TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
        ],
      ),
      leading: GestureDetector(
        onTap: () {
          print('back ...');
          Navigator.pushReplacementNamed(context, "/a");
        },
        child: Container(
          //  color: Colors.black,
          height: 55,
          width: 55,
          child: //: Navigator.of(context).pop(),
              Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: const Color(0xff336699),
    );
  }

  buildBody() {
    // print(myMessages);
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemCount: myMessages.length,
                      itemBuilder: (context, index) {
                        final Massege message = myMessages[index];
                        return MyMessageChatTile(
                            datesend: message.date,
                            msender: message.sender,
                            isChat: widget.isChat,
                            message: message,
                            isCurrentUser: myMessages[index].isMine);
                      })),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomSection(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

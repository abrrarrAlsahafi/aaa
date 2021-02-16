import 'dart:async';

import 'package:management_app/Screen/chat/chat_info.dart';
import 'package:management_app/bottom_bar.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_message_tile.dart';

class MyDirectChatDetailPage extends StatefulWidget {
  final mid;
  final member;
  final title;
  final sender; //member/user /channal
  final currentUser;
  final newChat;
  final isChat;
  final ischatGroup;
  final isPrivetGroup; //true if privit or chat one to one

  MyDirectChatDetailPage(
      {this.ischatGroup,
      this.isPrivetGroup,
      this.title,
      this.newChat,
      this.mid,
      this.sender,
      this.currentUser,
      this.member,
      this.isChat});

  @override
  _MyDirectChatDetailPageState createState() => _MyDirectChatDetailPageState();
}

bool addnewChat = false;

class _MyDirectChatDetailPageState extends State<MyDirectChatDetailPage> {
  final double minValue = 8.0;
  final double iconSize = 28.0;
  bool _disposed = false;
  List<Massege> myMessages= List();
  FocusNode _focusNode;
  TextEditingController _txtController = TextEditingController();
  bool isCurrentUserTyping = false;
  ScrollController _scrollController;
//List
  Timer timer;
  Chat newChatRom;
  String message = '';
  List m = List();
  int uid;
  checkMember() {
    uid = Provider.of<UserModel>(context, listen: false).user.uid;
    if (widget.ischatGroup) {
      //  uid = Provider.of<UserModel>(context, listen: false).user.uid;
      for (var item in widget.member) {
        m.add(item.id);
      }
    } else {
      // uid = Provider.ofwidget.member.<UserModel>(context, listen: false).user.uid;
      m.add(widget.member.id);
      m.add(uid);
      // print('new chat ${m}');
    }
    return m;
  }

  @override
  void initState() {
    super.initState();
    _scrollController =ScrollController();
    if (widget.newChat && (widget.ischatGroup == false)) {
  //  print('new chat ');
      //createChat();
      setState(() {
         _disposed = true;
        addnewChat = true;
      });
    }
    if (widget.ischatGroup) {
      createGroup();
      setState(() {
        addnewChat = true;
      });
    } else {
      print('mid = ${widget.mid}');
      setState(() {
        addnewChat = false;
      });
      Timer(Duration(seconds: 1), () {
        if (!_disposed) this.getMasseges();
      });
     // getMasseges();
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        if (totalMessges > 0) getMasseges();
      });
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    timer?.cancel();
    _disposed = true;
    super.dispose();
  }

  Future<void> getMasseges() async {
    myMessages = await Provider.of<MassegesContent>(context, listen: false).getMassegesContent(widget.mid);
  setState(() {

  });
  }
  Future<void> newDirctMassege() async {
  if(totalMessges>0){
   await Provider.of<MassegesContent>(context, listen: false).getMassegesContent(widget.mid);
   setState(() {
     myMessages = Provider.of<MassegesContent>(context, listen: false).getMassegesContent(widget.mid);
   });
  }
  }

  createGroup() async {
    newChatRom = Chat(
        members: checkMember(), //widget.member.id,
        name: widget.title, // widget.member.last.name + ',',
        image: 'False', //widget.member.last.image,
        //lastDate: DateTime.now().toString(),
        isChat: false,
        adminId: uid,
        lastMessage: '');

    //print( "new channal ${newChatRom.adminId}, ${newChatRom.name} ${newChatRom.members}");
    await Provider.of<ChatModel>(context, listen: false)
        .createChannal(newChatRom, widget.isChat, widget.isPrivetGroup);
    await Provider.of<ChatModel>(context, listen: false).getChannalsHistory();

    setState(() {});
  }

  createChat() async {
    newChatRom = Chat(
        members: checkMember(), //widget.member.id,
        name: widget.member.name + ',',
        image: widget.member.image,
        //lastDate: DateTime.now().toString(),
        isChat: true,
        adminId: uid,
      //  lastMessage: ''
    );
    //print("new chat ${newChatRom.members[1]}");
    await Provider.of<ChatModel>(context, listen: false)
        .createChannal(newChatRom, widget.isChat, widget.isPrivetGroup);
    await Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
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

  bool newmasseg=false;
  Future<void> _sendMessage() async {
    if (message.isNotEmpty) {
      if (widget.mid == null && widget.isChat && widget.ischatGroup == false){
        createChat();
        myMessages.insert( 0, (Massege(message,DateTime.now(), 'Me',true)));
        newmasseg = await EmomApi().postNewMessage(widget.mid, message);
      } else {
        myMessages.insert( 0, (Massege(message,DateTime.now(), 'Me',true)));
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
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    // FocusNode:ـ focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    controller: _txtController,
                    onChanged: _onMessageChanged,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your message"),
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
    // print(   "chat member ${widget.member == null ? widget.sender.members : widget.member}");
    return Scaffold(
      backgroundColor: const Color(0xfff3f6fc),
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap:widget.newChat?(){} :() => Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ChatInfo(
                                channalId: widget.mid,
                                sender: widget.sender,
                                //member: widget.member,
                                groupchat: widget.ischatGroup,
                              )))
                      .then((value) {
                    setState(() {});
                  }),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(33.0),
                    child: MembertImage(
                        image: widget.ischatGroup && widget.newChat
                            ? 'False'
                            : widget.newChat
                                ? widget.member.image
                                : widget.sender.image)),
              ))
        ],
        title: widget.title == null
            ? Align(
                alignment: Alignment.topLeft,
                child: ContentApp(
                    code: 'chat', style: TextStyle(color: Colors.white)),
              )
            : Text('${widget.title}'),
        leading: // Row(
            //  children: [
            IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  if (widget.ischatGroup) {
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    //      builder: (context) => BottomBar()));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    if (widget.newChat) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      Navigator.pop(context);
                    }
                  }
                }),
        //  ],
        //  ),
        leadingWidth: 22,
        //  title:
        backgroundColor: const Color(0xff336699),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: FutureBuilder<void>(builder: (context, snapshot) {
                return snapshot.hasError || myMessages == null
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xff336699),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        controller: _scrollController,
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    //  padding: EdgeInsets.symmetric( vertical: minValue * 2, horizontal: minValue),
                        itemCount: myMessages.length,
                        itemBuilder: (context, index) {
                          final Massege message = myMessages[index];
                          return MyMessageChatTile(
                              datesend: message.date,
                              msender: message.sender,
                              isChat: widget.ischatGroup,
                              //currentUser:,
                              //   userImage: myMessages[index]. ,
                              message: message,
                              isCurrentUser: myMessages[index].isMine);
                        });
                // }
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
    //}
    // });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  Widget _myDetailAppBar() {
    final double minValue = 8.0;
    //final double iconSize = 32.0;

    return AppBar(
      actions: <Widget>[
        IconButton(icon: Icon(Icons.more_vert), onPressed: () => null)
      ],
      title: Row(children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Icon(
            Icons.person,
            size: 33,
          ),
        ),
        SizedBox(
          width: minValue,
        ),
        Flexible(
          child: new Container(
            padding: new EdgeInsets.only(right: 2.0),
            child: new Text(
              "AliSara",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ]),
    );
  }
}

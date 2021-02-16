import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:provider/provider.dart';
import '../../bottom_bar.dart';
import 'direct_chat_detail_screen.dart';

bool newchat = false;

class ChatList extends StatefulWidget {
  final name;
  ChatList(
      {Key key, // @required this.items,
      this.name})
      : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with TickerProviderStateMixin {
  List<Chat> chatHestoryList;
  bool _disposed = false;

  Timer timer;
 // var newMessagesnumber;
  var items;
  //List<String> list = ['One to One', 'One to many'];

  @override
  void initState() {
    chatHestoryList = Provider.of<ChatModel>(context, listen: false).chatsList;

    items = List.generate(
      chatHestoryList.length,
      (i) => MessageItem("Sender ", "Say Some thing", chatHestoryList),
    );
    //setState(() {
  //  newMessagesnumber = Provider.of<NewMessagesModel>(context, listen: false) .newMessages  .totalNewMessages;

    search = false;
    Timer(Duration(seconds: 1), () {
      if (!_disposed) this.getnewMasseges();
    });
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if(totalMessges>0) {
        getnewMasseges();
      }

    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    _disposed = true;
    super.dispose();
  }

  checkForNewSharedLists(){
    // setState(() {
    newMessege =
        Provider.of<NewMessagesModel>(context, listen: false).newMessages;//.newMessagesList();

    totalMessges = Provider.of<NewMessagesModel>(context, listen: false)
        .newMessages
        .totalNewMessages;
    chatHestoryList = Provider.of<ChatModel>(context, listen: false).chatsList;
    // .getChannalsHistory();
    setState(() {});
    //  });
    // print('list ${newMessege.totalNewMessages}');
  }

  getnewMasseges() {
    checkForNewSharedLists();
    if (totalMessges > 0) {
      List<ChannelMessages> newMsList =
          Provider.of<NewMessagesModel>(context, listen: false).newMessages.channelMessages;
      for (int i = 0; i < newMsList.length; i++) {
        for (int j = 0; j < chatHestoryList.length; j++) {
          if (chatHestoryList[j].id == newMsList[i].channelId) {
            //  print(chatHestoryList[i].id);
            setState(() {
              chatHestoryList[j].newMessage = true;
              chatHestoryList[j].lastMessage = newMsList[i].lastMessage;
              chatHestoryList[j].lastDate = newMsList[i].lastDate;
            });
          }
        }
      }
      setState(() {
        totalMessges=0;
      });
    }
    //myMessages = await EmomApi().getMassegesContent(1);
  }

  //final _debouncer = Debouncer(milliseconds: 10);
  String s = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6fc),
      floatingActionButton: FlatActionButtonWidget(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListUsers())),
        tooltip: 'Chat',
      ),
      body: ListTile(
        title: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width/36),
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<void>(builder: (context, snapshot) {
              if (snapshot.hasError || items == null) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                return ListView.builder(
                    // Let the ListView know how many items it needs to build.
                    itemCount: items.length,
                    // Provide a builder function. This is where the magic happens.
                    // Convert each item into a widget based on the type of item it is.
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Stack(children: [
                        ListTile(
                          onTap: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyDirectChatDetailPage(
                                            sender: chatHestoryList[index],
                                            ischatGroup: false,
                                            isPrivetGroup: false,
                                            newChat: false,
                                            isChat: true,
                                            member: chatHestoryList[index]
                                                .members,
                                            mid: chatHestoryList[index].id,
                                            title: chatHestoryList[index]
                                                .name
                                                .toString()
                                                .contains(',')
                                                ? chatHestoryList[index].name
                                                .substring(
                                                0,
                                                chatHestoryList[index]
                                                    .name
                                                    .indexOf(','))
                                                : chatHestoryList[index].name)),
                              ).then((value) {
                                setState(() {
                                  chatHestoryList[index].newMessage = false;

                                    totalMessges=totalMessges-1<=0?0:totalMessges-1;
                                });
                              }),
                          leading: item.buildLeading(context, index),
                          title: item.buildTitle(context, index, false),
                          subtitle: item.buildSubtitle(context, index),
                          trailing: item.buildTrailing(context, index),
                        ),
                        chatHestoryList[index].newMessage != null
                            ? chatHestoryList[index].newMessage
                            ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(Icons.circle,
                                color:Color(0xffe9a14e)),
                          ),
                        )
                            : Container()
                            : Container()
                      ]);
                    },

                  );
              }
            }   )
      ),

    ));
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context, int index, bool isUsers);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context, int index);

  Widget buildLeading(BuildContext context, int index);

  Widget buildTrailing(BuildContext context, int index);
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;
  List chatslist; //=Provider.of<ChatModel>(context).chatsList;
  //var file = Io.File(image);

  MessageItem(this.sender, this.body, this.chatslist);

  Widget buildLeading(BuildContext context, int index) => search
      ? Container()
      : ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: MembertImage(index: index, image: chatslist[index].image),
        );

  Widget buildTitle(BuildContext context, int index, isUsers) => Text(
        isUsers
            ? chatslist[index].name
            : chatslist[index].name.length > 18
                ? chatslist[index].name.toString().substring(
                    0,
                    chatslist[index]
                        .name
                        .toString()
                        .indexOf(',')) //chatslist[index].name.substring(0, 20)
                : chatslist[index].name,
        style: TextStyle(fontSize: 16),
      );

  Widget buildSubtitle(BuildContext context, int index) => Text(
        chatslist[index].lastMessage.length > 22
            ? chatslist[index].lastMessage.substring(0, 22) + '..'
            : chatslist[index].lastMessage == 'None'
                ? ''
                : chatslist[index].lastMessage,
        style: TextStyle(
          color: const Color(0xff336699),
        ),
      );

  Widget buildTrailing(BuildContext context, int index) => Text(
      chatslist[index].lastDate == 'False' || chatslist[index].lastDate == null
          ? ''
          : DateFormat('yMMMd')
              .format(DateTime.parse(chatslist[index].lastDate)),
      style: TextStyle(color: Colors.black38, fontSize: 11));

  //chatslist[index].image
}

class CreateGruope extends StatefulWidget {
  final members;
  final isPrivate;

  const CreateGruope({Key key, this.members, this.isPrivate}) : super(key: key);
  @override
  _CreateGruopeState createState() => _CreateGruopeState();
}

class _CreateGruopeState extends State<CreateGruope> {
  // var items;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  var groupName;
  List items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Folowing admin = Folowing(
        isAddmin: true,
        id: Provider.of<UserModel>(context, listen: false).user.uid,
        name: Provider.of<UserModel>(context, listen: false).user.name,
        image: 'False');
    widget.members.add(admin);
    items = List.generate(
      widget.members.length,
      (i) => MessageItem("Sender ", "Say Some thing", widget.members),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ContentApp(code: 'new group'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffe9a14e),
        onPressed: () => validateInput(),
        tooltip: 'Chat',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            dense: true,
            title: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.isEmpty) return S.of(context).chatValidation;
                  else return null;
                },
                onSaved: (String value) {
                  groupName = value;
                },
                cursorColor: const Color(0xff336699),
                // onChanged: ()=>,
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  labelStyle: TextStyle(
                    color: const Color(0xff336699),
                    fontFamily: 'Assistant',
                    fontSize: 14,
                  ),
                  hintText: S.of(context).chatValidation,
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontFamily: 'Assistant',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            leading: Icon(Icons.people_outline_rounded),
          ),
          Divider(color: Colors.grey),
          Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[200],
                      ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: item.buildLeading(context, index),
                      title: item.buildTitle(context, index, true),
                    );
                  })),
        ],
      ),
      backgroundColor: const Color(0xfff3f6fc),
    );
  }

  validateInput() {
    print("(${widget.members}, $groupName");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyDirectChatDetailPage(
                  ischatGroup: true,
                  isChat: false,
                  isPrivetGroup: widget.isPrivate,
                  member: widget.members,
                  title: groupName,
                  newChat: true,
                )),
      ).then((value) {
        setState(() {
          //totalMessges=totalMessges-1<=0?0:totalMessges-1;

        });
      });
      Chat newChatRom = Chat(
          name: groupName,
          image: 'False',
          //  isChat: widget.grupeType,
          members: widget.members,
          //  lastDate: DateTime.now().toString(),
          lastMessage: '');
      Provider.of<ChatModel>(context, listen: false).addNewChat(newChatRom);
      Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}

class ListUsers extends StatefulWidget {
  final isgruop;
  final isPrivet;
  final member;

  const ListUsers({Key key, this.isgruop, this.isPrivet, this.member})
      : super(key: key);
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  bool privitGrup = false;
  bool newgruop = false;
  List<MessageItem> items;
  List<bool> isChecked;
  List listFolow;
  @override
  void initState() {
    listFolow = Provider.of<FollowingModel>(context, listen: false).followList;
    items = List.generate(
      listFolow.length,
      (i) => MessageItem("Sender ", "Say Some thing", listFolow),
    );
    isChecked = List<bool>.filled(items.length, false);

    super.initState();
  }

  @override
  void dispose() {
    // _disposed = true;
    super.dispose();
  }

  List userSelected() {
    List usersSelected = List();
    for (int i = 0; i < items.length; i++) {
      print("${isChecked[i]}, $i");
      //
      if (isChecked[i]) {
        print(items[i].chatslist[i]);
        usersSelected.add(items[i].chatslist[i]);
      }
    }
    return usersSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6fc),
      floatingActionButton: newgruop
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Color(0xffe9a14e),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateGruope(
                            isPrivate: privitGrup,
                            members: userSelected(),
                          ))).then((value) {
                //  setState(() {
                //  Provider.of<ChatModel>(context).chatsList.add(value);
                //  });
              }),
            )
          : Container(),
      appBar: AppBar(
        title: Text('New Chat'),
      ),
      body: Column(
        children: [
          newgruop
              ? Container()
              : TileWidget(
                  title: S.of(context).newg,
                  icon: Icon(Icons.people_outline_rounded),
                  onPres: () {
                    setState(() {
                      newgruop = true;
                      privitGrup = false;
                    });
                  }),
          newgruop
              ? Container()
              : TileWidget(
                  onPres: () {
                    setState(() {
                      newgruop = true;
                      privitGrup = true;
                    });
                  },
                  title: S.of(context).privite,
                  icon: Icon(Icons.people_outline_rounded),
                ),
          Divider(
            color: Colors.grey[200],
          ),
          Expanded(
            child: items == null
                ? Container()
                : listMember()
          ),
        ],
      ),
    );
  }

  listMember(){
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[200],
      ),
      // Let the ListView know how many items it needs to build.
      itemCount: items.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
      //  print(isChecked.length);
        final item = items[index];
        return newgruop
            ? CheckboxListTile(
          value: isChecked[index],
          onChanged: (val) {
            setState(() {
              isChecked[index] = val;
            });
          },
          title: ListTile(
            onTap: () {},

            leading: item.buildLeading(context, index),
            title: item.buildTitle(context, index, true),
          ),
        )
            : ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyDirectChatDetailPage(
                      title: listFolow[index].name,

                      newChat: true,
                      member: listFolow[index],
                      ischatGroup: false,
                      isPrivetGroup: true,
                      isChat: true,
                    )),
          ).then((value) {
            setState(() {
           //   totalMessges=totalMessges-1<=0?0:totalMessges-1;
            });
          }),
          leading: item.buildLeading(context, index),
          title: item.buildTitle(context, index, true),
        );
      },
    );
  }
}

class TileWidget extends StatelessWidget {
  final icon;
  final title;
  final onPres;

  const TileWidget({Key key, this.icon, this.title, this.onPres})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Align(
        alignment: Alignment(-1.2, 0),
        child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: onPres,
            // },
            child: Text(title)),
      ),
      leading: icon,
    );
  }
}

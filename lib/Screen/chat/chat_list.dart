import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/app_theme.dart';
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
  List<Chat> chatHestoryList = List();
  bool _disposed = false;
  TextEditingController controller = new TextEditingController();

  Timer timer;
  var items;

  @override
  void initState() {

   // chatHestoryList = Provider.of<ChatModel>(context, listen: false).chatsList;

       getnewMasseges();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (Provider.of<NewMessagesModel>(context, listen: false).totalm > 0) {
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

  checkForNewSharedLists() {
    newMessege = Provider.of<NewMessagesModel>(context, listen: false).newMessages;
    chatHestoryList = Provider.of<ChatModel>(context, listen: false).chatsList;
    items = List.generate(
      chatHestoryList.length,
          (i) => MessageItem(chatHestoryList[i]),
    );
    //setState(() {});
  }

  getnewMasseges() {
    checkForNewSharedLists();
    if (Provider.of<NewMessagesModel>(context, listen: false).totalm > 0) {
      List<ChannelMessages> newMsList =
          Provider.of<NewMessagesModel>(context, listen: false)
              .newMessages
              .channelMessages;
      newMsList.forEach((element) {
        //  setState(() {
        chatHestoryList.forEach((e) {
          if (e.id == element.channelId) {
            e.newMessage = true;
            e.lastMessage = element.lastMessage;
            e.lastDate = element.lastDate;

          }
        });
      });
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    chatHestoryList.forEach((userDetail) {
      if (userDetail.name.contains(text) ||
          userDetail.lastMessage.contains(text))
        _searchResult.add(MessageItem(userDetail));
    });

    setState(() {});
  }

  List _searchResult = [];
  String s = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FlatActionButtonWidget(
          icon: Icons.chat_outlined,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListUsers())),
          tooltip: 'Chat',
        ),
        body: FutureBuilder<void>(builder: (context, asyncProduct) {
          if (asyncProduct.hasError && chatHestoryList==null) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff336699),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          } else {
            return Column(children: [
              search
                  ? ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.close),
                        onPressed: () {
                          controller.clear();
                          onSearchTextChanged('');
                        },
                      ),
                    )
                  : Container(),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width / 66),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.separated(
                      // Let the ListView know how many items it needs to build.
                      itemCount: _searchResult.length != 0 ||
                              controller.text.isNotEmpty
                          ? _searchResult.length
                          : chatHestoryList.length,
                      //items.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Divider(
                          color: Colors.black12,
                        ),
                      ),
                      // Provide a builder function. This is where the magic happens.
                      // Convert each item into a widget based on the type of item it is.
                      itemBuilder: (context, index) {
                        final item = _searchResult.length != 0 ||
                                controller.text.isNotEmpty
                            ? _searchResult[index]
                            : items[index];
                        return Stack(children: [
                          ListTile(
                            dense: true,
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  // settings: RouteSettings(name: "boo"),
                                  builder: (context) => MyDirectChatDetailPage(
                                      sender: chatHestoryList[index],
                                      ischatGroup: false,
                                      isPrivetGroup: false,
                                      newChat: false,
                                      isChat: chatHestoryList[index].isChat,
                                      member: chatHestoryList[index].members,
                                      mid: chatHestoryList[index].id,
                                      title: chatTitle(
                                          chatHestoryList[index].name))),
                            ),
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
                                            color: Color(0xffe9a14e)),
                                      ),
                                    )
                                  : Container()
                              : Container()
                        ]);
                      },
                    )),
              ),
            ]);
          }
        }));
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
  final item;

  MessageItem(this.item);

  Widget buildLeading(BuildContext context, int index) =>
      MembertImage(item: item);

  Widget buildTitle(BuildContext context, int index, isUsers) => Text(
        item.name,
        style: MyTheme.heading2,
      );

  Widget buildSubtitle(BuildContext context, int index) => Text(
        item.lastMessage.length > 22
            ? item.lastMessage.substring(0, 22) + '..'
            : item.lastMessage == 'None'
                ? ''
                : item.lastMessage,
        style: TextStyle(
          color: const Color(0xff336699),
        ),
      );

  Widget buildTrailing(BuildContext context, int index) => Text(
      item.lastDate == 'False' || item.lastDate == null
          ? ''
          : DateFormat('yMMMd').format(DateTime.parse(item.lastDate)),
      style: TextStyle(color: Colors.black38, fontSize: 11));
}

class CreateGruope extends StatefulWidget {
  final members;
  final isPrivate;

  const CreateGruope({Key key, this.members, this.isPrivate}) : super(key: key);

  @override
  _CreateGruopeState createState() => _CreateGruopeState();
}

String chatTitle(str) {
  return "${str[0].toUpperCase()}${str.substring(1)}";
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
      (i) => MessageItem(widget.members),
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
                  if (value.isEmpty)
                    return S.of(context).chatValidation;
                  else
                    return null;
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
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              color: Colors.black12,
            ),
          ),
          Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Divider(
                          color: Colors.black12,
                        ),
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
    // print("(${widget.members}, $groupName");
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
      );
      /* Chat newChatRom = Chat(
          name: groupName,
          image: 'False',
          //  isChat: widget.grupeType,
          members: widget.members,
          //  lastDate: DateTime.now().toString(),
          lastMessage: '');
      Provider.of<ChatModel>(context, listen: false).addNewChat(newChatRom);
      Provider.of<ChatModel>(context, listen: false).getChannalsHistory();*/
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
      (i) => MessageItem(listFolow[i]),
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
      // print("${isChecked[i]}, $i");
      if (isChecked[i]) {
        // print(items[i].chatslist[i]);
        usersSelected.add(items[i].item); //.chatslist[i]);
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
                Icons.chat_outlined,
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
        // leading: ,
        title: Text('New Chat'),
      ),
      body: Column(
        children: [
          newgruop
              ? Container()
              : FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      newgruop = true;
                      privitGrup = false;
                    });
                  },
                  child: TileWidget(
                    title: S.of(context).newg,
                    icon: Icon(Icons.people_outline_rounded),
                  ),
                ),
          newgruop
              ? Container()
              : FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      newgruop = true;
                      privitGrup = true;
                    });
                  },
                  child: TileWidget(
                    title: S.of(context).privite,
                    icon: Icon(Icons.people_outline_rounded),
                  ),
                ),
          newgruop
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    color: Colors.black26,
                  ),
                ),
          Expanded(child: items == null ? Container() : listMember()),
        ],
      ),
    );
  }

  listMember() {
    return ListView.separated(
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Divider(
          color: Colors.black12,
        ),
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
                // selected:isChecked[index] ,
                // activeColor: Colors.red,
                value: isChecked[index],
                onChanged: (val) {
                  setState(() {
                    isChecked[index] = val;
                  });
                },
                title: ListTile(
                  leading: item.buildLeading(context, index),
                  title: item.buildTitle(context, index, true),
                ),
              )
            : ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyDirectChatDetailPage(
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
      title: Align(alignment: Alignment(-1.2, 0), child: Text(title)),
      leading: icon,
    );
  }
}

import 'package:management_app/model/folowing.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersList extends StatefulWidget {
  List member;
  var admin;

  MembersList({Key key, @required this.member, this.admin}) : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  List<ListItem> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.member.isEmpty) {
      widget.member = Provider.of<FollowingModel>(context).followList;
    } else {
      items = List.generate(
          widget.member.length,
          (i) => MessageItem(
                widget.member[i].name,
                widget.member[i].image,
                widget.admin == null
                    ? false
                    : widget.admin == widget.member[i].id,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Members';

    return Expanded(
      child: Container(
        // backgroundColor: const Color(0xfff3f6fc),
        height: 100.0 * items.length,
        child: // Container(
            /* backgroundColor: const Color(0xfff3f6fc),
          appBar: AppBar(
            backgroundColor: const Color(0xff336699),
            automaticallyImplyLeading: true,
            title: Text(title),
          ),*/
            // child
            ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];
            //print(length);

            return ListTile(
              leading: item.buildLeading(context, index),
              title: item.buildTitle(context, index),
              subtitle: item.buildSubtitle(context),
              /*   trailing: InkWell(
                onTap: () => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(
                        builder: (context) => MyDirectChatDetailPage(
                              newChat: true,
                              member: [],
                              //mid: widget.items[index].,
                              isPrivetGroup: false,
                              ischatGroup: false,
                            )))
                    .then((value) {
                  setState(() {});
                }),
                 child: Icon(
                  Icons.chat,
                  color: Colors.orange,
                ),
              ),*/
            );
          },
        ),
        // ),
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context, int index);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);

  Widget buildLeading(BuildContext context, int index);
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final sender;
  final body;
  final isFolowing;

  List<String> members = [
    'Ali Ahmed',
    'Nora Sliman',
    'Sali Ali',
    'Dr.Shaya',
    'Aljazi Omer',
    'Adam Family',
    'Lili Karim'
  ];
  MessageItem(this.sender, this.body, this.isFolowing);

  Widget buildLeading(BuildContext context, int index) => ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: MembertImage(
        index: index,
        image: body,
      )
      // : Container(),
      );

  Widget buildTitle(BuildContext context, int index) => Text(
        // isFolowing ?
        sender, //: members[index],
        style: TextStyle(),
      );

  Widget buildSubtitle(BuildContext context) => Text(
        isFolowing ? 'admin' : "",
        style: TextStyle(
            color: const Color(0xff336699), fontWeight: FontWeight.w300),
      );
}

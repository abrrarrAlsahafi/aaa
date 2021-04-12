import 'package:flutter/material.dart';
import 'package:management_app/Screen/chat/chat_list.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:provider/provider.dart';

import 'buttom_widget.dart';

class BottonWidget {
  void mainBottomSheet(BuildContext context,bool isList
      ,String title) {
    List member = Provider.of<FollowingModel>(context, listen: false).followList;
   // isChckList = true;
   List items = List.generate(
        member.length,
            (i) => MessageItem(
            member[i], false));
   //List isChecked = List<bool>.filled(items.length, false);
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {

          return Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              margin: EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 200, top: 12),
                    child: ContentApp(
                     code: '$title',
                      style: MyTheme.chatSenderName,),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      //child://isList?
                    //  MembersList():
                    /*  ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) =>
                            CheckboxListTile(
                          value: isChecked[index],
                          onChanged: (val) {
                            setState(() {
                              isChecked[index] = val;
                            });
                          },
                          title: ListTile(
                            // onTap: isChckList?()=>addMember():(){},
                            dense: true,
                            leading: item.buildLeading(context, index),
                            title: item.buildTitle(context, index),
                            subtitle: item.buildSubtitle(context,index),
                          ),
                        )
                      ),*/
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: ButtonWidget(
                      child: ContentApp(
                        code: '$title',
                        style: MyTheme.kAppTitle,
                      ),
                 //   icon: Icons.check_circle_rounded,
                     // onPressed: ()=>addMember()
                    ),
                  )
                ],
              ));
        });
  }

}

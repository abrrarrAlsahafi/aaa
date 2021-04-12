import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/generated/I10n.dart';

class SearchWidget extends StatelessWidget {
  final onSearchTextChanged;
  final controller;
  final onPressed;

  const SearchWidget({Key key, this.onSearchTextChanged, this.controller, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height/16,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(26)),
         //   border: Border.all(color: MyTheme.kPrimaryColorVariant),
            color: Colors.white
        ),
        child:Row(
          children: [
            SizedBox(width: 18),
            Padding(
              padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.search, size: 18, color:Colors.grey )),
            SizedBox(width: 2),
            Flexible(
              child: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(1),
                    hintText: '${S.of(context).search}', border: InputBorder.none),
                onChanged: onSearchTextChanged,
              ),
            ),
             IconButton(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Icon(Icons.close, size: 18, color: MyTheme.kPrimaryColorVariant,),
                ),
                onPressed:onPressed
            ),
        ],
      )
    );
  }
}

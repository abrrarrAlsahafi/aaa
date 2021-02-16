import 'package:flutter/material.dart';
import 'package:management_app/common/constant.dart';

class BottonWidget {
  void mainBottomSheet(BuildContext context, List<String> list,
      VoidCallback onPressed, String title) {
    showModalBottomSheet<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              // color: Colors.transparent,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) => FlatButton(
                    highlightColor: hexToColor('#89ABCD'),
                    child: Text(
                      list[index],
                      style:
                          TextStyle(fontSize: 15, color: hexToColor('#5A7A99')),
                    ),
                    onPressed: onPressed,
                  ),
                ),
              ));
        });
  }
}


import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/sessions.dart';
import 'package:management_app/widget/content_translate.dart';

class TopicScreen extends StatelessWidget {
  final Sessions item;
    final index;
  const TopicScreen({Key key, this.item, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: MyTheme.kPrimaryColorVariant,
       title: Text(item.topics[index].name, style: MyTheme.kAppTitle)),
      backgroundColor: MyTheme.kAccentColor,
      body: Container(
        margin: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
color: Colors.white,
//padding: EdgeInsets.all(16),
        child:ListView(
          children:[
           // SizedBox(height: 30),
         //   Text('${item.topics[index].name} is by ${item.topics[index].source}'),
            SizedBox(height: 22,),

            ListTile(title: Text('${item.topics[index].source}'), leading: ContentApp(
              code: 'sours',
            )),
           // description
            Divider(
              color: Colors.black12,
            ),
            Container(
                margin: EdgeInsets.all(10),//height: MediaQuery.of(context).size.height/3,
                padding: EdgeInsets.all(22),
                width:MediaQuery.of(context).size.width ,
               /* decoration:   BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black26)],
                    color: Colors.white,
                    //  boxShadow:BoxShadow. ,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: MyTheme.kAccentColor,
                      width: 0.5,
                    )),*/
                //shape:,
                child:ListTile(
                   title: ContentApp(
                      code: 'description',
                    ),
                   subtitle: Text('${item.topics[index].abstract}')
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Divider(
                color: Colors.black12,
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(22),
              width:MediaQuery.of(context).size.width ,

              //shape:,
              child:ListTile(
                  title:ContentApp(
                    code: 'recom',
                  ),
                  subtitle:  Text('${item.topics[index].recommendation}')
              )// ContactApp,
            )
          ],
        ),


      ),
/*floatingActionButton: FlatActionButtonWidget(
  onPressed: ()=>{},//Navigator.pop(context),
  icon: Icons.playlist_add_check_outlined,
)*/);
  }
}

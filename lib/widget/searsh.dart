import 'package:management_app/model/channal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class SearshScreen extends StatefulWidget {
  final isShadow;
  final isHome;
  final radius;
  final title;
  final onPressed;
  final hight;
  final onTap;
  SearshScreen({
    this.isHome,
    this.title,
    this.onPressed,
    this.radius,
    this.hight,
    this.isShadow = false,
    this.onTap,
  });

  @override
  _SearshScreenState createState() => _SearshScreenState();
}

List<Chat> users = List();
List<Chat> filteredUsers = List();

class _SearshScreenState extends State<SearshScreen> {
  String s;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ContainerResponsive(
          height: widget.hight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.0, color: Colors.grey[200]),
            boxShadow: widget.isShadow ? [BoxShadow(color: Colors.grey)] : null,
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    onChanged: (String text) {
                      setState(() {
                        s = text;
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: ' ' + widget.title,
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 191, 191, 191),
                        fontWeight: FontWeight.w400,
                        fontSize:
                            ScreenUtil().setSp(12, allowFontScalingSelf: true),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Transform.rotate(
                angle: 90 * 3.14 / 180,
                child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 191, 191, 191),
                    ),
                    onPressed: widget.onTap //widget.onPressed
                    ),
              ),
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/constant.dart';

class MyTheme {
  MyTheme._();

  //static Color kPrimaryColor = Color(0xff7C7B9B);
  static Color kPrimaryColorVariant = Color(0xff336699);
  static Color kAccentColor = Color(0xfff3f6fc);
  static Color kAccentColorVariant = hexToColor('#E1E8F5');
  static Color kUnreadChatBG = Color(0xffe9a14e);

  static final TextStyle kAppTitle = GoogleFonts.tajawal(
      fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
      fontWeight: FontWeight.bold,
      color:Color(0xff336699) );
  static final TextStyle heading2 = TextStyle(
    color: Colors.black,
    fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
    fontWeight: FontWeight.bold,
  );
  static final TextStyle chatSenderName = TextStyle(
    color: Colors.black38,
    fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
    fontWeight: FontWeight.bold,
    //letterSpacing: 1.5,
  );
  static final TextStyle bodyText1 = TextStyle(
      color: MyTheme.kPrimaryColorVariant,
      fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
      //letterSpacing: 1.2,
      fontWeight: FontWeight.bold);
  static final TextStyle bodyText2 = TextStyle(
      color: Colors.black87,
      fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
      fontWeight: FontWeight.bold);
  static final TextStyle bodyTextMessage = TextStyle(
      fontSize: ScreenUtil().setSp(13, allowFontScalingSelf: true),
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600);
  static final TextStyle bodyTextTask = TextStyle(
    fontSize: ScreenUtil().setSp(13, allowFontScalingSelf: true),
    fontWeight: FontWeight.w600,
    color: Colors.grey[400],
  );
  static final TextStyle bodyTextTime = TextStyle(
    color: Colors.grey[200],
    fontSize: ScreenUtil().setSp(11, allowFontScalingSelf: true),
    fontWeight: FontWeight.bold,
  );

  static final TextStyle Snacbartext = TextStyle(
    color: Colors.white,
    fontSize: ScreenUtil().setSp(11, allowFontScalingSelf: true),
    fontWeight: FontWeight.bold,
  );
}

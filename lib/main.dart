
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/services/index.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/login_page.dart';
import 'generated/I10n.dart';
import 'model/app_model.dart';
import 'model/channal.dart';
import 'model/folowing.dart';
import 'model/massege.dart';
import 'model/task.dart';
import 'model/user.dart';

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  SharedPreferences prefs = await SharedPreferences.getInstance();
  //email= prefs.getString('email');
  //var pass =prefs.g
  AppModel appLanguage = AppModel();
  runApp(MyApp(
    appLanguage: appLanguage
  ));
}
var email;

class MyApp extends StatefulWidget {
  final AppModel appLanguage;
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  MyApp({Key key, this.appLanguage}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800])),
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppModel()),
          ChangeNotifierProvider(create: (context) => UserModel()),
          ChangeNotifierProvider(create: (context) => TaskModel([])),
          ChangeNotifierProvider(create: (context) => ChatModel()),
          ChangeNotifierProvider(create: (context) => FollowingModel([])),
          ChangeNotifierProvider(create: (context) => MassegesContent()),
          ChangeNotifierProvider(create: (context) => NewMessagesModel()),
        ],
        child: StreamProvider<User>.value(
            value: Services().user,
            child: MaterialApp(
              locale: _locale, // widget.appLanguage.appLocal,
              supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              debugShowCheckedModeBanner: false,
              title: 'EMoM',
              // debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textTheme:
                      GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme),
                  backgroundColor: Color(0xfff3f6fc),
                  primaryColor: Color(0xff336699),
                  buttonColor: Color(0xff336699),
                  canvasColor: Colors.transparent),

              home: Roots(),
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              //  onGenerateRoute: CustomRouter.generatedRoute,
              //  initialRoute: Roots,
            )
            //   }),
            ),
      );
    }
  }
}

class Roots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        allowFontScaling: false,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height);

    ResponsiveWidgets.init(
      context,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width, // Optional
      //referenceShortestSide: true, // Optional
    );
    return ResponsiveWidgets.builder(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LoginPage()
    ); //auth login
  }
}

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:management_app/bottom_bar.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../main.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isChecked = false;
  bool status = false;
  bool status1 = false;
  bool status2 = false;
  bool status3 = false;
  bool _disposed = false;
  Geolocator geolocator = Geolocator();
  String _latitude = "24.7348936";
  String _longitude = "46.783085899999996";
  bool _isGettingLocation;
  var val = AppModel().locale == 'ar' ? langList.first : langList.last;

  var a = 1.1;
  void initState() {
    super.initState();
    _isGettingLocation = false;
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true); //.catchError((err) => print(err));

// this will get the coordinates from the lat-long using Geocoder Coordinates
    final coordinates = Coordinates(position.latitude, position.longitude);

// this fetches multiple address, but you need to get the first address by doing the following two codes
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
  setState(() {
    _isGettingLocation =
        (_longitude == (addresses.first.coordinates.longitude.toString())) &&
            (_latitude == (addresses.first.coordinates.latitude.toString()));
  });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return profileApp();
  }
  profileApp() {
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.all(33),
        height: MediaQuery.of(context).size.height,
            color: hexToColor('#336699'),
            child:Column(
                children: [
              Padding(
               padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height/33),
                child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
      height: 55,
      width: 55,
      child: IconButton(
      icon: Icon(
      Icons.arrow_back_ios_rounded,
      color: Colors.white,
      size: 18,
      ),
      onPressed: () => Navigator.of(context).pop(),
      ),
    ), Expanded(child: SizedBox(width: 12,)),
    IconButton(
    icon: Icon(
    Icons.lock_outline_rounded,
    color: Colors.white,
    size: 18,
    ),
    onPressed: () async {
      await EmomApi().logOut(username: Provider.of<UserModel>(context, listen: false).user.username, password: Provider.of<UserModel>(context,listen: false).user.pass, );

      setState(() {
    isLoggedIn=false;
    Navigator.of(context).pushNamed('/b');

    });
    },
    )
    ],
    ),
    ),
              Expanded(
                    child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 66),
                alignment: Alignment.topCenter,
                child: Text(
                    '${Provider.of<UserModel>(context).user.partnerDisplayName}',
                    style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                )),
                  ),
                  Align(
            alignment: Alignment.bottomCenter,
            child: Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.288,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(33))),
                child: employeeInfo(),
              ),
            ),
          ),
 ],
      ),
    ));
  }

  employeeInfo() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 12),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContentApp(
                  code: 'uid', //'Company Id:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
              Expanded(child: SizedBox(height: 10)),
              Text("${Provider.of<UserModel>(context).user.uid}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
            ],
          ),
          SizedBox(height: 22),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ContentApp(
              code: 'lang',
            ),
            Expanded(child: SizedBox(height: 10)),
            Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xffe9a14e),
                ),
                iconSize: 24,
                underline: Container(height: 0),
                elevation: 1,
                style: TextStyle(color: Color(0xffe9a14e), fontSize: 16),
                value: val,
                onChanged: (newValue) {
                  setState(() {
                    val = newValue;
                    if (newValue == 'العربية') {
                      //Provider.of<AppModel>(context, listen: false)
                      // Local newLocale =;

                      // AppModel().changeLanguage(Locale('ar'));
                      Locale newLocale = Locale('ar', 'SA');
                      MyApp.setLocale(context, newLocale);
                    } else {
                      //  Provider.of<AppModel>(context, listen: false)
                      // AppModel().changeLanguage(Locale('en'));
                      Locale newLocale = Locale('en', 'US');
                      MyApp.setLocale(context, newLocale);
                    }
                  });
                },
                items: langList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ]),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: 22),

          // SizedBox(height: MediaQuery.of(context).size.width / 6),
          ContentApp(
              code: 'scan',
              style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          SizedBox(height: 22),
        //  Expanded(
           // child:
            Container(
                height: MediaQuery.of(context).size.width / 1.5,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xffe9a14e),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(22))),
                child: Center(
                  child: _isGettingLocation == null
                      ? ContentApp(
                          code: 'loding',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                      : _isGettingLocation
                          ? QrImage(
                              data:
                                  "${Provider.of<UserModel>(context).user.uid + num.parse(DateTime.now().microsecond.toString())}",
                              version: QrVersions.auto,
                              size: MediaQuery.of(context).size.width / 1.2,
                            )
                          : ContentApp(
                                code: 'place',
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),

                )),
        //  ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

List<String> langList = ['العربية', 'English'];

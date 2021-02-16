import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/user.dart';
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
 // Position _currentPosition;
  bool _disposed = false;
  Geolocator geolocator = Geolocator();
  double _latitude=24.7348936;
  double _longitude=46.783085899999996;
  bool _isGettingLocation;
  var val = AppModel().locale == 'ar' ? langList.first : langList.last;


  void initState() {
    super.initState();
    _isGettingLocation=true;
    _getCurrentLocation();
  }

 _getCurrentLocation() async{
   Position position =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true);//.catchError((err) => print(err));

// this will get the coordinates from the lat-long using Geocoder Coordinates
   final coordinates =  Coordinates(position.latitude, position.longitude);

// this fetches multiple address, but you need to get the first address by doing the following two codes
   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
   _isGettingLocation=_longitude==addresses.first.coordinates.longitude && _latitude== addresses.first.coordinates.latitude;
   print("countryName ${_isGettingLocation}, type ${addresses.first.coordinates}");
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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(18),
            color: hexToColor('#336699'),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.3,
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
          Container(
              padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.width / 4),
              alignment: Alignment.topCenter,
              child: Text(
                '${Provider.of<UserModel>(context).user.partnerDisplayName}',
                style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
          /* Container(
              Text("${Provider.of<UserModel>(context).user.name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
            padding: EdgeInsets.symmetric(vertical: 117, horizontal: 142),
            child: CircleAvatar(
              radius: 66,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: Text(
                '${getInitials(Provider.of<UserModel>(context).user.name)}',
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
            ) CircleAvatar(
              radius: 66,
              backgroundColor: Colors.white,
              child: Image.asset(
                "assets/images/user.png",
                color: Colors.black87,
                width: 100,
              ),
            )
            ,
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 44),
            child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )),
          ),
        ],
      ),
    );
  }

  employeeInfo() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 12),
      child: Column(
        children: [
          /*
          _currentPosition != null && _currentAddress != null
              ? Text(_currentAddress,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.black))
              : Container(),
*/

          //  SizedBox(height: 10),
          //Divider(color: Colors.grey),
          // SizedBox(height: 22),
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
          SizedBox(height: 10),

          // SizedBox(height: MediaQuery.of(context).size.width / 6),
          ContentApp(
              code: 'scan',
              style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          SizedBox(height: 22),
          Container(
              height: MediaQuery.of(context).size.width / 1.5,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
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
                  "${Provider.of<UserModel>(context).user.uid+num.parse(DateTime.now().microsecond.toString())}",
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width/1.2,
                )
                    : ContentApp(
                    code: 'place',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              )),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

List<String> langList = ['العربية', 'English'];

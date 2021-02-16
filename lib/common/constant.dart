import 'package:flutter/material.dart';

const kLocalKey = {
  "url": "http://159.89.135.104:8070",
  "userInfo": "userInfo",
  "home": "home",
};
const kAdvanceConfig = {
  "DefaultLanguage": "en",

};


Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

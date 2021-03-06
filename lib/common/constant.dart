import 'package:flutter/material.dart';

const kLocalKey = {
  "url": "",
  "userInfo": 1,
  "home": "home",
};
const kAdvanceConfig = {
  "DefaultLanguage": "en",
};

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

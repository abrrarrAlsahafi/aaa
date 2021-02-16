import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class S {
  final Locale locale;
  S(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<S> delegate = _AppLocalizationsDelegate();

  Map<String, String> localizedValues;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('lib/config/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    localizedValues = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return localizedValues[key];
  }

  String get home {
    return localizedValues['home'];
  }

  String get meetings {
    return localizedValues['meetings'];
  }

  String get task {
    return localizedValues['tasks'];
  }

  String get chat {
    return localizedValues['chat'];
  }

  String get more {
    return localizedValues['more'];
  }

  String get search {
    return localizedValues['searchPbar3'];
  }

  String get username {
    return localizedValues['usernam'];
  }

  String get password {
    return localizedValues['password'];
  }

  String get validationusername {
    return localizedValues['emailvalidation'];
  }

  String get validationpassword {
    return localizedValues['passvalidation'];
  }

  String get privite {
    return localizedValues['private group'];
  }

  String get newg {
    return localizedValues['new group'];
  }

  String get chatValidation {
    return localizedValues['chatValidation'];
  }

  String get newtask {
    return localizedValues['new'];
  }

  String get assign {
    return localizedValues['assign'];
  }

  String get inprog {
    return localizedValues['in progress'];
  }

  String get done {
    return localizedValues['done'];
  }

  String get canceled {
    return localizedValues['canceled'];
  }

  String get loginValidatin {
    return localizedValues['loginValidatin'];
  }

  String get searsh {
    return localizedValues['searsh'];
  }

  Locale get localLang {
    return locale;
  }

  ///meetting hint
  String get title {
    return localizedValues['title'];
  }
  String get empty {
    return localizedValues['empty'];
  }
  String get location {
    return localizedValues['location'];
  }
  String get date {
    return localizedValues['date'];
  }
  String get time {
    return localizedValues['time'];
  }

  String get duration {
    return localizedValues['duration'];
  }

  String get agenda {
    return localizedValues['agenda'];
  }
  String get agreement {
    return localizedValues['agreement'];
  }
  String get member {
    return localizedValues['members'];
  }

}

class _AppLocalizationsDelegate extends LocalizationsDelegate<S> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<S> load(Locale locale) async {
    S localizations = new S(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

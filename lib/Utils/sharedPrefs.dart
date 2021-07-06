import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  SharedPreferences? prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> signIn(String phone) async {
    log(phone);
    await prefs!.setBool('signedIn', true);
    await prefs!.setString('phone', phone);
  }

  Future<bool?> checkSignIn() async {
    return prefs!.getBool('signedIn');
  }

  Future<String?> getPhone() async {
    return prefs!.getString('phone');
  }

  Future<void> signOut() async {
    await prefs!.setBool('signedIn', false);
    await prefs!.setString('phone', '');
  }
}

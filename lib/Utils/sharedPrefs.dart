import 'dart:developer';

import 'package:digite_assign/Utils/infoProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  SharedPreferences? prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    String? phone = prefs!.getString('phone');
    InfoProvider.phone = phone ?? '';
  }

  Future<void> signIn(String phone) async {
    InfoProvider.phone = phone;
    await prefs!.setBool('signedIn', true);
    await prefs!.setString('phone', phone);
  }

  Future<bool?> checkSignIn() async {
    if (prefs!.getBool('signedIn') != null) {
      return prefs!.getBool('signedIn');
    }
    return false;
  }

  Future<void> signOut() async {
    await prefs!.setBool('signedIn', false);
    await prefs!.setString('phone', '');
    InfoProvider.phone = '';
  }
}

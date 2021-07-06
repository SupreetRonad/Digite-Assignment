import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';

class DataStore {
  late final Auth _auth;
  late final FirebaseFirestore dbRef;

  Future<void> init() async {
    _auth = Auth();
    _auth.init();
    dbRef = FirebaseFirestore.instance;
  }

  Future<bool> checkInfo(String? phone) async {
    bool userExists = false;
    await dbRef.collection('users').doc(phone).get().then(
      (value) {
        if (value.exists) {
          userExists = true;
        } else {
        }
      },
    );
    return userExists;
  }
}

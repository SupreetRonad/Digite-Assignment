import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Authentication/authScreen.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/infoProvider.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool retrieving = true, isExpert = false;
  final Auth _auth = Auth();
  final DataStore _dStore = DataStore();

  String? phone = '', name = '';

  void signOut() async {
    await _auth.init();
    await _auth.signOut();
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => AuthScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  InfoProvider.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  InfoProvider.phone,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            signOutButton()
          ],
        ),
      ),
    );
  }

  Widget signOutButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          primary: Colors.red,
        ),
        onPressed: signOut,
        child: const Text('Log Out'),
      );
}

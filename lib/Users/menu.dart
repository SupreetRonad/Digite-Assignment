import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Authentication/authScreen.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
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

  void getInfo() async {
    await _auth.init();
    await _dStore.init();

    phone = await _auth.getPhone();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(phone)
        .get()
        .then((value) {
      if (value.exists) {
        name = value['name'];
        isExpert = value['isExpert'];
        retrieving = false;
      }
    });
    setState(() {});
  }

  void signOut() {
    _auth.signOut();
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
    getInfo();
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
        padding: EdgeInsets.all(25),
        child: retrieving
            ? Loading()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        name!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        phone!,
                        style: TextStyle(
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

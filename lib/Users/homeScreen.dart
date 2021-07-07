import 'dart:developer';

import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Users/menu.dart';
import 'package:digite_assign/Users/streamMessages.dart';
import 'package:digite_assign/Utils/infoProvider.dart';
import 'package:flutter/material.dart';

import '../Utils/firestore.dart';
import '../Utils/sharedPrefs.dart';
import 'message.dart';

class HomeScreen extends StatefulWidget {
  final Widget head;
  const HomeScreen({
    Key? key,
    required this.head,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth _auth = Auth();
  final DataStore _dStore = DataStore();

  bool retrieving = true;

  String? phone = '';

  void signOut() async {
    await _auth.init();
    await _dStore.init();
    _auth.signOut();
    Navigator.pushReplacementNamed(context, 'authScreen');
  }

  void menu() {
    showDialog(
      context: context,
      builder: (builder) {
        return const Menu();
      },
    );
  }

  void getInfo() async {
    phone = InfoProvider.phone;
    setState(() {
      retrieving = false;
    });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.head,
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: menu,
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: retrieving
          ? const Loading()
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const StreamMsg(),
                  const Message(),
                ],
              ),
            ),
    );
  }
}

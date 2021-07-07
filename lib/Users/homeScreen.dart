import 'dart:developer';

import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Users/menu.dart';
import 'package:digite_assign/Users/streamMessages.dart';
import 'package:digite_assign/Utils/infoProvider.dart';
import 'package:flutter/material.dart';

import '../Utils/firestore.dart';
import '../Utils/sharedPrefs.dart';
import 'sendMessage.dart';

class HomeScreen extends StatefulWidget {
  final Widget head;
  final String? phone;
  final bool expert;
  final String? name;
  const HomeScreen({
    Key? key,
    required this.head,
    this.phone,
    this.expert = false,
    this.name,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth _auth = Auth();
  final DataStore _dStore = DataStore();

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
            if (!widget.expert)
              IconButton(
                onPressed: menu,
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.expert
                ? StreamMsg(
                    fromExpert: true,
                    phone: widget.phone,
                  )
                : const StreamMsg(),
            widget.expert
                ? Message(
                    fromExpert: true,
                    phone: widget.phone,
                    name: widget.name,
                  )
                : const Message(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'Utils/firestore.dart';
import 'Utils/sharedPrefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ask an Expert',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: signOut,
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}

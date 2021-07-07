import 'package:digite_assign/Authentication/authScreen.dart';
import 'package:digite_assign/Authentication/detailsPage.dart';
import 'package:digite_assign/Expert/allChats.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:digite_assign/Users/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Utils/infoProvider.dart';

Auth _auth = Auth();
DataStore store = DataStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await _auth.init();
  await store.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool signedIn = false, hasInfo = false, isExpert = false;

  bool loading = true;

  void checkSignIn() async {
    signedIn = (await _auth.checkSignIn())!;
    if (signedIn) {
      String? phone = InfoProvider.phone;
      hasInfo = await store.checkInfo(phone);
      isExpert = InfoProvider.isExpert;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    checkSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loading
          ? const Loading()
          : signedIn
              ? isExpert
                  ? const AllChats()
                  : const HomeScreen(
                      head: Text('Ask an Expert'),
                      
                    )
              : AuthScreen(),
    );
  }
}

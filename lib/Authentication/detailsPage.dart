import 'dart:developer';
import 'dart:math' as math;
import 'package:digite_assign/Authentication/authScreen.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:digite_assign/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  final phone;

  const DetailsPage({Key? key, this.phone}) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool signingIn = true;
  final Auth _auth = Auth();
  final DataStore _dStore = DataStore();

  void signIn() async {
    await _auth.init();
    await _dStore.init();
    await _auth.signIn(widget.phone);
    bool userExists = await _dStore.checkInfo(await _auth.getPhone());

    if (userExists) {
      Navigator.pushReplacementNamed(context, 'homeScreen');
    } else {
      setState(() {
        signingIn = false;
      });
    }
  }

  void goBack() {
    _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => AuthScreen(),
      ),
    );
  }

  void storeInfo() {}

  @override
  void initState() {
    signIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return signingIn
        ? const Loading()
        : WillPopScope(
            onWillPop: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (builder) => AuthScreen(),
                ),
              );
              return Future.value(true);
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              floatingActionButton: signInButton(),
              body: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: IconButton(
                            onPressed: goBack,
                            icon: Icon(
                              Icons.shortcut_rounded,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Tell us about yourself...',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomField(
                        hint: 'Your name',
                        onChanged: (val) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget signInButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(17),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {},
        child: const Text('Save and Continue'),
      );
}

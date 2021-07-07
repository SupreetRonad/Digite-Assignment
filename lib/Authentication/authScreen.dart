import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Authentication/detailsPage.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Shared/customWidgets.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final Auth _auth = Auth();
  late String phone = '';
  final DataStore store = DataStore();
  bool focused = false;
  final FocusNode _focus = FocusNode();

  void _signIn() async {
    _focus.unfocus();

    if (phone.length != 10) {
      showMsg(context, 'Invalid phone number!', Colors.red);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => DetailsPage(
            phone: phone,
          ),
        ),
      );
    }
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      setState(() {
        focused = true;
      });
    } else {
      setState(() {
        focused = false;
      });
    }
  }

  @override
  void initState() {
    _focus.addListener(_onFocusChange);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: _enterMobile(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: focused
            ? _onFocus(width)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerText(width),
                ],
              ),
      ),
    );
  }

  Widget _onFocus(width) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Please enter your mobile number...',
              style: GoogleFonts.openSans(
                fontSize: width * .07,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );

  Widget _headerText(double width) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hey, welcome to',
            style: GoogleFonts.openSans(
              fontSize: width * .07,
              fontWeight: FontWeight.normal,
              color: Colors.black54,
            ),
          ),
          Text(
            'DigiExpert',
            style: GoogleFonts.ubuntu(
              fontSize: width * .15,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'An app to connect to the Experts',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: width * .04,
              fontWeight: FontWeight.normal,
              color: Colors.black54,
            ),
          ),
        ],
      );

  Widget _enterMobile() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    child: TextFormField(
                      focusNode: _focus,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '(12345) - 67890',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        ),
                        counterText: '',
                        border: InputBorder.none,
                        prefixText: '+91 ',
                      ),
                      onChanged: (val) {
                        setState(() {
                          phone = val;
                        });
                      },
                    ),
                  ),
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    elevation: 5,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _signIn,
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

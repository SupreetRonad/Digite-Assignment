import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

class StreamMsg extends StatefulWidget {
  const StreamMsg({Key? key}) : super(key: key);

  @override
  _StreamMsgState createState() => _StreamMsgState();
}

class _StreamMsgState extends State<StreamMsg> {
  bool retrieving = true;
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
        retrieving = false;
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: retrieving
          ? Loading()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(phone)
                  .collection('messages')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                var msgs = snapshot.data!.docs;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (itemBuilder, index) {
                    Map<String, dynamic> data =
                        msgs[msgs.length - index -1].data() as Map<String, dynamic>;
                    return Text(data['msg']);
                  },
                );
              },
            ),
    );
  }
}

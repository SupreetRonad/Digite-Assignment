import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Shared/displayMsg.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/infoProvider.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

class StreamMsg extends StatefulWidget {
  final bool fromExpert;
  const StreamMsg({Key? key, this.fromExpert = false}) : super(key: key);

  @override
  _StreamMsgState createState() => _StreamMsgState();
}

class _StreamMsgState extends State<StreamMsg> {
  bool retrieving = true;
  final Auth _auth = Auth();
  final DataStore _dStore = DataStore();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(InfoProvider.phone)
                  .collection('messages')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      widget.fromExpert
                          ? 'Loading...'
                          : 'Send your query to the Experts!',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 13,
                      ),
                    ),
                  );
                } else {
                  var msgs = snapshot.data!.docs;
                  if (msgs.isEmpty) {
                    return Center(
                      child: Text(
                        widget.fromExpert
                            ? 'Loading...'
                            : 'Send your query to the Experts!',
                        style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: msgs.length,
                    itemBuilder: (itemBuilder, index) {
                      Map<String, dynamic> data = msgs[msgs.length - index - 1]
                          .data() as Map<String, dynamic>;
                      bool fromMe = data['from'] == InfoProvider.phone ? true : false;
                      return DisplayMsg(
                        fromMe: fromMe,
                        msg: data['msg'],
                        time: data['time'],
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}

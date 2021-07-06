import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final Auth _auth = Auth();
  final DataStore _dStore = DataStore();
  TextEditingController message = TextEditingController();
  FocusNode node = FocusNode();

  Future<void> sendMsg() async {
    if (message.text.isNotEmpty) {
      node.unfocus();
      String? phone = await _auth.getPhone();
      int stamp = DateTime.now().microsecondsSinceEpoch;
      FirebaseFirestore.instance
          .collection('messages')
          .doc(phone)
          .collection('messages')
          .doc(stamp.toString())
          .set(
        {
          'msg': message.text,
          'stamp': stamp,
          'img': null,
          'time': DateTime.now(),
        },
      );
      message.clear();
    }
  }

  @override
  void initState() {
    _auth.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Flexible(
            child: CustomField(
              focus: node,
              hint: 'Type a message...',
              controller: message,
            ),
          ),
          IconButton(
            onPressed: sendMsg,
            icon: Icon(
              Icons.send,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

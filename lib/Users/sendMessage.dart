import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/infoProvider.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final bool fromExpert;
  final String? phone;
  final String? name;
  const Message({
    Key? key,
    this.fromExpert = false,
    this.phone,
    this.name,
  }) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final Auth _auth = Auth();
  final DataStore _dStore = DataStore();
  TextEditingController message = TextEditingController();
  FocusNode node = FocusNode();

  Future<void> sendMsg() async {
    String? phone = widget.fromExpert ? widget.phone : InfoProvider.phone;
    // await _dStore.checkInfo(phone);

    String? name =widget.fromExpert ? widget.name : InfoProvider.name;

    if (message.text.isNotEmpty) {
      node.unfocus();
      phone = widget.fromExpert ? widget.phone : InfoProvider.phone;
      int stamp = DateTime.now().microsecondsSinceEpoch;

      var content = {
        'msg': message.text,
        'stamp': stamp,
        'img': '',
        'time': DateTime.now(),
        'from': widget.fromExpert ? InfoProvider.phone : phone,
        'name': widget.fromExpert ? widget.name : name,
        'student': phone,
      };

      FirebaseFirestore.instance
          .collection('messages')
          .doc(phone)
          .collection('messages')
          .doc(stamp.toString())
          .set(content);

      FirebaseFirestore.instance.collection('order').doc(phone).set(content);

      message.clear();
    }
  }

  @override
  void initState() {
    _auth.init();
    _dStore.init();
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
            icon: const Icon(
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
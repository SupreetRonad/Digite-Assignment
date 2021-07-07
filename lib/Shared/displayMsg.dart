import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayMsg extends StatelessWidget {
  final bool fromMe;
  final String msg;
  final Timestamp time;
  const DisplayMsg(
      {Key? key, required this.fromMe, required this.msg, required this.time})
      : super(key: key);

  String formatTime() {
    DateTime date = time.toDate();
    int hour = date.hour > 12 ? date.hour - 12 : date.hour;
    int minutes = date.minute;

    String hh = date.hour > 12 ? 'pm' : 'am';

    return '$hour : $minutes ' + hh;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: fromMe ? Colors.grey[200] : Colors.blue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment:
                fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(msg),
              const SizedBox(
                height: 5,
              ),
              Text(
                formatTime(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

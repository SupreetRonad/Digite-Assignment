import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

class DisplayMsg extends StatelessWidget {
  final bool fromMe;
  final String msg;
  final String img;
  final Timestamp time;
  const DisplayMsg({
    Key? key,
    required this.fromMe,
    required this.msg,
    required this.time,
    required this.img,
  }) : super(key: key);

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
              img.isNotEmpty ? displayImage() : const SizedBox(),
              msg.isNotEmpty ? Text(msg) : const SizedBox(),
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

  Widget displayImage() {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: SpinKitFadingCircle(
              color: Colors.black54,
              size: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: PinchZoomImage(
              image: Image.network(img),
              zoomedBackgroundColor: Colors.black38,
              hideStatusBarWhileZooming: true,
              onZoomStart: () {
                print('Zoom started');
              },
              onZoomEnd: () {
                print('Zoom finished');
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Utils/firestore.dart';
import 'package:digite_assign/Utils/infoProvider.dart';
import 'package:digite_assign/Utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _image = null;
  final picker = ImagePicker();
  bool uploading = false;

  void _clickPic(bool gallery) async {
    final pickedFile = await picker.getImage(
      source: gallery ? ImageSource.gallery : ImageSource.camera,
      maxHeight: 600,
      maxWidth: 600,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (builder) {
        return SizedBox(
          height: 50,
          width: 150,
          child: SizedBox(
            height: 50,
            width: 150,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _clickPic(true);
                    },
                    icon: Icon(Icons.drive_folder_upload_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _clickPic(false);
                    },
                    icon: Icon(Icons.camera_alt_outlined),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> _uploadPic() async {
    if (_image == null) {
      return "";
    }
    setState(() {
      uploading = true;
    });

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    String uploadName = DateTime.now().toString() + InfoProvider.phone;

    await storage.ref('Images/$uploadName.png').putFile(_image!);

    String imageUrl =
        await storage.ref('Images/$uploadName.png').getDownloadURL();

    return imageUrl;
  }

  Future<void> sendMsg() async {
    String imgUrl = await _uploadPic();

    String? phone = widget.fromExpert ? widget.phone : InfoProvider.phone;

    String? name = widget.fromExpert ? widget.name : InfoProvider.name;

    if (message.text.isNotEmpty || _image != null) {
      setState(() {
        _image = null;
        uploading = false;
      });
      node.unfocus();
      phone = widget.fromExpert ? widget.phone : InfoProvider.phone;
      int stamp = DateTime.now().microsecondsSinceEpoch;

      var content = {
        'msg': message.text,
        'stamp': stamp,
        'img': imgUrl,
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
    } else {
      log('message');
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
    return Column(
      children: [
        displayImage(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              IconButton(
                onPressed: showOptions,
                icon: const Icon(
                  Icons.image_rounded,
                  color: Colors.black54,
                  size: 30,
                ),
              ),
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
        ),
      ],
    );
  }

  Widget displayImage() {
    if (_image != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 80,
        child: Card(
          color: Colors.grey[100],
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
                const Spacer(),
                uploading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SpinKitFadingCircle(
                          color: Colors.black54,
                          size: 20,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black54,
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}

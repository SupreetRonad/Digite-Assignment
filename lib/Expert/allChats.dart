import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digite_assign/Shared/customWidgets.dart';
import 'package:digite_assign/Users/homeScreen.dart';
import 'package:digite_assign/Users/menu.dart';
import 'package:flutter/material.dart';

class AllChats extends StatefulWidget {
  const AllChats({Key? key}) : super(key: key);

  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  void menu() {
    showDialog(
      context: context,
      builder: (builder) {
        return const Menu();
      },
    );
  }

  String formatTime(Timestamp time) {
    DateTime date = time.toDate();
    int hour = date.hour > 12 ? date.hour - 12 : date.hour;
    int minutes = date.minute;

    String hh = date.hour > 12 ? 'pm' : 'am';

    return '$hour : $minutes ' + hh;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All queries',
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: menu,
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('order')
            .orderBy('stamp', descending: true)
            .snapshots(),
        builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          return chatList(snapshot);
        },
      ),
    );
  }

  Widget chatList(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<QueryDocumentSnapshot<Object?>> list = snapshot.data!.docs;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return chatCard(list[index].data());
      },
    );
  }

  Widget chatCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => HomeScreen(
              head: chatHead(data['name'] ?? 'Name', data['student']),
              expert: true,
              phone: data['student'],
              name: data['name'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  data['name'] ?? 'Name',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                Text(
                  formatTime(data['time']),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            data['img'].isNotEmpty
                ? imageAttach
                : Text(
                    data['msg'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget chatHead(String name, String phone) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            phone,
            style: TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      );

  final Widget imageAttach = Row(
    children: [
      const Icon(
        Icons.image_rounded,
        color: Colors.black54,
        size: 17,
      ),
      const SizedBox(
        width: 5,
      ),
      const Text(
        'Image attachment',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
        ),
      ),
    ],
  );
}

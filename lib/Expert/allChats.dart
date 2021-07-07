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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All queries',
              style: TextStyle(
                color: Colors.black,
              ),
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
                    color: Colors.black,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(
            right: 5,
          ),
          primary: Colors.white,
          elevation: 5,
          shadowColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => HomeScreen(
                head: Row(
                  children: [
                    backButton(),
                    const SizedBox(
                      width: 5,
                    ),
                    chatHead(data['name'] ?? 'Name', data['student']),
                  ],
                ),
                expert: true,
                phone: data['student'],
                name: data['name'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Image.asset(
                'assets/images/student.png',
                height: 50,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          data['name'] ?? 'Name',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget backButton() => TextButton(
        onPressed: () => Navigator.pop(context),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            Image.asset(
              'assets/images/student.png',
              height: 50,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );

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

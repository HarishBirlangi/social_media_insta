import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_insta/pages/home_page.dart';
import 'package:social_media_insta/widgets/header_widget.dart';

import '../widgets/post_widget.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  bool loading = false;
  List<Post> postsList = [];
  int countPost = 0;

  @override
  void initState() {
    getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerWidget(
        context,
        isAppTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: postsList,
        ),
      ),
    );
  }

  Future getAllPosts() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot<Map<String, dynamic>> snapShot = await postDataReference
        .doc('107116537233489186704')
        .collection('usersPosts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      loading = false;
      countPost = snapShot.docs.length;
      postsList = snapShot.docs
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
          .toList();
    });
  }
}

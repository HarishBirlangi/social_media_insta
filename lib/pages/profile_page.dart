import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_insta/models/user.dart';
import 'package:social_media_insta/pages/edit_profile_page.dart';
import 'package:social_media_insta/pages/home_page.dart';
import 'package:social_media_insta/widgets/header_widget.dart';
import 'package:social_media_insta/widgets/post_tile_widget.dart';

import '../widgets/post_widget.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser.id;
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];
  String postOrientation = 'list';

  @override
  void initState() {
    getAllProfilePosts();
    super.initState();
  }

  createProfileView() {
    return FutureBuilder(
      future: userReference.doc(widget.userId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        UserDetails userInfo = UserDetails.fromDocument(dataSnapshot.data!);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(userInfo.url),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            createColumns("Posts", 0),
                            createColumns("Followers", 0),
                            createColumns("Following", 0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            createButton(),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    userInfo.userName,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userInfo.profileName,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userInfo.bio,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  createColumns(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userId;
    if (ownProfile) {
      return createButtonWithTitle("Edit Profile", editProfile);
    }
  }

  createButtonWithTitle(String title, Function buttonAction) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(200),
          alignment: Alignment.center,
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              side: BorderSide(color: Colors.grey)),
        ),
        onPressed: () {
          editProfile();
        },
        child: Text(
          title,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  editProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditProfilePage(currentUserId: currentOnlineUserId),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerWidget(context, strTitle: "Profile"),
      body: ListView(
        children: [
          createProfileView(),
          const Divider(),
          createListAndGridPostOrientation(),
          const Divider(),
          displayProfilePost(),
        ],
      ),
    );
  }

  displayProfilePost() {
    if (loading == true) {
      const CircularProgressIndicator();
    } else if (postsList.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Icon(
              Icons.photo_library,
              color: Colors.grey,
              size: 200,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              "No posts",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );
    } else if (postOrientation == 'grid') {
      List<GridTile> gridTileList = [];
      postsList.forEach((eachPost) {
        gridTileList.add(GridTile(
            child: PostTile(
          post: eachPost,
        )));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: gridTileList,
      );
    } else if (postOrientation == 'list') {
      return Column(
        children: postsList,
      );
    }
  }

  Future getAllProfilePosts() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot<Map<String, dynamic>> snapShot = await postDataReference
        .doc(widget.userId)
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

  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: () => setOrientation("grid"),
            icon: Icon(
              Icons.grid_on,
              color: postOrientation == 'grid'
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            )),
        IconButton(
            onPressed: () => setOrientation("list"),
            icon: Icon(
              Icons.list,
              color: postOrientation == 'list'
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            )),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      postOrientation = orientation;
    });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_insta/models/user.dart';
import 'package:social_media_insta/pages/edit_profile_page.dart';
import 'package:social_media_insta/pages/home_page.dart';
import 'package:social_media_insta/widgets/header_widget.dart';

class ProfilePage extends StatefulWidget {
  String userId;
  ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser.id;
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
        children: [createProfileView()],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_insta/models/user.dart';
import 'package:social_media_insta/pages/home_page.dart';
import 'package:social_media_insta/widgets/progress_widget.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserId;
  const EditProfilePage({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController =
      TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  late UserDetails userInfo;
  bool profileNameValid = true;
  bool bioValid = true;

  @override
  void initState() {
    super.initState();
    getAndShowUserInformation();
  }

  void getAndShowUserInformation() async {
    setState(() {
      loading = true;
    });
    DocumentSnapshot userReferenceSnapshot =
        await userReference.doc(widget.currentUserId).get();
    userInfo = UserDetails.fromDocument(userReferenceSnapshot);

    profileNameTextEditingController.text = userInfo.profileName;
    bioTextEditingController.text = userInfo.bio;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done, color: Colors.white, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: loading
          ? Center(
              child: circularProgress(),
            )
          : ListView(
              children: [
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 60,
                  child: ClipOval(
                    child: Image.network(
                      userInfo.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      editProfileNameWidget(),
                      const SizedBox(height: 12),
                      editBioWidget(),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => updateProfileData(),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: const Text("Update",
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => logoutUser(),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        backgroundColor: Colors.red,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: const Text("Logout",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  editProfileNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profile Name",
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        TextField(
          style: const TextStyle(color: Colors.white),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
              hintText: "Profile Name",
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintStyle: const TextStyle(color: Colors.white),
              errorText:
                  profileNameValid ? null : "Profile name is very short"),
        ),
      ],
    );
  }

  editBioWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bio",
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.start,
        ),
        TextField(
          style: const TextStyle(color: Colors.white),
          controller: bioTextEditingController,
          decoration: InputDecoration(
            hintText: "Write bio here",
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintStyle: const TextStyle(color: Colors.white),
            errorText: bioValid ? null : "Bio text is very long",
          ),
        ),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      profileNameTextEditingController.text.trim().length < 3 ||
              profileNameTextEditingController.text.isEmpty
          ? profileNameValid = false
          : profileNameValid = true;
      bioTextEditingController.text.trim().length > 110
          ? bioValid = false
          : bioValid = true;
    });
    if (profileNameValid && bioValid) {
      userReference.doc(widget.currentUserId).update({
        "profileName": profileNameTextEditingController.text,
        "bio": bioTextEditingController.text,
      });
    }

    SnackBar successSnackBar = const SnackBar(
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      content: Text(
        "Profile has been updated successfully",
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
    ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
  }

  logoutUser() async {
    await GoogleSignIn().signOut();
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
  }
}

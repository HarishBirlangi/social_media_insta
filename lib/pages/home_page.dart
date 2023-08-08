import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_insta/pages/create_account_page.dart';
import 'package:social_media_insta/pages/notification_page.dart';
import 'package:social_media_insta/pages/profile_page.dart';
import 'package:social_media_insta/pages/search_page.dart';
import 'package:social_media_insta/pages/timeline_page.dart';
import 'package:social_media_insta/pages/upload_page.dart';

import '../models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isUserLogin = false;
  GoogleSignIn googleSignIn = GoogleSignIn();
  late PageController pageController;
  int getPageIndex = 0;
  CollectionReference<Map<String, dynamic>> userReference =
      FirebaseFirestore.instance.collection("users");

  DateTime timeStamp = DateTime.now();
  late User currentUser;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((googleSignInAccount) {
      print(googleSignInAccount.toString());
      controlSignIn(googleSignInAccount);
    }, onError: (gError) {
      print("Error message $gError");
    });

    googleSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount!);
    }).catchError((eError) {
      print("Error $eError");
    });
  }

  controlSignIn(GoogleSignInAccount? googleSignInAccount) async {
    if (googleSignInAccount != null) {
      setState(() {
        _isUserLogin = true;
      });
    } else {
      setState(() {
        _isUserLogin = false;
      });
    }
  }

  saveUserInfoToFirestore() async {
    final GoogleSignInAccount? googleCurrentUser = googleSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await userReference.doc(googleCurrentUser?.id).get();

    if (!documentSnapshot.exists) {
      if (!mounted) return;
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CreateAccountPage()));

      userReference.doc(googleCurrentUser?.id).set({
        "id": googleCurrentUser?.id,
        "profileName": googleCurrentUser?.displayName,
        "userName": username,
        "url": googleCurrentUser?.photoUrl,
        "email": googleCurrentUser?.email,
        "bio": "",
        "timestamp": timeStamp,
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  loginUser() {
    googleSignIn.signIn();
  }

  logoutUser() {
    googleSignIn.signOut();
  }

  void whenPageChanges(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  onTapChanges(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isUserLogin) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          TimeLinePage(),
          SearchPage(),
          UploadPage(),
          NotificationPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChanges,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Insta',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                loginUser();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    height: 40,
                    width: 40,
                    image: AssetImage('assets/images/google_icon_image.png'),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    height: 40,
                    width: 200,
                    child: const Text(
                      'Sign in with google',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

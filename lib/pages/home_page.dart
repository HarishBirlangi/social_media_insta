import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isUserLogin = false;
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
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

  loginUser() {
    googleSignIn.signIn();
  }

  logoutUser() {
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (_isUserLogin) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }

  Widget buildHomeScreen() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          logoutUser();
        },
        child: const Text("Logout"),
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

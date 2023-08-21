import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_insta/models/user.dart';
import 'package:social_media_insta/pages/home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResult;

  emptyTextFormField() {
    searchTextEditingController.clear();
  }

  controlSearching(String searchValue) async {
    Future<QuerySnapshot> allUsers = userReference
        .where("profileName", isGreaterThanOrEqualTo: searchValue)
        .get();
    setState(() {
      futureSearchResult = allUsers;
    });
  }

  searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        style: const TextStyle(fontSize: 18, color: Colors.white),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          fillColor: Colors.black,
          hintText: 'Search here',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          prefixIcon: const Icon(
            Icons.person_pin,
            size: 30,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            onPressed: emptyTextFormField,
            icon: const Icon(
              Icons.clear,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        onFieldSubmitted: (value) {
          controlSearching(searchTextEditingController.value.text);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      body: futureSearchResult == null
          ? displayNoResultsScreen()
          : displayFoundUsersScreen(),
    );
  }

  Container displayNoResultsScreen() {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      // color: Colors.white54,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: const [
            Icon(
              Icons.group,
              size: 80,
              color: Colors.grey,
            ),
            Text(
              'Search Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayFoundUsersScreen() {
    return FutureBuilder(
      future: futureSearchResult,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          List<UserResult> searchUserResult = [];
          snapshot.data!.docs.forEach((element) {
            UserDetails eachUserDetails = UserDetails.fromDocument(element);
            UserResult userResult =
                UserResult(eachUserDetails: eachUserDetails);
            searchUserResult.add(userResult);
          });

          return ListView(
            children: searchUserResult,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UserResult extends StatelessWidget {
  final UserDetails eachUserDetails;
  const UserResult({Key? key, required this.eachUserDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage:
                      CachedNetworkImageProvider(eachUserDetails.url),
                ),
                title: Text(
                  eachUserDetails.profileName,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  eachUserDetails.userName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

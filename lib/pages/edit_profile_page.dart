import 'package:flutter/material.dart';
import 'package:social_media_insta/models/user.dart';

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
  Widget build(BuildContext context) {
    return Container();
  }
}

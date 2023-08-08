import 'package:flutter/material.dart';
import 'package:social_media_insta/widgets/header_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerWidget(context, strTitle: "Notifications"),
    );
  }
}

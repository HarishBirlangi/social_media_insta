import 'package:flutter/material.dart';
import 'package:social_media_insta/widgets/header_widget.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerWidget(
        context,
        isAppTitle: true,
      ),
    );
  }
}

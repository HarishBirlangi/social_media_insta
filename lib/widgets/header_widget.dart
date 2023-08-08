import 'package:flutter/material.dart';

AppBar headerWidget(
  context, {
  bool isAppTitle = false,
  String strTitle = 'Insta',
  disappearedBackButton = false,
}) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      strTitle,
      style: TextStyle(
        color: Colors.white,
        fontSize: isAppTitle ? 35 : 22,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.secondary,
  );
}

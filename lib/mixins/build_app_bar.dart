import 'package:flutter/material.dart';

mixin BuildAppBar {
  AppBar buildAppBar(
      {required String title,
      String? subtitle,
      List<Widget> actions = const []}) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: actions,
      bottom: subtitle != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(20.0),
              child: Text(subtitle, style: TextStyle(fontSize: 16)),
            )
          : null,
    );
  }
}

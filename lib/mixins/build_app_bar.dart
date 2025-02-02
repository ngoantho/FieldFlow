import 'package:flutter/material.dart';

mixin BuildAppBar {
  AppBar buildAppBar({required String title}) {
    return AppBar(title: Text(title), centerTitle: true,);
  }
}

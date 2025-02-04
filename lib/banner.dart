import 'package:flutter/material.dart';

class FieldFlowBanner {
  static show(BuildContext context, String text,
      [List<Widget> actions = const []]) {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(), // fix error
          ...actions
        ]));
  }

  static hide(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
  }
}
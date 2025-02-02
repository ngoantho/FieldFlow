import 'package:flutter/material.dart';

mixin DialogConfirmMixin {
  Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title
  }) async {
    return await showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: Text(title),
        actions: [
          ElevatedButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: Text('Cancel')),
          FilledButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: Text('Confirm'))
        ],
      );
    });
  }
}
import 'package:flutter/material.dart';
import 'package:students_guide/utils/dialogs/generic_dialog.dart';

Future<bool> showSignoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: const Text('Sign Out'),
    content: const Text('Are you sure you want to sign out?'),
    optionBuilder: () => {
      'Yes': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}

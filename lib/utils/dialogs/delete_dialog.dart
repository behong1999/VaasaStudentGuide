import 'package:flutter/material.dart';
import 'package:students_guide/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: const Text('Delete'),
    content: const Text('Are you sure you want to delete this article?'),
    optionBuilder: () => {
      'Yes': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}

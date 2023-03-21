import 'package:flutter/material.dart';
import 'package:students_guide/utils/dialogs/generic_dialog.dart';

Future showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
      context: context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.warning_amber, color: Colors.amber),
          Text('Error'),
          Icon(Icons.warning_amber, color: Colors.amber),
        ],
      ),
      content: Text(text),
      optionBuilder: () => {'OK': null});
}

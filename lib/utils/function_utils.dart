import 'package:deltanews/screens/widgets/costum_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getTime(String timestamp) {
  DateTime date = DateTime.parse(timestamp);

  String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id').format(date);
  return formattedDate;
}

String capitalizeEachWord(String input) {
  if (input.isEmpty) return input;

  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

// extension EmailValidator on String {
//   bool isValidEmail() {
//     return RegExp(
//             r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
//         .hasMatch(this);
//   }
// }

bool isValidEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  return regExp.hasMatch(em);
}

Future<bool> showCustomDialog(BuildContext context, String title,
    String description, String text, void Function() onPressed,
    {bool? isError = false}) async {
  return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBoxWithButton(
            title: title,
            description: description,
            confirmTextButton: text,
            onPressed: onPressed,
            isError: isError!,
          );
        },
      ) ??
      false;
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToastWidget(String message, Color color) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: color,
    fontSize: 16.0,
  );
}





























  // Future<bool?> showToast(String message, Color color) {
  //   return Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_LONG,
  //     backgroundColor: color,
  //     fontSize: 16.0,
  //   );
  // }


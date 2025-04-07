import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message {
  static void show(
      {msg = "Done",
      toastLength = Toast.LENGTH_SHORT,
      gravity = ToastGravity.BOTTOM,
      timeInSecForIosWeb = 1,
      backgroundColor = Colors.red,
      textColor = Colors.white,
      fontSize = 16.0}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// function to show toast message with extra parametars
void show_toast_msg(String msg, ToastGravity grav, Color bg_col, Color txt_col) {

  print("called toast message function !!");

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: grav, // or ToastGravity.TOP / CENTER
      timeInSecForIosWeb: 1,
      backgroundColor: bg_col,
      textColor: txt_col, // Color.fromARGB(255, 241, 241, 241)
      fontSize: 16.0,
    );
  });

}

// funtion to show toast message with just a string parametar
void show_toast_msg_norm(String msg) {

  print("called toast message normal function !!");

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER, // or ToastGravity.TOP / CENTER
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Color.fromARGB(255, 241, 241, 241), // Color.fromARGB(255, 241, 241, 241)
      fontSize: 16.0,
    );
  });

}
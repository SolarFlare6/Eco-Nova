import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

// check internet connection fn
Future<bool> hasInternetAccess() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

// check login info
Future<bool> loginUser(String username, String password) async {
  final url = Uri.parse('http://10.0.2.2:3000/login'); // Use IP if on real device

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['token'] != null) {
        print('Login successful! Token: ${data['token']}');
        // Save the token if needed
        return true;
      } else {
        print('Login failed: Invalid credentials');
        return false;
      }
    } else {
      print('Login failed: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Login error: $e');
    return false;
  }
}

// register user function
Future<bool> registerUser(String username, String password) async {
  final url = Uri.parse('http://10.0.2.2:3000/register'); // replace with local IP on real device

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == true;
    } else {
      print('Registration failed with status: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Registration error: $e');
    return false;
  }
}

// get token when login
Future<String> loginUser_return_token(String username, String password) async {
  final url = Uri.parse('http://10.0.2.2:3000/login'); // Use IP for real device

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // Return the token
    } else {
      print('Login failed with status: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    print('Login error: $e');
    return '';
  }
}

String limitString(String text, int maxLength) {
  return text.length > maxLength
      ? text.substring(0, maxLength) + '...'
      : text;
}

String insertNewlineAfterIndex(String text, int index) {
  if (index >= text.length) return text;
  return text.substring(0, index) + '-\n' + text.substring(index);
}

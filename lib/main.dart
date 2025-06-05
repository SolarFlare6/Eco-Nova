import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page_m.dart';
import 'login_page.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const ExampleApplication());

class ExampleApplication extends StatefulWidget {
  const ExampleApplication({Key? key}) : super(key: key);

  @override
  State<ExampleApplication> createState() => _ExampleApplicationState();
}

class _ExampleApplicationState extends State<ExampleApplication> {

  // vars
  late Future<bool> _isLoggedInFuture;
  String username = '';
  String pass = '';
  String token = '';


  // check userCredentials fn
  Future<bool> checkUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    username = prefs.getString('username') ?? '';
    pass = prefs.getString('passw') ?? '';
    token = prefs.getString('token') ?? '';

    print("User loaded: $username");

    if (username == "Debug") return username.isNotEmpty && pass.isNotEmpty;
    else  {
      return username.isNotEmpty && pass.isNotEmpty && token.isNotEmpty;
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoggedInFuture = checkUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedInFuture,
      builder: (context, snapshot) {

        // Wait until the future is resolved
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Navigate based on login check
        if (snapshot.data == true) {
          return MaterialApp(home: MainPage(usrName: username, token: token,));
        } else {
          return MaterialApp(home: LoginPage_view());
        }
      },
    );
  }
}

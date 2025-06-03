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

  // check userCredentials fn
  Future<bool> checkUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    username = prefs.getString('username') ?? '';
    pass = prefs.getString('passw') ?? '';

    print("User loaded: $username");

    return username.isNotEmpty && pass.isNotEmpty;
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
          return MaterialApp(home: MainPage(usrName: username));
        } else {
          return MaterialApp(home: LoginPage_view());
        }
      },
    );
  }
}

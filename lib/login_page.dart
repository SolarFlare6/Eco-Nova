import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage_view extends StatefulWidget {
  const LoginPage_view({Key? key}) : super(key: key);

  @override
  State<LoginPage_view> createState() => _LoginPage_viewState();
}

class _LoginPage_viewState extends State<LoginPage_view> {

  // text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // some vars
  String entered_username = '';
  String entered_pass = '';

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

  // save user data localy
  Future<void> _saveUserDataLocaly() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', entered_username);
    await prefs.setString('passw', entered_pass);

  }

  // login fn
  void user_login() async {

    if (entered_username.isNotEmpty && entered_pass.isNotEmpty) {

      bool cred_true = await loginUser(entered_username, entered_pass);

      if (cred_true) {
        print('with creadentials_var Credentials are correct welcome !!!');
        _saveUserDataLocaly();
        show_toast_msg("Login succesful", ToastGravity.BOTTOM, Color.fromARGB(255, 227, 242, 223), Colors.black);
        Restart.restartApp();
      } else {
        show_toast_msg("Login failed", ToastGravity.BOTTOM, Colors.black, Colors.white);
      }

    } else {
      show_toast_msg_norm("Please enter credentials");
    }

    // for debug purposes
    if (entered_username == 'Debug' && entered_pass == '12345') {
      print('with debug info Credentials are correct welcome !!!');
      //send_user_data_to_server();
      _saveUserDataLocaly();
      Restart.restartApp();
    }
  }

  // function to show toast message with extra parametars
  void show_toast_msg(String msg, ToastGravity grav, Color bg_col, Color txt_col) {

    print("called toast message function !!");

    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: grav, // or ToastGravity.TOP / CENTER
      timeInSecForIosWeb: 1,
      backgroundColor: bg_col,
      textColor: txt_col, // Color.fromARGB(255, 241, 241, 241)
      fontSize: 16.0,
    );

  }

  // funtion to show toast message with just a string parametar
  void show_toast_msg_norm(String msg) {

    print("called toast message function !!");

    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // or ToastGravity.TOP / CENTER
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Color.fromARGB(255, 241, 241, 241), // Color.fromARGB(255, 241, 241, 241)
      fontSize: 16.0,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Spacer(),

              // Username Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Username",
                  style: GoogleFonts.gabarito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 19),

              // Username Input
              Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 13),


              // Password Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: GoogleFonts.gabarito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 19),

              // Password Input
              Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),

              Spacer(),

              // Log In Button
              ElevatedButton(
                onPressed: () {
                  // login logic
                  print("Entered credential are : \n" + _usernameController.text + "\n" + _passwordController.text);
                  entered_username = _usernameController.text;
                  entered_pass = _passwordController.text;
                  user_login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE9F6E7),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'Log In',
                  style: GoogleFonts.gabarito(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 21),

              GestureDetector(
                onTap: () {
                  print("Tapped on dont have account button!!!");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupPage_view(),
                    ),
                  );
                },
                child: Text(
                  "I don’t have an account",
                  style: GoogleFonts.gabarito(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

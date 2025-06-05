import 'package:Earth_nova/main_page_m.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'quick_fn.dart';

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
  String token = '';



  // save user data localy
  Future<void> _saveUserDataLocaly() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', entered_username);
    await prefs.setString('passw', entered_pass);
    await prefs.setString('token', token);
  }

  // login fn
  void user_login() async {

    if (entered_username.isNotEmpty && entered_pass.isNotEmpty && entered_username != "Debug") {

      bool cred_true = await loginUser(entered_username, entered_pass);
      token = await loginUser_return_token(entered_username, entered_pass);

      if (cred_true) {
        print('with creadentials_var Credentials are correct welcome !!!');
        _saveUserDataLocaly();
        show_toast_msg("Login succesful", ToastGravity.CENTER, Color.fromARGB(255, 227, 242, 223), Colors.black);
        Restart.restartApp();
      } else {
        show_toast_msg("Login failed", ToastGravity.CENTER, Colors.black, Colors.white);
      }

    } else {
      if (entered_username != "Debug") show_toast_msg_norm("Please enter credentials");
    }

    // for debug purposes
    if (entered_username == 'Debug' && entered_pass == '12345') {
      print('with debug info Credentials are correct welcome !!!');
      _saveUserDataLocaly();
      show_toast_msg_norm("Logged in with debug credentials");
      Restart.restartApp();
    }
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

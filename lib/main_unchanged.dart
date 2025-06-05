import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page_m.dart';
import 'login_page.dart';

void main() => runApp(new ExampleApplication());

// init vars
String username = '';
String pass = '';

// load local user data
Future<void> _loadUserData() async {

  final prefs = await SharedPreferences.getInstance();

  // check before setting
  if (prefs.containsKey('username')) {
    username = prefs.getString('username')!;
  }
  if (prefs.containsKey('passw')) {
    pass = prefs.getString('passw')!;
  }


  print("LoadUserData function called in main!!");
}

Future<bool> check_user_credentials() async {
  await _loadUserData();
  if (username != '' && pass != '') return true;
  else return false;
}

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _loadUserData();
    if (username != '' && pass != '') {
      return MaterialApp(home: MainPage(usrName: username, token: '',));
    } else {
      return MaterialApp(home: LoginPage_view());
    }
  }
}
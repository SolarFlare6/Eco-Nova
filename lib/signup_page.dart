import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class SignupPage_view extends StatefulWidget {
  const SignupPage_view({Key? key}) : super(key: key);

  @override
  State<SignupPage_view> createState() => _SignupPage_viewState();
}

class _SignupPage_viewState extends State<SignupPage_view> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();

  bool _consentGiven = false;
  File? _profileImage;

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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

  // login function
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
              const SizedBox(height: 40),


              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: _profileImage == null
                    ? Icon(Icons.people, size: 40, color: Colors.black)
                    : ClipOval(
                  child: Image.file(
                    _profileImage!,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              // Profile Image Picker
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: Container(
              //     width: 100,
              //     height: 100,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.grey.shade300,
              //     ),
              //     child: _profileImage == null
              //         ? Icon(Icons.camera_alt, size: 40, color: Colors.black)
              //         : ClipOval(
              //       child: Image.file(
              //         _profileImage!,
              //         fit: BoxFit.cover,
              //         width: 100,
              //         height: 100,
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 40),

              _buildTextField(_usernameController, "Username"),
              const SizedBox(height: 16),

              _buildTextField(_passwordController, "Password", obscure: true),
              const SizedBox(height: 16),

              // _buildTextField(_emailController, "E-mail"),
              // const SizedBox(height: 16),

              // DOB Picker Field
              // GestureDetector(
              //   onTap: _pickDate,
              //   child: AbsorbPointer(
              //     child: _buildTextField(_dobController, "Date of birth"),
              //   ),
              // ),

              //const SizedBox(height: 16),

              Spacer(),

              Row(
                children: [
                  Checkbox(
                    value: _consentGiven,
                    onChanged: (value) {
                      setState(() {
                        _consentGiven = value ?? false;
                      });
                    },
                  ),
                  Text("I consent to the EULA",
                      style: GoogleFonts.gabarito(fontSize: 15))
                ],
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _consentGiven ? () async {
                  print('Register button pressed !!');

                  var usern = _usernameController.text;
                  var pass = _passwordController.text;

                  if (usern.isNotEmpty && pass.isNotEmpty) {

                    print("Entered credentials for register are :\n" + "usrname : "+ usern + "\npass : "+ pass);

                    if (await loginUser(usern, pass)) {
                      print("Login credentials already exist !!");
                      show_toast_msg_norm("Account already exists");
                    } else {

                      // if the credentials arent duplicate register the user
                      bool registered = await registerUser(usern, pass);

                      if (registered) {
                        print("Registration succesfull.");
                        show_toast_msg("Registration successful", ToastGravity.BOTTOM, Color.fromARGB(255, 227, 242, 223), Colors.black);
                        Navigator.pop(context);
                      } else {
                        print("Registration failed !!!");
                        show_toast_msg("Registration failed", ToastGravity.BOTTOM, Colors.redAccent, Colors.black);
                      }
                    }
                  } else {
                    print("Enter valid credentials !!!!");
                    show_toast_msg_norm("Enter valid credentials");
                  }

                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9F6E7),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Create account',
                  style: GoogleFonts.gabarito(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.gabarito(fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

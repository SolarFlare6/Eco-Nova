import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

              // Profile Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.black)
                      : ClipOval(
                    child: Image.file(
                      _profileImage!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              _buildTextField(_usernameController, "Username"),
              const SizedBox(height: 16),

              _buildTextField(_passwordController, "Password", obscure: true),
              const SizedBox(height: 16),

              _buildTextField(_emailController, "E-mail"),
              const SizedBox(height: 16),

              // DOB Picker Field
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: _buildTextField(_dobController, "Date of birth"),
                ),
              ),

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
                onPressed: _consentGiven ? () {} : null,
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

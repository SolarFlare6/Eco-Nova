import 'package:Earth_nova/main_page_m.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class PostPage extends StatefulWidget {

  // vars for the page to be loaded
  final String usern_post;
  final String title;
  final String content;
  final String img_path;


  const PostPage({Key? key,
    required this.usern_post,
    required this.title,
    required this.content,
    required this.img_path,
  }) : super(key: key);

  @override
  State<PostPage> createState() => PostPageState();
}

class PostPageState extends State<PostPage> {

  // vars vo ui elements
  // bool heart_btn_filled = false;
  // bool saved_btn_filled = false;
  // IconData heart_ico_set = Icons.favorite_border_rounded;
  // IconData save_ico_set = Icons.bookmark_border_rounded;
  //
  //
  // // used to set the appearence of the like button initially
  // void set_liked() {
  //   print('set like fn called!!');
  //
  //   setState(() {
  //     if (heart_btn_filled) {
  //       heart_ico_set = Icons.favorite_rounded;
  //       heart_btn_filled = true;
  //     } else {
  //       heart_ico_set = Icons.favorite_border_rounded;
  //       heart_btn_filled = false;
  //     }
  //   });
  // }
  //
  // // used for controlling the like btn
  // void change_liked() {
  //   setState(() {
  //     if (heart_btn_filled) {
  //       heart_ico_set = Icons.favorite_border_rounded;
  //       heart_btn_filled = false;
  //     } else {
  //       heart_ico_set = Icons.favorite_rounded;
  //       heart_btn_filled = true;
  //     }
  //   });
  // }
  //
  // // used to set the save icon appearence initially
  // void set_saved() {
  //   print('set saved fn called!!');
  //
  //   setState(() {
  //     if (saved_btn_filled) {
  //       save_ico_set = Icons.bookmark_rounded;
  //       saved_btn_filled = true;
  //     } else {
  //       save_ico_set = Icons.bookmark_border_rounded;
  //       saved_btn_filled = false;
  //     }
  //   });
  // }
  //
  // // controlls the save icon btn
  // void change_saved() {
  //   setState(() {
  //     if (saved_btn_filled) {
  //       save_ico_set = Icons.bookmark_border_rounded;
  //       saved_btn_filled = false;
  //     } else {
  //       save_ico_set = Icons.bookmark_rounded;
  //       saved_btn_filled = true;
  //     }
  //   });
  // }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // setup the heart var
    // heart_btn_filled = widget.liked;
    // saved_btn_filled = widget.saved;
    //
    // set_liked();
    // set_saved();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Post Image and banner layout
            Stack(
              children: [

                // Post Image with Rounded Corners
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0),
                    bottom: Radius.circular(16),
                  ),
                  child: Image.asset(
                    widget.img_path, // Replace with network image if needed
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),

                // Gradient Overlay at the Top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80, // Adjust height based on design
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(0),
                        bottom: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Username and Close Button Row
                Positioned(
                  top: 30,
                  left: 25,
                  right: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Avatar & Username
                      Row(
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.supervised_user_circle_rounded,
                              color: Color.fromARGB(255, 227, 242, 223),
                              size: 45,
                            ),
                            backgroundColor: Colors.black,
                            radius: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.usern_post,
                            style: GoogleFonts.gabarito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Close Button
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Post Title and Icons
            Text(
              widget.title,
              style: GoogleFonts.gabarito(
                fontSize: 30,
                fontWeight: FontWeight.bold,

              ),
            ),

            SizedBox(height: 25),

            // Post Content
            Container(
              width: 350,
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 35),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView(
                children: [
                  Text(
                    widget.content,
                    style: GoogleFonts.gabarito(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}


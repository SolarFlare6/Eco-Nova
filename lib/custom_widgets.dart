import 'package:Earth_nova/main_page_m.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'post_page.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';


// title bar widget
class title_bar_widget extends StatelessWidget {

  final VoidCallback openRewards;
  final VoidCallback openUserAcc;

  title_bar_widget({

    required this.openRewards,
    required this.openUserAcc,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          SizedBox(width: 24), // Left padding

          // user account quick access
          GestureDetector(
            onTap: () {
              print('Open user account page !!');
              openUserAcc();
            },
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.supervised_user_circle_rounded,
                    color: Color.fromARGB(255, 227, 242, 223),
                    size: 45,
                  ),
                  backgroundColor: Colors.black,
                  radius: 24,
                ),

                SizedBox(width: 10), // Space between avatar and text

                Text(
                  username,
                  style: GoogleFonts.gabarito(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Spacer(), // Pushes the IconButton to the right

          Padding(
            padding: EdgeInsets.only(right: 16), // Adjusts offset from screen edge
            child: IconButton(
              icon: Icon(Symbols.trophy_rounded, size: 31),
              onPressed: () {
                openRewards();
              },
            ),
          ),
        ],
      ),
    );
  }

}

// rewards element
class RewardItem extends StatelessWidget {
  final String imageUrl; // You can pass asset path or network image
  final String points;
  final Color txt_col;
  final Color gradient_col;
  final String item_name;

  const RewardItem({
    required this.imageUrl,
    required this.points,
    required this.gradient_col,
    required this.txt_col,
    required this.item_name,
    Key? key,
  }) : super(key: key);

  // Function to Show the Popup menu
  void showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 241, 241), // Light green background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // title for overlay menu
                Row(
                  children: [

                    SizedBox(width: 10,),

                    Image(
                      image: AssetImage('assets/rank_icon.png'),
                      width: 32,
                      height: 32,
                    ),

                    SizedBox(width: 10),

                    Text(
                      item_name,
                      style: GoogleFonts.gabarito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 25),

                // image and points layout
                Container(
                  height: 280,
                  width: 260,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Gradient and Points Overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  gradient_col.withOpacity(0.5),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/leaf_icon.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  points,
                                  style: GoogleFonts.gabarito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: txt_col,
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                SizedBox(height: 25),

                // redeem btn
                ElevatedButton(
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Color.fromARGB(255, 227, 242, 223),
                  //   foregroundColor: Colors.white,
                  //
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  // ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 227, 242, 223)),
                      foregroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 227, 242, 223)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.black, width: 2)
                            )
                        )
                    ),
                  onPressed: () {
                    print("redeem reward btn pressed!!");
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "Redeem",
                      style: GoogleFonts.gabarito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // close btn
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "Close",
                      style: GoogleFonts.gabarito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped rewards element !!");
        showPopupMenu(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient and Points Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      gradient_col.withOpacity(0.5),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/leaf_icon.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      points,
                      style: GoogleFonts.gabarito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: txt_col,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// rank element widget
class rank_element extends StatelessWidget {

  double widget_width = 330;
  double widget_height = 60;
  String title_label = '';
  IconData widget_icon = Icons.do_not_step;
  String rank_position = "1th";


  rank_element({

    required this.title_label,
    required this.widget_icon,
    required this.rank_position,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget_width,
      height: widget_height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 227, 242, 223), // Light green background
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget_icon, // Change this to match your exact icon
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),

          // Label
          Text(
            title_label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),

          Spacer(),

          const SizedBox(width: 12),

          // Step count increase
          Text(
            rank_position,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 218, 210, 97),
            ),
          ),
        ],
      ),
    );
  }
}

// widget for the overview elements on the homepage
class overview_element_normal extends StatelessWidget {

  double widget_width = 145.5;
  double widget_height = 138;
  String title_label = '';
  ImageProvider<Object> widget_img = AssetImage('assets/leaf_icon.png');
  Color border_color = Color.fromARGB(255, 241, 241, 241);
  Color bg_color = Colors.white;
  int val = 0;


  overview_element_normal({

    required this.title_label,
    required this.val,
    required this.widget_img,
    required this.border_color,
    required this.bg_color,


    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: border_color,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),

        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              child: Column(
                children: <Widget>[
                  // Points overview widgets

                  SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: <Widget>[

                      SizedBox(
                        width: 13,
                      ),

                      Image(
                        image: widget_img,
                        width: 32,
                        height: 32,
                      ),

                      SizedBox(
                        width: 8,
                      ),

                      Text(title_label,
                        style: GoogleFonts.gabarito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: <Widget>[

                      SizedBox(
                        width: 15,
                      ),

                      Text(val.toString(),
                        style: GoogleFonts.gabarito(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
              width: widget_width,
              height: widget_height,
              color: bg_color,
            ),
          ),
        ),
      ),
    );
  }

}

// extended version of the overview elements
class overview_element_normal_ex extends StatelessWidget {

  double widget_width = 145.5;
  double widget_height = 138;
  String title_label = '';
  ImageProvider<Object> widget_img = AssetImage('assets/leaf_icon.png');
  Color border_color = Color.fromARGB(255, 241, 241, 241);
  Color bg_color = Colors.white;
  String val = "";


  overview_element_normal_ex({

    required this.title_label,
    required this.val,
    required this.widget_img,
    required this.border_color,
    required this.bg_color,


    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: border_color,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),

        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              child: Column(
                children: <Widget>[
                  // Points overview widgets

                  SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: <Widget>[

                      SizedBox(
                        width: 13,
                      ),

                      Image(
                        image: widget_img,
                        width: 32,
                        height: 32,
                      ),

                      SizedBox(
                        width: 8,
                      ),

                      Text(title_label,
                        style: GoogleFonts.gabarito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: <Widget>[

                      SizedBox(
                        width: 15,
                      ),

                      Text(val,
                        style: GoogleFonts.gabarito(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
              width: widget_width,
              height: widget_height,
              color: bg_color,
            ),
          ),
        ),
      ),
    );
  }

}

// steps widget or expanded info widget
class action_element_with_expanded_info extends StatelessWidget {

  double widget_width = 330;
  double widget_height = 130;
  String title_label = '';
  double progress = 0.0;
  IconData widget_icon = Icons.do_not_step;
  String added_points = "+10";
  int val = 0;
  int val_goal = 0;
  VoidCallback tap_fn;


  action_element_with_expanded_info({

    required this.title_label,
    required this.widget_width,
    required this.progress,
    required this.widget_icon,
    required this.added_points,
    required this.val,
    required this.val_goal,
    required this.tap_fn,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap_fn,
      child: Container(
        width: widget_width,
        height: widget_height,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Column(
          children: [

            SizedBox(
              height: 12,
            ),

            // icon and label row
            Row(
              children: [
                SizedBox(width: 10,),
                // Icon with background
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[100], // Light green background
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget_icon, // Change this to match your exact icon
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),

                // Label
                Text(
                  title_label,
                  style: GoogleFonts.gabarito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),

            SizedBox(
              height: 11,
            ),

            // row for steps count label, progress bar and added points
            Row(
              children: [
                SizedBox(width: 10,),
                Text(val.toString(),
                  style: GoogleFonts.gabarito(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  width: 6,
                ),

                Text('/'+val_goal.toString(),
                  style: GoogleFonts.gabarito(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(
                  width: 20,
                ),

                // Progress bar
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress, // Value between 0 and 1
                      backgroundColor: Colors.grey[300],
                      color: Colors.greenAccent,
                      minHeight: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // added points label
                Text(
                  added_points,
                  style: GoogleFonts.gabarito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.greenAccent,
                  ),
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }
}

// custom menu with title bar and animation
class action_element_with_progress extends StatelessWidget {

  double widget_width = 330;
  double widget_height = 242;
  String title_label = '';
  double progress = 0.0;
  IconData widget_icon = Icons.do_not_step;
  String added_points = "+10";


  action_element_with_progress({

    required this.title_label,
    required this.widget_width,
    required this.progress,
    required this.widget_icon,
    required this.added_points,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget_width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[100], // Light green background
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget_icon, // Change this to match your exact icon
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),

          // Label
          Text(
            title_label,
            style: GoogleFonts.gabarito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),

          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress, // Value between 0 and 1
                backgroundColor: Colors.grey[300],
                color: Colors.greenAccent,
                minHeight: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Step count increase
          Text(
            added_points,
            style: GoogleFonts.gabarito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class action_element extends StatelessWidget {

  double widget_width = 330;
  double widget_height = 242;
  String title_label = '';
  IconData widget_icon = Icons.do_not_step;
  String added_points = "+10";


  action_element({

    required this.title_label,
    required this.widget_width,
    required this.widget_icon,
    required this.added_points,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget_width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[100], // Light green background
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget_icon, // Change this to match your exact icon
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),

          // Label
          Text(
            title_label,
            style: GoogleFonts.gabarito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),

          Spacer(),

          const SizedBox(width: 12),

          // Step count increase
          Text(
            added_points,
            style: GoogleFonts.gabarito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}

// for steps history element
class step_history_element extends StatelessWidget {

  double widget_width = 330;
  double widget_height = 242;
  String title_label = '';
  IconData widget_icon = Icons.do_not_step;
  String date = '';
  


  step_history_element({

    required this.title_label,
    required this.widget_width,
    required this.widget_icon,
    required this.date,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget_width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        //color: Color.fromARGB(255, 241, 241, 241),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [

          // Icon with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 227, 242, 223), // Light green background
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget_icon, // Change this to match your exact icon
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),

          // Label and date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text(
                title_label,
                style: GoogleFonts.gabarito(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 227, 242, 223),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  date,
                  style: GoogleFonts.gabarito(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(width: 12),

          Spacer(),

          const SizedBox(width: 12),

          // share button in steps element
          GestureDetector(
            child: Icon(Icons.share_rounded),
            onTap: () {
              print("tapped share btn on step history element !!");
              // send message to server to add a user post/achavment
              print("Sending request to server !!!");
            },
          ),

          SizedBox(width: 10,),
        ],
      ),
    );
  }
}

// newsfeed element with network image
class newsfeed_element_network_ex extends StatelessWidget {

  double widget_width = 250;
  double widget_height = 250;
  String title_label = '';
  String banner_path = 'assets/newsfeed_img_1.png';
  String open_link = "";
  bool open_externaly = true;



  newsfeed_element_network_ex({

    required this.title_label,
    required this.banner_path,
    required this.widget_width,
    required this.widget_height,
    required this.open_link,
    required this.open_externaly,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        print("tapped on newsfeed element");

        // launch mode for the link
        LaunchMode mode_var = LaunchMode.inAppWebView;
        if (open_externaly == true) mode_var = LaunchMode.externalApplication;
        else mode_var = LaunchMode.inAppWebView;

        // open link
        var url = open_link;
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
              uri,
              mode: mode_var // remove this line if you want it to open in webview
          );
        } else {
          print('Could not launch $url');
        }

      }, // OnTap
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: Stack(
          children: [
            // Background image
            Image.network(
              banner_path, // Make sure this file is in your assets folder
              width: widget_width,
              height: widget_height, // Adjust height as needed
              fit: BoxFit.cover,
            ),

            // Gradient overlay at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80, // Adjust height of gradient area
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Title text
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                title_label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// newsfeed element with embeded or animation images for posts
class newsfeed_element_for_posts extends StatelessWidget {

  // main widget variables
  double widget_width = 250;
  double widget_height = 250;
  String title_label = '';
  String banner_path = 'assets/newsfeed_img_1.png';

  // internal posts dialog variables
  String post_username = 'user_id';
  String post_title = 'Title';
  String post_content = 'Content......';

  newsfeed_element_for_posts({

    required this.title_label,
    required this.banner_path,
    required this.widget_width,
    required this.widget_height,

    // these are for the posts page parameters
    required this.post_title,
    required this.post_content,
    required this.post_username,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        print("tapped on post element !!");

        // open posts page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostPage(
            title: post_title,
            usern_post: post_username,
            content: post_content,
            img_path: banner_path,
          )),
        );

      }, // OnTap
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: Stack(
          children: [
            // Background image
            Image.asset(
              banner_path, // Make sure this file is in your assets folder
              width: widget_width,
              height: widget_height, // Adjust height as needed
              fit: BoxFit.cover,
            ),

            // Gradient overlay at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80, // Adjust height of gradient area
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Title text
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                title_label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// newsfeed element with embeded images
class newsfeed_element extends StatelessWidget {

  double widget_width = 250;
  double widget_height = 250;
  String title_label = '';
  String banner_path = 'assets/newsfeed_img_1.png';
  String open_link = "";
  bool open_externaly = true;



  newsfeed_element({

    required this.title_label,
    required this.banner_path,
    required this.widget_width,
    required this.widget_height,
    required this.open_link,
    required this.open_externaly,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        print("tapped on newsfeed element");

        // launch mode for the link
        LaunchMode mode_var = LaunchMode.inAppWebView;
        if (open_externaly == true) mode_var = LaunchMode.externalApplication;
        else mode_var = LaunchMode.inAppWebView;

        // open link
        var url = open_link;
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
              uri,
              mode: mode_var // remove this line if you want it to open in webview
          );
        } else {
          print('Could not launch $url');
        }

      }, // OnTap
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: Stack(
          children: [
            // Background image
            Image.asset(
              banner_path, // Make sure this file is in your assets folder
              width: widget_width,
              height: widget_height, // Adjust height as needed
              fit: BoxFit.cover,
            ),

            // Gradient overlay at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80, // Adjust height of gradient area
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Title text
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                title_label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class settings_option_with_dropdown_menu extends StatelessWidget {
  String title = '';
  final List<DropdownMenuItem> dropDownMenu_Items;
  final void Function(dynamic) OnChange;
  final int val_for_menu;

  settings_option_with_dropdown_menu({
    required this.title,
    required this.dropDownMenu_Items,
    required this.OnChange,
    required this.val_for_menu,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 227, 242, 223), // Light green background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // // Title Text
          Text(
            title,
            style: GoogleFonts.gabarito(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),

          Spacer(),

          Container(
            width: 120,
            height: 50,
            child: DropdownButton(
              items: dropDownMenu_Items,
              onChanged: OnChange,
              underline: SizedBox(width: 0,),
              value: val_for_menu,
              style: GoogleFonts.gabarito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 136, 204, 131), // Light green background
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // Switch Button
          // Transform.scale(
          //   scale: 0.5, // Adjust switch size to match design
          //   child:
          // ),
        ],
      ),
    );
  }
}

class settings_option_with_toggle extends StatelessWidget {
  String title = '';
  bool isSwitched = false;
  final ValueChanged<bool> onChanged;

  settings_option_with_toggle({
    required this.title,
    required this.isSwitched,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 227, 242, 223), // Light green background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title Text
          Text(
            title,
            style: GoogleFonts.gabarito(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Switch Button
          Transform.scale(
            scale: 0.8, // Adjust switch size to match design
            child: Switch(
              value: isSwitched,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.green[300],
              inactiveTrackColor: Colors.black,
              inactiveThumbColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class regular_setting_option extends StatelessWidget {

  double widget_width = 330;
  double widget_height = 242;
  String title_label = '';
  VoidCallback tap;


  regular_setting_option({

    required this.title_label,
    required this.widget_width,
    required this.tap,

    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        width: widget_width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 227, 242, 223),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color.fromARGB(255, 227, 242, 223), width: 3),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),

            // Label
            Text(
              title_label,
              style: GoogleFonts.gabarito(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),

            Spacer(),

            const SizedBox(width: 12),

          ],
        ),
      ),
    );
  }
}


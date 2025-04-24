import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';

class Account_page_overview extends StatefulWidget {
  final String usern;
  final int pts;
  final List<Map<String, String>> topRanks;


  const Account_page_overview({Key? key,
    required this.usern,
    required this.pts,
    required this.topRanks
  }) : super(key: key);

  @override
  State<Account_page_overview> createState() => Account_page_overviewState();
}

class Account_page_overviewState extends State<Account_page_overview> {

  // some vars


  // clear user login data
  void clearUserLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('passw');
  }

  void clearAllUserData() async {
    print("Called clear all data fn !!!");
  }

  void restartApp() {
    print("Called Restart app fn !!!!");
    Restart.restartApp();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16, // Prevents overlap
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(
              height: 29,
            ),

            // Close Button (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Profile Image & Name
            CircleAvatar(
              child: Icon(
                Icons.supervised_user_circle_rounded,
                color: Color.fromARGB(255, 227, 242, 223),
                size: 65,
              ),
              backgroundColor: Colors.black,
              radius: 40,
            ),
            const SizedBox(height: 8),
            Text(
              widget.usern,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Stats (Points & Rank)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                overview_element_normal(
                  title_label: "Points",
                  val: widget.pts,
                  bg_color: Colors.white,
                  border_color: Color.fromARGB(255, 241, 241, 241),
                  widget_img: AssetImage('assets/leaf_icon.png'),
                ),
                SizedBox(width: 16),
                overview_element_normal_ex(
                  title_label: "Rank",
                  val: "55th",
                  bg_color: Color.fromARGB(255, 227, 242, 223),
                  border_color: Color.fromARGB(255, 227, 242, 223),
                  widget_img: AssetImage('assets/rank_icon.png'),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Top 3 Leaderboard
            const Text(
              "This month's top 3",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),


            const SizedBox(height: 6),

            // Top 3 rank list
            Container(
              height: 220,
              child: ListView.builder(
                itemCount: widget.topRanks.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      rank_element(
                        title_label: widget.topRanks[index]["name"]!,
                        rank_position: widget.topRanks[index]["position"]!,
                        widget_icon: Icons.emoji_events_rounded,
                      ),
                      const SizedBox(height: 5),
                    ],

                  );
                },
              ),
            ),

            Spacer(),

            // Logout user btn
            GestureDetector(
              onTap: () async {
                // logout logic
                clearUserLoginData();
                clearAllUserData();
                restartApp();
              },
              child: Container(
                width: 340,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Stats Card Widget
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({required this.title, required this.value, required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Leaderboard Entry Widget
class LeaderboardEntry extends StatelessWidget {
  final String name;
  final int rank;
  final Color color;

  const LeaderboardEntry({
    required this.name,
    required this.rank,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.groups, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Icon(Icons.emoji_events, color: color, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
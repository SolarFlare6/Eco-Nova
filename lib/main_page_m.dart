import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'custom_widgets.dart';
import 'account_quick_overview.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'steps_screen.dart';
import 'package:intl/intl.dart';
import 'rewards_page_view.dart';

// if the app isnt building try this : https://github.com/flutter/flutter/issues/156304#issuecomment-2397707812

class MainPage extends StatefulWidget {

  // vars for the page to be loaded
  final String usrName;


  const MainPage({Key? key,
    required this.usrName,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

// vars
String username = "Username";
int points = 0;
int actions_complete = 0;
int steps_taken = 0;
int steps_goal = 10000;
int steps_mark_reached = 0;
double steps_progress = 0.0;
bool notif_for_event = true;
bool notif_for_news = false;
bool open_in_browser = true;
int feed_size = 100;
String app_ver = "Version: 1.10 Beta User login";
String build_date = "Date: 24/04/2025";

// some timer vars
Timer? _newsCheckerTimer;

// init notification stuff
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// init step stream
late Stream<StepCount> _stepCountStream;
late Stream<PedestrianStatus> _pedestrianStatusStream;
String _status = "Unknown";

// list for article checking
List<Map<String, dynamic>> _articles = [];

// top ranks list
List<Map<String, String>> topRanks = [
  {"name": "Jane Doe", "position": "1st"},
  {"name": "Kevin Doe", "position": "2nd"},
  {"name": "Sam Stevenson", "position": "3rd"},
];

// rewards list
List<Map<String, dynamic>> rewards_list = [
  {"imageUrl": "assets/newsfeed_img_1.png", "points": "500 pts", "grad_col": Colors.white, "txt_col": Colors.black},
  {"imageUrl": "assets/newsfeed_img_1.png", "points": "750 pts", "grad_col": Colors.black, "txt_col": Colors.white},
  {"imageUrl": "assets/newsfeed_img_1.png", "points": "1000 pts", "grad_col": Colors.white, "txt_col": Colors.black},
  {"imageUrl": "assets/newsfeed_img_1.png", "points": "1250 pts", "grad_col": Colors.white, "txt_col": Colors.black},
];

// step goal history list
List<Map<String, dynamic>> stepHistory = [
  // {
  //   'steps': 10000,
  //   'date': '25/03/2025'
  // },
];

// range of random values to be added to steps goal
List<int> random_goal_val = [1500,1000,500,10000,5000,200];


class _MainPageState extends State<MainPage> {

  // functions

  // alternate FetchGoogleNews fn
  // Future<List<Map<String, dynamic>>> fetchGoogleNews() async {
  //   final url = Uri.parse(
  //       "https://news.google.com/rss/search?q=eco+friendly&hl=en-US&gl=US&ceid=US:en");
  //   final response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     final document = xml.XmlDocument.parse(response.body);
  //     final items = document.findAllElements("item");
  //
  //     List<Map<String, dynamic>> newsFeedData = [];
  //
  //     for (var item in items) {
  //       final title = item.findElements("title").first.text;
  //       final link = item.findElements("link").first.text;
  //
  //       // Get the actual article page image
  //       String imageUrl;
  //       //imageUrl = await fetchArticleImage(link) ?? "https://lh3.googleusercontent.com/J6_coFbogxhRI9iM864NL_liGXvsQp2AupsKei7z0cNNfDvGUmWUy20nuUhkREQyrpY4bEeIBuc=s0-w300";
  //       //String imageUrl = "";
  //       imageUrl = "https://lh3.googleusercontent.com/J6_coFbogxhRI9iM864NL_liGXvsQp2AupsKei7z0cNNfDvGUmWUy20nuUhkREQyrpY4bEeIBuc=s0-w300";
  //
  //       newsFeedData.add({
  //         "title": title,
  //         "image": imageUrl,
  //         "link": link,
  //       });
  //     }
  //
  //     return newsFeedData;
  //   } else {
  //     throw Exception("Failed to load news");
  //   }
  // }

  // this will be for custom overlay screen code

  // Function to Show the Actions Overview Overlay
  void showActionsOverview(BuildContext context) {
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
              color: Color.fromARGB(255, 227, 242, 223), // Light green background
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
                      image: AssetImage('assets/actions_icon.png'),
                      width: 32,
                      height: 32,
                    ),

                    SizedBox(width: 10),

                    Text(
                      "Actions overview",
                      style: GoogleFonts.gabarito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 15),

                // layout with actions complete
                Container(
                  width: 330,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Text(
                    "Current complete actions : " + actions_complete.toString(),
                    style: GoogleFonts.gabarito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),

                Container(
                  width: 330,
                  height: 200,
                  //color: Colors.blue,
                  child: ListView(
                    children: <Widget>[
                      buildProgressItem("Steps", steps_taken.toString() + "/" + steps_goal.toString(), steps_progress, "+10"),
                      //buildProgressItem("Cycling", "1km/10km", 0.1, "+20"),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                
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

// Progress Item Widget
  Widget buildProgressItem(String title, String progress, double value, String points) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.5),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title,
              style: GoogleFonts.gabarito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  progress,
                  style: GoogleFonts.gabarito(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: value, // Value between 0 and 1
                    backgroundColor: Colors.grey[300],
                    color: Colors.black,
                    minHeight: 12,
                  ),
                ),
              ),

              SizedBox(width: 10),

              Text(
                  points,
                  style: GoogleFonts.gabarito(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  // notification init fn
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // show notification fn
  Future<void> showNotification(String Title, String content) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      Title,
      content,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }


  // fetch news fn with api
  Future<List<Map<String, dynamic>>> fetchGoogleNews() async {
    const String apiKey = '58859a3ee71d45c7bfb4d63eebf31a9a';
    const String url =
        'https://newsapi.org/v2/everything?q=eco%20friendly&language=en&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> articles = data['articles'];

      List<Map<String, dynamic>> newsFeedData = articles.map((article) {
        String title = article['title'] ?? 'No Title';
        title = (title.length > 16) ? '${title.substring(0, 16)}...' : title;

        return {
          "title": title,
          "image": article['urlToImage'] ?? 'assets/placeholder.png',
          "link": article['url'] ?? '',
        };
      }).toList();

      return newsFeedData;
    } else {
      throw Exception('Failed to load news');
    }
  }

  // old fetch image fn
  // Future<String?> fetchArticleImage(String articleUrl) async {
  //   try {
  //     final response = await http.get(Uri.parse(articleUrl));
  //
  //     if (response.statusCode == 200) {
  //       final document = html.parse(response.body);
  //       print("Image grab fn document response body : ");
  //       print(response.body);
  //
  //       // Try to find common <meta> tags that store the main image
  //       final follow_link = document.querySelector('link')?.attributes['href'];
  //       //final metaTwitterImage = document.querySelector('meta[name="twitter:image"]')?.attributes['content'];
  //
  //       print("Follow link for image grab fn : ");
  //       print(follow_link);
  //
  //       // for following image url
  //       final response_follow = await http.get(Uri.parse(follow_link!));
  //       final follow_document = html.parse(response_follow.body);
  //       print("Image grab fn follow document response body : ");
  //       print(follow_document);
  //
  //       String Img_url = "";
  //
  //       print("Image link : ");
  //       print(Img_url);
  //
  //       // Use the first found image, or return null if none are found
  //       return Img_url;
  //     }
  //   } catch (e) {
  //     print("Error fetching article image: $e");
  //   }
  //   return null; // Return null if no image is found
  // }

  // check internet connection fn
  Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // for setting toggle function
  void _updateNotificationSetting(bool value, String type) {
    setState(() {
      if (type == "events") {
        notif_for_event = value;
      } else if (type == "news") {
        notif_for_news = value;
      } else if (type == "browser") {
        open_in_browser = value;
      }
    });
    print("Updated $type notifications: ${value ? "Enabled" : "Disabled"}");
  }

  void open_quick_acc() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Account_page_overview(usern: username,pts: points, topRanks: topRanks,)),
    );
  }

  void open_rewards_page() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RewardsPage_view(
          rewards: rewards_list,
          points: points,
        ),
      ),
    );
  }

  void change_feed_size(int size) {
    print("Changed the feed size to : " + feed_size.toString());
    if (size == 5 || size == 8 || size == 10) newsFeedData.removeRange(size, newsFeedData.length);
  }

  int getRandomValue(List<int> values) {
    final random = Random();
    return values[random.nextInt(values.length)];
  }

  // for controlling steps mark and goal and track activity
  void set_Steps_mark_and_goal() {

    if (steps_mark_reached == 0) {
      steps_goal = 10000;
    }

    if (steps_taken == steps_goal || steps_taken >= steps_goal) {
      add_step_history(steps_taken);
      showNotification('Eco Nova', 'Good job on staying active you have reached your goal of ' + steps_goal.toString() + ' steps');
      steps_taken = 0;
      steps_mark_reached++;
      steps_goal += getRandomValue(random_goal_val);
      points+=10;
      actions_complete++;
    }
  }

  void set_feed_size(int val) {
    setState(() {
      feed_size = val;
    });
    _refreshData();
  }

  double progressPercentage_steps(int steps, int goal) {
    if (goal <= 0) return 0.0; // Avoid division by zero
    double progress = steps / goal;
    return progress.clamp(0.0, 1.0); // Ensure value stays between 0.0 and 1.0
  }

  /// Handle step count changed
  void onStepCount(StepCount event) {
    print("steps before reassignment : " + steps_taken.toString());
    print(event.steps);
    setState(() {
      steps_taken++;
      steps_progress = progressPercentage_steps(steps_taken, steps_goal);
    });
    print("steps after reassignment : " + steps_taken.toString());
    set_Steps_mark_and_goal();
    _saveStepsData(steps_taken, steps_mark_reached, steps_goal);

  }

  /// Handle pedestrian status changed (walking/stopped)
  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  /// Handle errors
  void onStepCountError(error) {
    print("Step Count Error: $error");
  }

  void onPedestrianStatusError(error) {
    print("Pedestrian Status Error: $error");
  }

  Future<void> initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;

    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);
  }

  // Load saved data
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the keys exist before updating values
    setState(() {
      if (prefs.containsKey('steps')) {
        steps_taken = prefs.getInt('steps')!;
      }
      if (prefs.containsKey('steps_g')) {
        steps_goal = prefs.getInt('steps_g')!;
      }
      if (prefs.containsKey('steps_mark')) {
        steps_mark_reached = prefs.getInt('steps_mark')!;
      }
      if (prefs.containsKey('points')) {
        points = prefs.getInt('points')!;
      }
      if (prefs.containsKey('actions')) {
        actions_complete = prefs.getInt('actions')!;
      }
      if (prefs.containsKey('fd_size')) {
        feed_size = prefs.getInt('fd_size')!;
      }
      if (prefs.containsKey('notif_f_news')) {
        notif_for_news = prefs.getBool('notif_f_news')!;
      }
      if (prefs.containsKey('notif_f_events')) {
        notif_for_event = prefs.getBool('notif_f_events')!;
      }
      if (prefs.containsKey('open_in_brows')) {
        open_in_browser = prefs.getBool('open_in_brows')!;
      }
    });

    print("Data load function called!!");
    print("For steps: $steps_taken, for steps goal: $steps_goal");
  }

  // load settings function
  Future<void> _loadSettingsData() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the keys exist before updating values
    setState(() {
      if (prefs.containsKey('fd_size')) {
        feed_size = prefs.getInt('fd_size')!;
      }
      if (prefs.containsKey('notif_f_news')) {
        notif_for_news = prefs.getBool('notif_f_news')!;
      }
      if (prefs.containsKey('notif_f_events')) {
        notif_for_event = prefs.getBool('notif_f_events')!;
      }
      if (prefs.containsKey('open_in_brows')) {
        open_in_browser = prefs.getBool('open_in_brows')!;
      }
    });

    print("Data load settings function called!!");
  }


  // Save all data localy
  Future<void> _saveAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', steps_taken);
    await prefs.setInt('steps_mark', steps_mark_reached);
    await prefs.setInt('steps_g', steps_goal);
    await prefs.setInt('points', points);
    await prefs.setInt('actions', actions_complete);
    await prefs.setInt('fd_size', feed_size);
    await prefs.setBool('notif_f_news', notif_for_news);
    await prefs.setBool('notif_f_events', notif_for_event);
    await prefs.setBool('open_in_brows', open_in_browser);
  }

  // Save just the steps data
  Future<void> _saveStepsData(int steps, int steps_mark, int steps_g) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', steps);
    await prefs.setInt('steps_mark', steps_mark);
    await prefs.setInt('steps_g', steps_g);
  }

  // Save setting data
  Future<void> _saveSettingsData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fd_size', feed_size);
    await prefs.setBool('notif_f_news', notif_for_news);
    await prefs.setBool('notif_f_events', notif_for_event);
    await prefs.setBool('open_in_brows', open_in_browser);
  }



  Future<void> clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored data
  }

  Future<void> removeSpecificKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key); // Removes only a specific key
  }

  // some vars
  int _selectedIndex = 0;

  // for_you page vars
  List<Map<String, dynamic>> newsFeedData = [
    {
      "title": "...",
      "image": "assets/newsfeed_img_1.png",
      "link" : "",
    },
    {
      "title": "...",
      "image": "assets/newsfeed_element_2.jpg",
      "link" : "",
    },
    {
      "title": "...",
      "image": "assets/newsfeed_element_3.jpg",
      "link" : "",
    },
  ];

  List<Map<String, dynamic>> eventsFeedData = [
    {
      "title": "Annual Climathon",
      "image": "assets/image 1.png",
      "link" : "",
    },
    {
      "title": "Education on\nbird feeding",
      "image": "assets/image 2.png",
      "link" : "",
    },
    {
      "title": "Plant a tree\ninitiative",
      "image": "assets/planting-tree.jpg",
      "link" : "",
    },
  ];

  List<Map<String, dynamic>> achivementsFeedData = [
    {
      "title": "Recycled 1000\nbottles",
      "image": "assets/newsfeed_img_1.png",
      "usen_id" : "Petar",
      "post_title" : "Recycled 1000 bottles",
      "post_content" : "Today Petar did a great job at recycling 1000 plastic bottles and staying active.",
    },
    {
      "title": "Stefan made 5000\nsteps",
      "image": "assets/image 4.png",
      "usen_id" : "Mr.Robot",
      "post_title" : "Test title",
      "post_content" : "Hello World what a nice day!!",
    },
    {
      "title": "Filip recycled 1000\nbottles",
      "image": "assets/image 3.png",
      "usen_id" : "Mr.Robot",
      "post_title" : "Test title",
      "post_content" : "Hello World what a nice day!!",
    },
  ];

  List<Map<String, dynamic>> merchFeedData = [
    {
      "title": "Recycling shirt",
      "image": "assets/recycling_shirt_2.jpg",
      "link" : "",
    },
    {
      "title": "Recycled material\nschool supplies",
      "image": "assets/school_supplies_made_from_recycle.png",
      "link" : "",
    },
    {
      "title": "Ecologically\nfriendly notebooks",
      "image": "assets/recycled_notebook_2.jpg",
      "link" : "",
    },
  ];

  List<Map<String, dynamic>> ActionItems = [
    {
      'title': 'Cycling',
      'icon': Icons.directions_bike,
      'points': '+20',
    },
    {
      'title': 'Recycling',
      'icon': Icons.recycling,
      'points': '+1',
    },
    // Add more actions here...
  ];

  void addFeedItem(String feedname,String title, String imagePath, String lnk) {
    setState(() {
      if (feedname == "newsfeed") newsFeedData.add({"title": title, "image": imagePath, "link": lnk});
      if (feedname == "events-feed") eventsFeedData.add({"title": title, "image": imagePath, "link": lnk});
      //if (feedname == "achievements") achivementsFeedData.add({"title": title, "image": imagePath, "link": lnk});
      if (feedname == "stuff") merchFeedData.add({"title": title, "image": imagePath, "link": lnk});
    });
  }

  void clearAllFeeds() {
    setState(() {
      newsFeedData.clear();
      eventsFeedData.clear();
      achivementsFeedData.clear();
      merchFeedData.clear();
    });
  }

  void add_step_history(int steps) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    stepHistory.add({"steps": steps, "date": formattedDate});
    print("added to steps history !!");
  }

  // fn for newsfeed polling

  // for loading the initial state of the _article list
  void loadInitialArticles() async {
    _articles = await fetchGoogleNews();
    setState(() {});
  }

  // fn for checking if there is a new article to notify the user
  void startNewsPolling() {
    _newsCheckerTimer = Timer.periodic(Duration(minutes: 1), (_) async {
      print("Article checker timer fired !!!!");
      List<Map<String, dynamic>> latest = await fetchGoogleNews();
      print("User preference for showing notification on new articles is : " + notif_for_news.toString());

      // Compare latest with current
      if (notif_for_news) {
        if (_articles.isNotEmpty && latest.isNotEmpty) {
          if (_articles.first['title'] != latest.first['title']) {
            // New article detected
            showNotification('Eco Nova', 'A new article is available');
            _articles = latest; // Update list
            setState(() {});
          }
        }
      }

    });
  }

  // List of pages (initialized in initState)
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // for steps
    initPlatformState();

    // init user
    username = widget.usrName;

    // // load data & set the goals for the steps
    _loadData();
    set_Steps_mark_and_goal();

    // feed ite
    addFeedItem("stuff", "Green recycling shirt", 'assets/recycling_shirt.jpg', "");

    // refresh newsfeed
    _refreshData();

    // for article checking init state
    loadInitialArticles();
    startNewsPolling();

    // init notif
    initializeNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    _newsCheckerTimer?.cancel(); // end the article checker timer
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        print('settings page !!');
        _loadSettingsData();
      } else {
        _saveSettingsData();
        print('other page - saving settings !!');
      }
    });
  }

  // Refresh function to simulate updating data
  Future<void> _refreshData() async {
    //await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    print("Called refresh function !!");

    if (await hasInternetAccess()) {
      print("Network is available!!");

      // print out newsfeed before refresh - remove later
      print("Newsfeed data before fetchNewsfeed fn is : ");
      print(newsFeedData);

      // assign the content of the fetched newsfeed to a temp variable
      var temp = await fetchGoogleNews();

      // print out the info of the temp variable
      print("Temporary var content : ");
      print(temp);

      print("Newsfeed data after fetchNewsfeed fn is : ");
      print(newsFeedData);

      // code to fetch events newsfeed when refersh
      var events = await fetchEventsFeedData();
      print("contents of the events newsfeed : \n" + events.toString());

      // code to fetch the actions when refersh
      var actions_temp = await fetchEcoActions();
      print("contents of the actions list : \n" + actions_temp.toString());

      // code for new news notifiction
      // if (newsFeedData != temp && notif_for_news) {
      //   print("new news available!!!");
      //   showNotification('Eco nova', 'There is some new news for you');
      // }

      // update the page and rebuild the For You page
      setState(() {
        newsFeedData = temp;
        if (events.isNotEmpty) eventsFeedData = events;
        if (actions_temp.isNotEmpty) ActionItems = actions_temp;
      });

    } else {
      print("No network connection!!");

    }

    // update the state of the page
    setState(() {
      change_feed_size(feed_size);
      set_Steps_mark_and_goal(); // idk if here
      steps_progress = progressPercentage_steps(steps_taken, steps_goal);
    });



    // save all the apps data
    _saveAllData();
  }

  // for getting events newsfeed from backend
  Future<List<Map<String, dynamic>>> fetchEventsFeedData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/events'));

    if (response.statusCode == 200) {
      List<dynamic> events = json.decode(response.body);

      // Mapping each event to the desired format
      List<Map<String, dynamic>> eventsFeedData = events.map<Map<String, dynamic>>((event) {
        return {
          "title": event["title"] ?? "No Title",
          "image": getImageForTitle(event["title"]),
          "link": event["eventLink"] ?? "",
        };
      }).toList();

      return eventsFeedData;
    } else {
      throw Exception('Failed to load events');
    }
  }

  // Optional: Match a title to a local image
  String getImageForTitle(String? title) {
    if (title == null) return "assets/default.jpg";
    if (title.contains("Climathon")) return "assets/image 1.png";
    if (title.contains("bird")) return "assets/image 2.png";
    if (title.contains("tree")) return "assets/planting-tree.jpg";
    return "assets/default.jpg"; // fallback image
  }

  // function to grab actions from node.js server
  Future<List<Map<String, dynamic>>> fetchEcoActions() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/actions'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Convert API data to List<Map<String, dynamic>>
      List<Map<String, dynamic>> actionItems = data.map<Map<String, dynamic>>((item) {
        String title = item['title'] ?? 'Unknown';
        int points = item['points'] ?? 0;

        return {
          'title': title,
          'icon': getIconForAction(title),
          'points': '+$points',
        };
      }).toList();

      return actionItems;
    } else {
      throw Exception('Failed to fetch eco actions');
    }
  }

  /// Matches action titles to specific icons
  IconData getIconForAction(String title) {
    title = title.toLowerCase();

    if (title.contains('cycling')) return Icons.directions_bike;
    if (title.contains('recycling')) return Icons.recycling;
    if (title.contains('walking')) return Icons.directions_walk;
    if (title.contains('tree')) return Icons.park;
    if (title.contains('bus')) return Icons.directions_bus;
    // Default icon
    return Icons.eco;
  }


  @override
  Widget build(BuildContext context) {

    // Initialize the list of pages AFTER instance methods are available
    final _pages = [
      HomePage(
        openRewards: open_rewards_page,
        newsFeedData_local: newsFeedData,
        open_overlay_menu: showActionsOverview,
        openAcc_page: open_quick_acc,
      ),
      ActionsPage(
        openRewards: open_rewards_page,
        openAcc_page: open_quick_acc,
        actionItems: ActionItems,
      ),
      For_U_Page(
        openRewards: open_rewards_page,
        newsFeedData_local: newsFeedData,
        eventFeedData_local: eventsFeedData,
        achevmentsFeedData_local: achivementsFeedData,
        merchFeedData_local: merchFeedData,
        openAcc_page: open_quick_acc,
      ),
      SettingsPage(
        openRewards: open_rewards_page,
        notifForEvent: notif_for_event,
        notifForNews: notif_for_news, // Pass news notifications state
        onNotifToggle: _updateNotificationSetting,
        browser_or_webview: open_in_browser,
        feed_size_val_fn: set_feed_size,
        reset_user_data: clearSavedData,
        notif_fn: showNotification,
        openAcc_page: open_quick_acc,
      ),
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 253, 255),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _pages[_selectedIndex], // Display current page
        color: Color.fromARGB(255, 64, 70, 63),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromARGB(255, 64, 70, 63),
        unselectedItemColor: Color.fromARGB(255, 202, 204, 201),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.chip_extraction),
            label: 'Actions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'For you',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Home Page (Insert your content here)
class HomePage extends StatelessWidget {
  final VoidCallback openRewards; // Callback function
  final List<Map<String, dynamic>> newsFeedData_local;
  final void Function(BuildContext) open_overlay_menu;
  final VoidCallback openAcc_page;

  const HomePage({Key? key,
    required this.openRewards,
    required this.newsFeedData_local,
    required this.open_overlay_menu,
    required this.openAcc_page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 253, 255),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          SizedBox(
            height: 50,
          ),

          //  titlebar row
          // Center(
          //   child: Row(
          //     children: <Widget>[
          //       SizedBox(width: 24), // Left padding
          //
          //       CircleAvatar(
          //         child: Icon(
          //           Icons.supervised_user_circle_rounded,
          //           color: Color.fromARGB(255, 227, 242, 223),
          //           size: 45,
          //         ),
          //         backgroundColor: Colors.black,
          //         radius: 24,
          //       ),
          //
          //       SizedBox(width: 10), // Space between avatar and text
          //
          //       Text(
          //         username,
          //         style: GoogleFonts.gabarito(
          //           fontSize: 20,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.black,
          //         ),
          //       ),
          //
          //       Spacer(), // Pushes the IconButton to the right
          //
          //       Padding(
          //         padding: EdgeInsets.only(right: 16), // Adjusts offset from screen edge
          //         child: IconButton(
          //           icon: Icon(Symbols.trophy_rounded, size: 31),
          //           onPressed: () {
          //             openRewards();
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          title_bar_widget(
            openRewards: openRewards,
            openUserAcc: openAcc_page,
          ),

          SizedBox(
            height: 44,
          ),

          // overview Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              SizedBox(
                width: 10,
              ),

              // Points overview layout
              overview_element_normal(
                title_label: "Points",
                val: points,
                bg_color: Colors.white,
                border_color: Color.fromARGB(255, 241, 241, 241),
                widget_img: AssetImage('assets/leaf_icon.png'),
              ),

              SizedBox(
                width: 15,
              ),

              // Actions overview layout
              GestureDetector(
                child: overview_element_normal(
                  title_label: "Actions",
                  val: actions_complete,
                  bg_color: Color.fromARGB(255, 227, 242, 223),
                  border_color: Color.fromARGB(255, 227, 242, 223),
                  widget_img: AssetImage('assets/actions_icon.png'),
                ),
                onTap: () {
                  open_overlay_menu(context);
                },
              ),


            ],
          ),

          SizedBox(
            height: 43,
          ),

          // Newsfeed title
          Row(
            children: <Widget>[
              SizedBox(width: 24,),
              Text("Newsfeed",
                style: GoogleFonts.gabarito(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 26,
          ),

          // Scrollable feed
          Container(
            height: 165,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 24),
                ...newsFeedData_local.map((item) => Padding(
                  padding: const EdgeInsets.only(right: 21),
                  child: newsfeed_element_network_ex(
                    title_label: item["title"],
                    banner_path: item["image"],
                    open_link: item["link"],
                    open_externaly: open_in_browser,
                    widget_width: 250,
                    widget_height: 250,
                  ),
                )),
              ],
            ),
          ),

          SizedBox(
            width: 21,
          ),





        ],
      ),
    ); // Replace this with your actual content
  }
}

// Search Page (Insert your content here)
class ActionsPage extends StatelessWidget {
  final VoidCallback openRewards; // Callback function
  final VoidCallback openAcc_page;
  final List<Map<String, dynamic>> actionItems;

  const ActionsPage({Key? key, required this.openRewards, required this.openAcc_page, required this.actionItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 253, 255),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          SizedBox(
            height: 50,
          ),

          // title bar row
          // Center(
          //   child: Row(
          //     children: <Widget>[
          //       SizedBox(width: 24), // Left padding
          //
          //       CircleAvatar(
          //         child: Icon(
          //           Icons.supervised_user_circle_rounded,
          //           color: Color.fromARGB(255, 227, 242, 223),
          //           size: 45,
          //         ),
          //         backgroundColor: Colors.black,
          //         radius: 24,
          //       ),
          //
          //       SizedBox(width: 10), // Space between avatar and text
          //
          //       Text(
          //         username,
          //         style: GoogleFonts.gabarito(
          //           fontSize: 20,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.black,
          //         ),
          //       ),
          //
          //       Spacer(), // Pushes the IconButton to the right
          //
          //       Padding(
          //         padding: EdgeInsets.only(right: 16), // Adjusts offset from screen edge
          //         child: IconButton(
          //           icon: Icon(Symbols.trophy_rounded, size: 31),
          //           onPressed: () {
          //             openRewards();
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          title_bar_widget(
            openRewards: openRewards,
            openUserAcc: openAcc_page,
          ),

          SizedBox(
            height: 32,
          ),

          // overview Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // Points overview layout
              Material(
                elevation: 0,
                color: Color.fromARGB(255, 241, 241, 241),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),

                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        child: Row(
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
                                  image: AssetImage('assets/leaf_icon.png'),
                                  width: 32,
                                  height: 32,
                                ),

                                SizedBox(
                                  width: 8,
                                ),

                                Text("Points",
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

                                Text(points.toString(),
                                  style: GoogleFonts.gabarito(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                        width: 330,
                        height: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 8,
              ),

              // Actions overview layout
              Material(
                elevation: 0,
                color: Color.fromARGB(255, 227, 242, 223),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),

                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            // Widgets for Actions overview

                            SizedBox(
                              height: 12,
                            ),

                            Row(
                              children: <Widget>[

                                SizedBox(
                                  width: 13,
                                ),

                                Image(
                                  image: AssetImage('assets/actions_icon.png'),
                                  width: 32,
                                  height: 32,
                                ),

                                SizedBox(
                                  width: 8,
                                ),

                                Text("Actions",
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

                                Text(actions_complete.toString(),
                                  style: GoogleFonts.gabarito(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                        width: 330,
                        height: 60,
                        color: Color.fromARGB(255, 227, 242, 223),
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),

          SizedBox(
            height: 35,
          ),

          // Actions title
          Row(
            children: <Widget>[
              SizedBox(width: 24,),
              Text("Actions",
                style: GoogleFonts.gabarito(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),

          // Steps layout
          action_element_with_expanded_info(
            title_label: 'Steps',
            widget_width: 350,
            progress: steps_progress,
            widget_icon: Icons.directions_walk_rounded,
            added_points: '+10',
            val: steps_taken,
            val_goal: steps_goal,
            tap_fn: () {
              print('tapped steps layout !!!');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StepsPage(imp_steps: steps_taken, imp_steps_goal: steps_goal, stepHistory: stepHistory,)),
              );
            },
          ),

          // SizedBox(
          //   height: 10,
          // ),

          // List of actions
          Expanded(
            child: Container(
              width: 350,
              //   height: 250,
              child: ListView(
                children: actionItems
                    .map((item) => Column(
                  children: [
                    action_element(
                      title_label: item['title'],
                      widget_width: 330,
                      widget_icon: item['icon'],
                      added_points: item['points'],
                    ),
                    const SizedBox(height: 10),
                  ],
                ))
                    .toList(),
              ),
            ),
          ),



        ],
      ),
    ); // Replace this with your actual content
  }
}

// Profile Page (Insert your content here)
class For_U_Page extends StatelessWidget {
  final VoidCallback openRewards; // Callback function
  final List<Map<String, dynamic>> newsFeedData_local;
  final List<Map<String, dynamic>> eventFeedData_local;
  final List<Map<String, dynamic>> achevmentsFeedData_local;
  final List<Map<String, dynamic>> merchFeedData_local;
  final VoidCallback openAcc_page;


  For_U_Page({Key? key,
    required this.openRewards,
    required this.newsFeedData_local,
    required this.eventFeedData_local,
    required this.achevmentsFeedData_local,
    required this.merchFeedData_local,
    required this.openAcc_page,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 253, 255),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          SizedBox(
            height: 50,
          ),

          // title bar row
          // Center(
          //   child: Row(
          //     children: <Widget>[
          //       SizedBox(width: 24), // Left padding
          //
          //       CircleAvatar(
          //         child: Icon(
          //           Icons.supervised_user_circle_rounded,
          //           color: Color.fromARGB(255, 227, 242, 223),
          //           size: 45,
          //         ),
          //         backgroundColor: Colors.black,
          //         radius: 24,
          //       ),
          //
          //       SizedBox(width: 10), // Space between avatar and text
          //
          //       Text(
          //         username,
          //         style: GoogleFonts.gabarito(
          //           fontSize: 20,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.black,
          //         ),
          //       ),
          //
          //       Spacer(), // Pushes the IconButton to the right
          //
          //       Padding(
          //         padding: EdgeInsets.only(right: 16), // Adjusts offset from screen edge
          //         child: IconButton(
          //           icon: Icon(Symbols.trophy_rounded, size: 31),
          //           onPressed: () {
          //             openRewards();
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          title_bar_widget(
            openRewards: openRewards,
            openUserAcc: openAcc_page,
          ),

          SizedBox(
            height: 25,
          ),

          // Container for the feed listview
          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[

                  // Newsfeed title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("Newsfeed",
                        style: GoogleFonts.gabarito(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 26,
                  ),

                  // Scrollable feed for newsfeed
                  Container(
                    height: 165,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 24),
                        ...newsFeedData_local.map((item) => Padding(
                          padding: const EdgeInsets.only(right: 21),
                          child: newsfeed_element_network_ex(
                            title_label: item["title"],
                            banner_path: item["image"],
                            open_link: item["link"],
                            open_externaly: open_in_browser,
                            widget_width: 250,
                            widget_height: 250,
                          ),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // Events title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("Events",
                        style: GoogleFonts.gabarito(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 26,
                  ),

                  // Scrollable feed for events
                  Container(
                    height: 165,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 24),
                        ...eventFeedData_local.map((item) => Padding(
                          padding: const EdgeInsets.only(right: 21),
                          child: newsfeed_element(
                            title_label: item["title"],
                            banner_path: item["image"],
                            open_link: item["link"],
                            open_externaly: open_in_browser,
                            widget_width: 250,
                            widget_height: 250,
                          ),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // achievements title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("Todays achievments",
                        style: GoogleFonts.gabarito(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 26,
                  ),

                  // Scrollable feed for achievements
                  Container(
                    height: 165,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 24),
                        ...achevmentsFeedData_local.map((item) => Padding(
                          padding: const EdgeInsets.only(right: 21),
                          child: newsfeed_element_for_posts(
                            title_label: item["title"],
                            banner_path: item["image"],
                            widget_width: 250,
                            widget_height: 250,
                            post_username: item["usen_id"],
                            post_title: item["post_title"],
                            post_content: item["post_content"],
                          ),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // Merch title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("Merch",
                        style: GoogleFonts.gabarito(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 26,
                  ),

                  // Scrollable feed for Merch
                  Container(
                    height: 165,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 24),
                        ...merchFeedData_local.map((item) => Padding(
                          padding: const EdgeInsets.only(right: 21),
                          child: newsfeed_element(
                            title_label: item["title"],
                            banner_path: item["image"],
                            open_link: item["link"],
                            open_externaly: open_in_browser,
                            widget_width: 250,
                            widget_height: 250,
                          ),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),

                ],
              ),
            ), // end of feed listview container
          ),


        ],
      ),
    ); // Replace this with your actual content
  }
}

// Settings Page (Insert your content here)
class SettingsPage extends StatelessWidget {
  final VoidCallback openRewards;
  final bool notifForEvent;
  final bool notifForNews;
  final bool browser_or_webview;
  final void Function(bool, String) onNotifToggle; // Function with type
  final Function(int) feed_size_val_fn;
  final VoidCallback reset_user_data;
  final void Function(String, String) notif_fn;
  final VoidCallback openAcc_page;

  const SettingsPage({
    Key? key,
    required this.openRewards,
    required this.notifForEvent,
    required this.notifForNews,
    required this.onNotifToggle,
    required this.browser_or_webview,
    required this.feed_size_val_fn,
    required this.reset_user_data,
    required this.notif_fn,
    required this.openAcc_page,
  }) : super(key: key);

  // some fn


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 253, 255),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          SizedBox(
            height: 50,
          ),

          // title bar row
          // Center(
          //   child: Row(
          //     children: <Widget>[
          //       SizedBox(width: 24), // Left padding
          //
          //       CircleAvatar(
          //         child: Icon(
          //           Icons.supervised_user_circle_rounded,
          //           color: Color.fromARGB(255, 227, 242, 223),
          //           size: 45,
          //         ),
          //         backgroundColor: Colors.black,
          //         radius: 24,
          //       ),
          //
          //       SizedBox(width: 10), // Space between avatar and text
          //
          //       Text(
          //         username,
          //         style: GoogleFonts.gabarito(
          //           fontSize: 20,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.black,
          //         ),
          //       ),
          //
          //       Spacer(), // Pushes the IconButton to the right
          //
          //       Padding(
          //         padding: EdgeInsets.only(right: 16), // Adjusts offset from screen edge
          //         child: IconButton(
          //           icon: Icon(Symbols.trophy_rounded, size: 31),
          //           onPressed: () {
          //             openRewards();
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          title_bar_widget(
            openRewards: openRewards,
            openUserAcc: openAcc_page,
          ),

          SizedBox(
            height: 25,
          ),

          Expanded(
            child: Container(
              width: 360,
              child: ListView(
                children: <Widget>[

                  // notification section title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("Notifications",
                        style: GoogleFonts.gabarito(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  settings_option_with_toggle(
                    title: "Get notifications for events",
                    isSwitched: notif_for_event,
                    onChanged: (bool value) {
                      onNotifToggle(value, "events"); // Call function
                    },

                  ),

                  SizedBox(
                    height: 10,
                  ),

                  settings_option_with_toggle(
                    title: "Get notifications for news",
                    isSwitched: notif_for_news,
                    onChanged: (bool value) {
                      onNotifToggle(value, "news"); // Call function
                    },

                  ),

                  SizedBox(
                    height: 10,
                  ),

                  regular_setting_option(
                    title_label: 'Grant notification permission',
                    widget_width: 330,
                    tap: () {
                      print('Requesting permission for notifiaction !!');
                      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
                    },
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  // Control section title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("Control",
                        style: GoogleFonts.gabarito(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  settings_option_with_toggle(
                    title: "Open in browser newsfeeds",
                    isSwitched: browser_or_webview,
                    onChanged: (bool value) {
                      onNotifToggle(value, "browser"); // Call function
                    },

                  ),

                  SizedBox(
                    height: 10,
                  ),

                  settings_option_with_dropdown_menu(
                    title: 'Feed size',
                    val_for_menu: feed_size,
                    dropDownMenu_Items: [
                      DropdownMenuItem(
                        child: Text('5'),
                        value: 5,
                      ),
                      DropdownMenuItem(
                        child: Text('8'),
                        value: 8,
                      ),
                      DropdownMenuItem(
                        child: Text('10'),
                        value: 10,
                      ),
                      DropdownMenuItem(
                        child: Text('Unlimited'),
                        value: 100,
                      ),
                    ],
                    OnChange: (value) {
                      feed_size_val_fn(value);
                    },
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  // Account section title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("Account",
                        style: GoogleFonts.gabarito(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  regular_setting_option(
                    title_label: "Buy premium",
                    widget_width: 330,
                    tap: () {},
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  regular_setting_option(
                    title_label: "Manage account",
                    widget_width: 330,
                    tap: () {

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => LoginPage_view(),
                      //   ),
                      // );

                    },
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  // About section title
                  Row(
                    children: <Widget>[
                      SizedBox(width: 24,),
                      Text("About",
                        style: GoogleFonts.gabarito(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 227, 242, 223), // Light green background
                      borderRadius: BorderRadius.circular(15), // Rounded edges
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Info",
                          style: GoogleFonts.gabarito(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          app_ver,
                          style: GoogleFonts.gabarito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          build_date,
                          style: GoogleFonts.gabarito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  regular_setting_option(
                    title_label: 'Reset user data',
                    widget_width: 330,
                    tap: () {
                      print("Reset user data !!");
                      reset_user_data();
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  regular_setting_option(
                    title_label: 'Reach steps goal',
                    widget_width: 330,
                    tap: () {
                      steps_taken = steps_goal;
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  regular_setting_option(
                    title_label: 'Test notification',
                    widget_width: 330,
                    tap: () {

                      print('Requesting permission for notifiaction !!');
                      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

                      print('Running code to show notification !!!');
                      notif_fn('Notification','Hello World I am here!');

                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  regular_setting_option(
                    title_label: "Contact us",
                    widget_width: 330,
                    tap: () {},
                  ),

                  SizedBox(
                    height: 10,
                  ),



                ],
              ),
            ),
          ),


        ],
      ),
    ); // Replace this with your actual content
  }
}

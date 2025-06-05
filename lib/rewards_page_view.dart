import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardsPage_view extends StatefulWidget {

  final List<Map<String, dynamic>> rewards;
  final int points;

  const RewardsPage_view({
    Key? key,
    required this.rewards,
    required this.points,
  }) : super(key: key);

  @override
  State<RewardsPage_view> createState() => _RewardsPage_viewState();
}

class _RewardsPage_viewState extends State<RewardsPage_view> {
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
            const SizedBox(height: 29),

            // title layout
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                SizedBox(width: 25,),

                // Title
                const Text(
                  "Rewards",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                Spacer(),

                // Close Button
                IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                SizedBox(width: 29,),

              ],
            ),

            SizedBox(height: 15,),

            // points layout
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

                              Text(widget.points.toString(),
                                style: GoogleFonts.gabarito(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                      width: 370,
                      height: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Scrollable Grid for Rewards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: widget.rewards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return RewardItem(
                      imageUrl: widget.rewards[index]["imageUrl"]!,
                      points: widget.rewards[index]["points"]!,
                      gradient_col: widget.rewards[index]["grad_col"]!,
                      txt_col: widget.rewards[index]["txt_col"]!,
                      item_name: widget.rewards[index]["name"],
                    );
                  },
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

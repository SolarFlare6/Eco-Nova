import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_widgets.dart';

class StepsPage extends StatefulWidget {

  final int imp_steps;
  final int imp_steps_goal;
  final List<Map<String, dynamic>> stepHistory;

  const StepsPage({Key? key,
    required this.imp_steps,
    required this.imp_steps_goal,
    required this.stepHistory,
  }) : super(key: key);

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {

  // vars
  double distance = 0; // Distance in km
  double calories = 0;
  double userWeight = 70.0;
  double strideLength = 0.78; // Example: 0.78 meters (average for adults)


  // functions

  // function for calories burnt
  double calculateCaloriesBurned(int steps, double weightKg, double strideLengthMeters) {
    const double met = 3.5;

    double distanceKm = (steps * strideLengthMeters) / 1000; // Convert stride length (meters) to distance traveled in km
    double caloriesBurned = met * weightKg * distanceKm * 1.036; // Calories burned formula

    return caloriesBurned;
  }

  // function to calculate the distance traveled by eatch step
  double calculateDistance(int stepsTaken, {double stepLengthMeters = 0.78}) {
    // Convert step length from meters to kilometers and multiply by steps taken
    return (stepsTaken * stepLengthMeters) / 1000;
  }

  // refresh function
  Future<void> refresh_fn() async {
    await Future.delayed(const Duration(seconds: 2));


  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // for cal burned
    calories = calculateCaloriesBurned(widget.imp_steps, userWeight, strideLength);

    // for distance traveled calculation
    distance = calculateDistance(widget.imp_steps);

  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.imp_steps / widget.imp_steps_goal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: refresh_fn,
        color: Color.fromARGB(255, 64, 70, 63),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 35,),

              // title and close btn layout
              Row(
                children: <Widget>[

                  SizedBox(width: 24,),

                  Text(
                    'Steps',
                    style: GoogleFonts.gabarito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  Spacer(),

                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 35,),
                    onPressed: () => Navigator.pop(context),
                  ),



                ],
              ),

              SizedBox(
                height: 10,
              ),

              // Steps Counter Box
              Container(
                height: 320,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    SizedBox(height: 42,),

                    Text(
                      widget.imp_steps.toString() + ' steps',
                      style: GoogleFonts.gabarito(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    // Progress Bar
                    Container(
                      width: 250,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress > 1 ? 1 : progress,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[

                        Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Goal: ' + widget.imp_steps_goal.toString(),
                            style: GoogleFonts.gabarito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        SizedBox(width: 35,),

                      ],
                    ),

                    SizedBox(height: 44),

                    // row with text for km traveled and calories burnt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Text(
                          '${distance.toStringAsFixed(2)}km',
                          style: GoogleFonts.gabarito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(width: 10,),

                        Text(
                          '|',
                          style: GoogleFonts.gabarito(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                          ),
                        ),

                        SizedBox(width: 10,),

                        Text(
                          '${calories.toStringAsFixed(2)} Cal',
                          style: GoogleFonts.gabarito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),

              SizedBox(height: 20),

              // Steps History Section
              Container(
                height: 250,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color.fromARGB(255, 64, 70, 63), width: 2),
                  //color: Color.fromARGB(255, 241, 241, 241),
                ),
                child: Column(
                  children: [

                    SizedBox(height: 5,),

                    Text(
                      'Steps History',
                      style: GoogleFonts.gabarito(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Container(
                      width: 320,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //color: Color.fromARGB(255, 241, 241, 241),
                      ),
                      child: widget.stepHistory.isEmpty ? Center(
                        child: Text(
                          "No steps history",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ) : ListView.builder(
                        itemCount: widget.stepHistory.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              step_history_element(
                                title_label: "${widget.stepHistory[index]['steps']} steps taken",
                                widget_width: 330,
                                widget_icon: Icons.directions_walk,
                                date: widget.stepHistory[index]['date'],
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),


                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

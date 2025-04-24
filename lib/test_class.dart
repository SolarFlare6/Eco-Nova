import 'package:flutter/material.dart';
// Version 1.5 of this custom widget


// custom menu with title bar and animation
class C_menu extends StatelessWidget {

  double widget_width = 288;
  double widget_height = 242;
  String title_label = '';
  String title_img_path = '';
  double title_img_width = 29;
  double title_img_height = 29;
  String image_path = '';

  C_menu({
    required this.widget_width,
    required this.widget_height,
    required this.title_label,
    required this.title_img_path,
    required this.title_img_width,
    required this.title_img_height,
    required this.image_path,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget_width,
        height: widget_height,
        /*child: Material(
           color: const Color.fromARGB(255, 22, 23, 23),
           elevation: 2,
           shape:
           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),*/
        //child: SingleChildScrollView(
        /*child: Padding(
               padding: const EdgeInsets.all(16.0),*/
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 17,),
            Material(
              color: const Color.fromARGB(255, 22, 23, 23),
              elevation: 2,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 221,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // top left corner image
                      Image(
                        image: AssetImage(title_img_path),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(title_label,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto_Regular',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 19,
            // ),
            Image(
              width: 288,
              height: 162,
              image: AssetImage(image_path),
            ),
          ],
        ),
        //),
        // ),
        // ), // Material
      ),
    );
  }
}


// custom menu widget with title bar selectable title bar icon and image auto round
class custom_menu_card extends StatelessWidget {
  double widget_width = 288;
  double widget_height = 242;
  double img_border_radious = 10;
  Color? title_bg_col = Color.fromARGB(255, 22, 23, 23);
  Color? border_color = Color.fromARGB(255, 90, 154, 208);
  double img_width = 288;
  double img_height = 153;
  String title_label = '';
  double title_bar_width = 221;
  Color? title_label_color;
  String title_img_path = ''; // recommended 29x29 sized image
  double title_img_width = 29;
  double title_img_height = 29;
  String image_path = '';

  custom_menu_card({
    required this.widget_width,
    required this.widget_height,
    required this.img_border_radious,
    required this.title_bg_col,
    required this.border_color,
    required this.img_width,
    required this.img_height,
    required this.title_label,
    required this.title_bar_width,
    this.title_label_color,
    required this.title_img_path,
    required this.title_img_height,
    required this.title_img_width,
    required this.image_path,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget_width,
        height: widget_height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 17,),

            // for the title bar of the widget
            Material(
              color: title_bg_col,
              elevation: 2,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: title_bar_width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // top left corner image
                      Image(
                        width: title_img_width,
                        height: title_img_height,
                        image: AssetImage(title_img_path),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(title_label,
                        style: TextStyle(
                          color: title_label_color,
                          fontFamily: 'Roboto_Regular',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), // end of the title bar of this widget


            Material(
              elevation: 2,
              color: border_color,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(img_border_radious)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),

                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(img_border_radious-2.0),
                    child:Image(
                      fit: BoxFit.fill,
                      width: img_width,
                      height: img_height,
                      image: AssetImage(image_path),
                    ),
                  ),
                ),
              ),
            ),



          ], // end of the children of the column
        ),
      ),
    );
  }
}
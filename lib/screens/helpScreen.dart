import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skywa/components/tileWidgets.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';

class HelpScreen extends StatefulWidget {
  static const String id = 'HelpScreen';
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Help'),
        centerTitle: true,
        //  backgroundColor: kAppBarColor,
      ),
      body:
//      Column  (
//        children: [
          SwipeGestureRecognizer(
        onSwipeLeft: () {
          Navigator.of(context).pop();
        },
        child: Container(
          constraints: BoxConstraints.expand(),
          child: ListView(
            children: [
              Column(
                children: [
                  helpTile(context, "How do I set my business up on Skywa?",
                      "Download Skywa Manager and click set up new business."),
                  helpTile(context, "Why do I need to turn on Location Services?",
                      "Location services are used to know when you have arrived and let the business know that you are waiting close by."),
                  helpTile(context, "How do I know when it is my turn to enter the business?",
                      "You will receive a notification and if you have the Skywa open an alert will be displayed"),
                  helpTile(context, "What if I decide to leave before I am called?",
                      "You should click on the cancel button on the current appointment screen."),
                  helpTile(context, "What does “Training Mode” mean?",
                      "Businesses can set their company in training mode and teach their employees how to use Skywa.  To check in at a business in training mode you need a code provided by the business."),
                  helpTile(context, "How can I advertise my business in Skywa?.",
                      "Please contact us at support@skywasolutions.com"),
                  // helpTileURL(
                  //     context,
                  //     "How do I do get More Info?",
                  //     "Click More Info to get more Info",
                  //     "More Info",
                  //     "https://google.com"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

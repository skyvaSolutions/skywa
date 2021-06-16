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
            Icons.chevron_left,
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
                  helpTile(context, "How do I do This?",
                      "It is easy just push the green button"),
                  helpTile(context, "How do I do That?",
                      "It is easy just push the red button"),
                  helpTileURL(
                      context,
                      "How do I do get More Info?",
                      "Click More Info to get more Info",
                      "More Info",
                      "https://google.com"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

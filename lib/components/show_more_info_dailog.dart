import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/components/businessWidget.dart';

class CustomDialog extends StatefulWidget {
  final Function() goToCurrentScreen;
  final companyName;
  const CustomDialog({Key key , this.goToCurrentScreen , @required this.companyName}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(onPressed: (){
          if(widget.goToCurrentScreen != null)
            widget.goToCurrentScreen();
          Navigator.pop(context);}, child: Text('Done'))
      ],
      content: Container(
        width: double.infinity,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: -60,
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: [
                    Color(0xFF4C44B3),
                    Color(0xFF3CD1BB),
                  ][DB.box.get(DB.index) % 2],
                ),
                child: Center(
                  child: Text(
                    getInitials(widget.companyName),
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Text(
                    widget.companyName,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Your appointment is confirmed. Kindly be on time and wait for your turn to be called.  ',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'For any queries, you reach out to us via chat or call.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/Providers/appointmentScreenProvider.dart';
import 'package:skywa/Providers/appointment_tap_provider.dart';
import 'package:skywa/api_calls/get_my_reservations.dart';
import 'package:skywa/api_calls/get_single_reservation.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/api_responses/reservations.dart';
import 'package:skywa/components/businessWidget.dart';
import 'package:skywa/screens/current_sreen.dart';

class CustomCalledInDialog extends StatefulWidget {
  const CustomCalledInDialog({Key key}) : super(key: key);

  @override
  _CustomCalledInDialogState createState() => _CustomCalledInDialogState();
}

class _CustomCalledInDialogState extends State<CustomCalledInDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Okay'),
        )
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
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Icon(Icons.meeting_room , size: 40.0, color: Colors.white,),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Text(
                    'Called In',
                    style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'We are ready for you please walk to the entrance.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black87,
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

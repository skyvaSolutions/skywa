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

class CustomDialog extends StatefulWidget {
  final Function() goToAppointmentScreen;
  final String companyName;
  final String reservationDate ;
  final String reservationTime ;
  final Function() goToCurrentScreen;
  final bool returnBack;
  const CustomDialog({Key key , this.goToAppointmentScreen , @required this.companyName ,  this.reservationDate , this.reservationTime , this.goToCurrentScreen , this.returnBack}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () async{
              // await getMyReservations.findReservations();
              // if(myReservations.reservationsLength == 1){
              //   //await getSingleReservation.getParticularReservation(myReservations.reservationsList[0].ReservationID);
              //
              //   if(widget.goToCurrentScreen != null)
              //     widget.goToCurrentScreen();
              // }
              // else{
              // }
              if(widget.goToAppointmentScreen != null)
                if(widget.returnBack)
                  Navigator.pop(context);
                widget.goToAppointmentScreen();
              Navigator.pop(context);
              },
            child: Text('Done'),
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
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Your appointment is confirmed on ' ,
                        style: TextStyle(
                        fontSize: 15.0,
                          color: Colors.black87
                      ),),
                      if(widget.reservationDate != null)
                      TextSpan(
                        text: widget.reservationDate,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Colors.black
                          ),),
                      if(widget.reservationDate != null && widget.reservationTime != null)
                      TextSpan(
                        text: ' at ',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87
                        ),
                      ),
                      if(widget.reservationTime != null)
                      TextSpan(
                        text: widget.reservationTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black
                        ),),
                      TextSpan(
                        text: '. Kindly be on time and wait for your turn to be called.',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87
                        ),
                      ),
                    ],

                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'For any queries, you may reach out to us via chat or call.',
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/api_calls/get_single_reservation.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/components/show_more_info_dialog.dart';
import 'package:skywa/screens/past_appointment_screen.dart';
import 'package:skywa/screens/upcoming_appointment_screen.dart';

class AppointmentTab extends StatefulWidget {
  final id , name, address , tab ;
  final Function() goToCurrentScreen;
  final Function() refreshParent;

  AppointmentTab({Key key, this.id ,this.name, this.address , this.tab , this.goToCurrentScreen , this.refreshParent}) : super(key: key);

  @override
  _AppointmentTabState createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 20,
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  widget.address.toString().trim(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      fontSize: 15.2, fontWeight: FontWeight.w300),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () async {
                    if(widget.tab == 0){
                     Map<String , String> particularReservationValues =  await getSingleReservation.getParticularReservation(widget.id);
                     print(particularReservationValues);
                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                         PastAppointment(
                           id : widget.id,
                           companyName: particularReservationValues['Company name'],
                           reservationDateTime: particularReservationValues['Reservation DateTime'],
                           reservationStatus: particularReservationValues['Status'],
                           refreshParent : widget.refreshParent,
                         )));
                    }
                    else if(widget.tab == 1){
                      if(widget.goToCurrentScreen != null){
                        currentReservation.CurrentReservationId = widget.id;
                        widget.goToCurrentScreen();
                      }
                    }
                    else if(widget.tab ==2 ){
                      Map<String , String> particularReservationValues =  await getSingleReservation.getParticularReservation(widget.id);
                      print(particularReservationValues);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                          UpcomingAppointment(
                            id : widget.id,
                            companyName: particularReservationValues['Company name'],
                            reservationDateTime: particularReservationValues['Reservation DateTime'],
                            reservationStatus: particularReservationValues['Status'],
                            refreshParent : widget.refreshParent,
                          )));

                    }
                  },
                  child: widget.tab != 1 ? Text("Show") : Text("Join"),
                )),
          ),
        ),
      ),
    );
    ;
  }
}

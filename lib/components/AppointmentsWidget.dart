import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/api_calls/get_single_reservation.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/components/show_more_info_dialog.dart';
import 'package:skywa/screens/past_appointment_screen.dart';
import 'package:skywa/screens/upcoming_appointment_screen.dart';

class AppointmentTab extends StatefulWidget {
  final id , name, address , tab , status;
  final Function() goToCurrentScreen;
  final Function() refreshParent;

  AppointmentTab({Key key, this.id ,this.name, this.address , this.tab , this.goToCurrentScreen , this.refreshParent , this.status}) : super(key: key);

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
              horizontalTitleGap: 10,
                title: Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.address.toString().trim(),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontSize: 15.2, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    if(widget.tab ==1 )
                    Text(
                      widget.status,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold,
                        color: widget.status == "Not Arrived" ? Theme.of(context).primaryColor : Color(0xFF3CD1BB),
                      ),
                    )
                  ],
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
                      if(widget.id != currentReservation.CurrentReservationId && currentReservation.currentRes.MemberState != "Not Arrived"){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            content: RichText(
                              text: TextSpan(
                                text: 'You already have an appointment set up at ',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black87
                                ),
                                children:  <TextSpan>[
                                  TextSpan(text: currentReservation.currentRes.CompanyName, style: TextStyle(fontWeight: FontWeight.bold , fontSize: 17.0 , color: Colors.black87)),
                                  TextSpan(text: " in " , style: TextStyle(fontSize: 17.0 , color: Colors.black87)),
                                  TextSpan(text: currentReservation.currentRes.MemberState, style: TextStyle(fontWeight: FontWeight.bold , fontSize: 17.0 , color: Color(0xFF3CD1BB))),
                                  TextSpan(text: " state " , style: TextStyle(fontSize: 17.0 , color: Colors.black87)),
                                  TextSpan(text: ". \n\nDo you still wish to switch to another appointment?" , style: TextStyle(fontSize: 17.0 , color: Colors.black87)),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                child: Text(
                                'No',
                                  style: GoogleFonts.poppins(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17.0
                                  ),
                              ),
                              ),
                              TextButton(
                                onPressed: (){
                                  if(widget.goToCurrentScreen != null){
                                    currentReservation.CurrentReservationId = widget.id;
                                    widget.goToCurrentScreen();
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Yes',
                                  style: GoogleFonts.poppins(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 17.0
                                  ),
                                ),
                              ),

                            ],
                          );
                        } );
                      }
                      else{
                        if(widget.goToCurrentScreen != null){
                          currentReservation.CurrentReservationId = widget.id;
                          widget.goToCurrentScreen();
                        }
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
                  child: Text("Show"),
                )

            ),
          ),
        ),
      ),
    );
  }
}

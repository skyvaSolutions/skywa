import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/api_calls/delete_reservation.dart';
import 'package:skywa/components/businessWidget.dart';
import 'package:skywa/components/footer_tile.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/screens/questionairre_screen.dart';

import 'appointment_status.dart';

Map<String , String> resDateTimeProper = {};

class PastAppointment extends StatefulWidget {
  final String id;
  final String companyName;
  final String reservationDateTime;
  final String reservationStatus;
  final Function() refreshParent;
  const PastAppointment({Key key , this.id,this.companyName , this.reservationDateTime , this.reservationStatus , this.refreshParent }) : super(key: key);

  @override
  _PastAppointmentState createState() => _PastAppointmentState();
}

class _PastAppointmentState extends State<PastAppointment> {
  @override
  Widget build(BuildContext context) {
    resDateTimeProper = convertDateToProperFormat(convertDateFromString(widget.reservationDateTime));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Past Appointments',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset(
                          "assets/images/image-placeholder.png",
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.grey.withOpacity(0.5),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                    child: Icon(Icons.warning),
                    width: 90,
                    height: 90,
                  ),
                  imageUrl: [
                    "http://nebula.wsimg.com/f8718f1686ddf5364fb59d810396dfd8?AccessKeyId=7308F00505C458ECD224&disposition=0&alloworigin=1",
                    "https://images1-fabric.practo.com/practices/1255057/dr-maneesha-singh-clinic-gynaecologist-ghaziabad-5cc44e9a814e8.jpg",
                    "https://www.thedoctorsclinic.com/images/content/Cardiology%20Waiting%20Room.jpg"
                  ][DB.box.get(DB.index) % 3],
                  height: MediaQuery.of(context).size.height * 0.35,
                  fit: BoxFit.fill,
                ),
                Spacer(),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.35 - 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10) , topLeft: Radius.circular(10)),
                    color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0 , right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60.0,
                      ),
                      Center(
                        child: Text(widget.companyName , style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reservation Date : ' , style: GoogleFonts.poppins(
                            fontSize: 17.0
                          ),),

                          Text(resDateTimeProper['Date'], style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                              fontSize: 17.0
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reservation Time : ' , style: GoogleFonts.poppins(
                              fontSize: 17.0
                          ),),

                          Text(resDateTimeProper['Time'], style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reservation Status : ' , style: GoogleFonts.poppins(
                              fontSize: 17.0
                          ),),
                          Text(widget.reservationStatus , style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            color: Colors.green[800]
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          child: FooterTile(
                            icon: Icons.person,
                            text: 'View Filled Forms',
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QuestionnairePage(
                                    pageNum: 0,
                                  )));
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            size: 50.0,
                                            color: cancelColor,
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            'Delete Reservation',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            'Are you sure you want to permanently delete this Reservation.',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    titlePadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 20.0),
                                    contentPadding: EdgeInsets.all(10.0),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await deleteReservation.deleteParticularRes(widget.id);
                                          //await Provider.of<appointmentScreenProvider>(context).getReservations();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          widget.refreshParent();
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(cancelColor),
                                        ),
                                      )
                                    ],
                                  );
                                }
                            );
                          },
                          child: Text(
                            'Delete this Reservation',
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(cancelColor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.35 - 70,
              left: MediaQuery.of(context).size.width*0.5 - 50,
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: [ Color(0xFF4C44B3),
                    Color(0xFF3CD1BB),
                  ][DB.box.get(DB.index) % 2],
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Center(
                  child: Text(
                    getInitials(widget.companyName),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

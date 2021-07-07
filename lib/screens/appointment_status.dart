import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/loading_provider.dart';
import 'package:skywa/Providers/member_state_changed.dart';
import 'package:skywa/api_calls/add_update_reservation.dart';
import 'package:skywa/api_calls/delete_reservation.dart';
import 'package:skywa/api_calls/get_single_reservation.dart';
import 'package:skywa/api_calls/q_meta_data.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/components/show_called_in_dialog.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:skywa/services/locationServices.dart';
import 'package:skywa/utils/open_google_map.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

const completeColor = Color(0xFF4C44B3);

const inProgressColor = Color(0xFF3CD1BB);

const todoColor = Color(0xFFD4D3EE);

const cancelColor = Color(0xFFEDAF11);

double latitude;

double longitude;

bool stopDistanceTimer = false;
bool stopArrivedTimer = false;
int showDialogOnce = 0;



void callUpdateReservationApi(Map<String, dynamic> reservationValues) async {
  await addUpdateReservation.addUpdateRes(reservationValues);
  await getSingleReservation.getCurrentReservation();
}

List<IconData> timelineIcons = [
  Icons.post_add,
  Icons.place,
  Icons.meeting_room,
  Icons.people_sharp,
  Icons.check_circle
];

Future<void> getLocation () async {
    Location l = new Location();
    await l.getCurrentLocation();
    latitude = l.p.latitude;
    longitude = l.p.longitude;
}

 Map<String, dynamic> resObject() {
  Map<String, dynamic> reservationValues = {};
  reservationValues["DeviceID"] = currentReservation.currentRes.DeviceID;
  reservationValues["QID"] = currentReservation.currentRes.QID;
  reservationValues["MemberState"] = "Arrived";
  reservationValues["ReservationID"] =
      currentReservation.currentRes.ReservationID;
  reservationValues["ReservationStartTime"] =
      currentReservation.currentRes.ReservationStartTime;
  reservationValues["ReservationType"] =
      currentReservation.currentRes.ReservationType;
  reservationValues["Latitude"] = latitude.toString();
  reservationValues["Longitude"] = longitude.toString();
  reservationValues["NumberOfPeopleOnReservation"] =
      currentReservation.currentRes.NumberOfPeopleOnReservation;
  reservationValues["AttendeeData"] =
      currentReservation.currentRes.AttendeeData;
  return reservationValues;
}

class AppointmentStatus extends StatefulWidget {
  final Function() notifyGrandParent;
  const AppointmentStatus({Key key ,@required this.notifyGrandParent}) : super(key: key);
  @override
  _AppointmentStatusState createState() => _AppointmentStatusState();
}

class _AppointmentStatusState extends State<AppointmentStatus> {
  Color getColor(int index) {
    if(context.read<MemberStateChanged>().statusIndex == 4 )
      return completeColor;
    else if  (index == context.read<MemberStateChanged>().statusIndex) {
      return inProgressColor;
    } else if (index < context.read<MemberStateChanged>().statusIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  refresh(){
    setState(() {
    });
  }

  Future<void> checkStateAfterArrival() async {
    if(currentReservation.currentRes.MemberState == "Arrived" || currentReservation.currentRes.MemberState == "Called to Enter" || currentReservation.currentRes.MemberState == "In Facility" ){
      await getSingleReservation.getCurrentReservation();
      if(currentReservation.currentRes.MemberState == "Called to Enter"){
        showDialogOnce = showDialogOnce + 1;
        Provider.of<MemberStateChanged>(context, listen: false).changeStatusIndex(2);
        setState(() {

        });
        if(showDialogOnce == 1){
          showDialog(context: context, builder: (BuildContext){
            return CustomCalledInDialog();
          });
        }
      }
      if(currentReservation.currentRes.MemberState == "In Facility"){
        Provider.of<MemberStateChanged>(context, listen: false).changeStatusIndex(3);
        setState(() {

        });
      }
      if(currentReservation.currentRes.MemberState == "Completed"){
        Provider.of<MemberStateChanged>(context, listen: false).changeStatusIndex(4);
        stopArrivedTimer = true;
        setState(() {

        });
      }
    }
  }

  Future<void> checkForDistance() async {
    if(currentReservation.currentRes.MemberState == "Not Arrived"){
      double calculatedDistance = await qMetaData.calculateDistance();
      if (calculatedDistance != -1) {
        if (calculatedDistance <= qMetaData.parkingLotDistance) {
          Map<String, dynamic> reservationValues = resObject();
          await addUpdateReservation.addUpdateRes(reservationValues);
          await getSingleReservation.getCurrentReservation();
          context.watch<MemberStateChanged>().changeStatusIndex(1);
          stopDistanceTimer = true;
          setUpTimedFetch();
          setState(() {});
        }
      }
    }
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 10000), (timer) {
      if (stopArrivedTimer) {
        timer.cancel();
      }
      checkStateAfterArrival();
    });
  }

  setUpTimedDistanceFetch() {
    Timer.periodic(Duration(minutes: 2), (timer) {
      if (stopDistanceTimer) {
        timer.cancel();
      }
      checkForDistance();
    });
  }

  @override
  void initState() {
    super.initState();
    setUpTimedDistanceFetch();
    setUpTimedFetch();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MemberStateChanged>(context , listen: false).initializeProvider();
    Provider.of<LoadingScreen>(context , listen: false).initializeUpdateProvider();
    return Center(
      child: Column(
        children: [
          //ButtonRow(),
          if (currentReservation.currentRes.MemberState == "Arrived")
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Expected Wait : ' +
                    currentReservation.currentRes.WaitTime.toString() +
                    " minutes",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Timeline.tileBuilder(
              theme: TimelineThemeData(
                direction: Axis.horizontal,
                connectorTheme: ConnectorThemeData(
                  space: 30.0,
                  thickness: 5.0,
                ),
              ),
              builder: TimelineTileBuilder.connected(
                connectionDirection: ConnectionDirection.before,
                itemExtentBuilder: (_, __) =>
                    MediaQuery.of(context).size.width / _processes.length,
                oppositeContentsBuilder: (context, index) {
                  print(Provider.of<MemberStateChanged>(context).statusIndex);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Icon(
                      timelineIcons[index],
                      color: getColor(index),
                      size: 30.0,
                    ),
                  );
                },
                contentsBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      _processes[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColor(index),
                      ),
                    ),
                  );
                },
                indicatorBuilder: (_, index) {
                  var color;
                  var child;
                  if(context.read<MemberStateChanged>().statusIndex == 4 ){
                   color = completeColor;
                  }
                  else if (index == context.read<MemberStateChanged>().statusIndex) {
                    color = inProgressColor;
                  } else if (index <
                      context.read<MemberStateChanged>().statusIndex) {
                    color = completeColor;
                  } else {
                    color = todoColor;
                  }

                  if (index <= context.read<MemberStateChanged>().statusIndex) {
                    return Stack(
                      children: [
                        DotIndicator(
                          size: 15.0,
                          color: color,
                          child: child,
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        OutlinedDotIndicator(
                          borderWidth: 4.0,
                          color: color,
                        ),
                      ],
                    );
                  }
                },
                connectorBuilder: (_, index, type) {
                  if (index > 0) {
                    if (index == context.read<MemberStateChanged>().statusIndex) {
                      final prevColor = getColor(index - 1);
                      final color = getColor(index);
                      List<Color> gradientColors;
                      if (type == ConnectorType.start) {
                        gradientColors = [
                          Color.lerp(prevColor, color, 0.5),
                          color
                        ];
                      } else {
                        gradientColors = [
                          prevColor,
                          Color.lerp(prevColor, color, 0.5)
                        ];
                      }
                      return DecoratedLineConnector(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                          ),
                        ),
                      );
                    } else {
                      return SolidLineConnector(
                        color: getColor(index),
                      );
                    }
                  } else {
                    return null;
                  }
                },
                itemCount: _processes.length,
              ),
            ),
          ),
          StatusMessage(
            updateParent: refresh,
            notifyGrandParent: widget.notifyGrandParent,
          ),
        ],
      ),
    );
  }
}


class StatusMessage extends StatefulWidget {
  final Function() updateParent;
  final Function() setUpTimedFetch ;
  final Function() notifyGrandParent;
  const StatusMessage({Key key , @required this.updateParent ,  this.setUpTimedFetch , @required this.notifyGrandParent}) : super(key: key);

  @override
  _StatusMessageState createState() => _StatusMessageState();
}

class _StatusMessageState extends State<StatusMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              color:  inProgressColor,
            ),
            child: Text(
              statusMess[context.read<MemberStateChanged>().statusIndex],
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          if (context.read<MemberStateChanged>().statusIndex == 0)
            Column(
              children: [
                if(context.read<LoadingScreen>().updateReservationLoading)
                  CircularProgressIndicator(color: Theme.of(context).primaryColor,backgroundColor: Colors.white,),
                if(!context.read<LoadingScreen>().updateReservationLoading)
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    tileColor: todoColor,
                      contentPadding: EdgeInsets.all(20.0),
                     subtitle: Text(
                         'Arrived at the business? Click on Arrived to manually update it.',
                       style: TextStyle(
                         fontSize: 15.0,
                       ),
                     ),
                     trailing : ElevatedButton(
                        onPressed: ()
                        async {
                          print(currentReservation.currentRes.DeviceID);
                          Map<String, dynamic> reservationValues = resObject();
                          setState(() {
                            Provider.of<LoadingScreen>(context , listen: false).changeUpdateReservationLoading();
                          });
                          await addUpdateReservation.addUpdateRes(reservationValues);
                          await getSingleReservation.getCurrentReservation();
                          setState(() {
                            Provider.of<LoadingScreen>(context , listen: false).changeUpdateReservationLoading();
                          });
                          if (currentReservation.currentRes.MemberState == "Arrived"){
                            Provider.of<MemberStateChanged>(context, listen: false).changeStatusIndex(1);
                          }
                          Provider.of<LoadingScreen>(context , listen: false).changeUpdateReservationLoading();
                          widget.updateParent();
                        },
                        child: Text(
                          'Arrived',
                        ),
                      ),
                  ),
              ],
            ),
          if(context.read<MemberStateChanged>().statusIndex == 4)
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              tileColor: todoColor,
              contentPadding: EdgeInsets.all(20.0),
              subtitle: Text(
                'Your appointment is completed. Fetch your next reservation',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              trailing : ElevatedButton(
                onPressed: ()
                async {
                  getAndSortReservations();
                  widget.notifyGrandParent();

                },
                child: Text(
                  'Update',
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)
                ),
              ),
            )
        ],
      ),
    );
  }
}


class ButtonRow extends StatefulWidget {
  final Function() goToAppointmentScreen;
  const ButtonRow({Key key , this.goToAppointmentScreen}) : super(key: key);

  @override
  _ButtonRowState createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextButton(
              onPressed: (){
               _modalBottomSheetMenu(context);
              },
              child: Text(
                  'Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
          ),
          ElevatedButton(
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
                            await deleteReservation.deleteRes();
                            stopArrivedTimer = true;
                            stopDistanceTimer = true;
                            currentReservation.CurrentReservationId = null;
                            widget.goToAppointmentScreen();
                            Navigator.pop(context);
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
              'Delete',
            ),
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(cancelColor)),
          ),
        ],
      ),
    );
  }
}


final _processes = [
  'Checked In',
  'Arrived',
  'Called In',
  'In Facility',
  'Completed',
];

final statusMess = [
  'You have not arrived at the Business, once you arrive the business will be notified that you are ready for your appointment.',
  'You have arrived for the appointment. please wait near by until called.',
  'We are ready for you please walk to the entrance.',
  'Your appointment is in progress.',
  'Your appointment is completed',
];


void _modalBottomSheetMenu(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          height: MediaQuery.of(context).size.height*0.3,
          color: Color(0xFF737373),
          child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Center(
                child: new Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.directions ,  color: Theme.of(context).primaryColor,),
                      title: Text('Directions' , style: TextStyle(fontWeight: FontWeight.bold),),
                      trailing: Icon(Icons.arrow_forward_ios),
                      tileColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      horizontalTitleGap: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> OpenGMap()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.chat ,  color: Theme.of(context).primaryColor,),
                      title: Text('Chat with business' , style: TextStyle(fontWeight: FontWeight.bold),),
                      trailing: Icon(Icons.arrow_forward_ios),
                      tileColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      horizontalTitleGap: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: (){},
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.phone_in_talk ,  color: Theme.of(context).primaryColor,),
                      title: Text('Call Business' , style: TextStyle(fontWeight: FontWeight.bold),),
                      trailing: Icon(Icons.arrow_forward_ios),
                      tileColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      horizontalTitleGap: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: (){},
                    ),
                  ],
                ),
              )),
        );
      });
}



//Color(0xff5ec792);
//Color(0xff878890);
//Color(0xff878890);
//Color(0xff5ec792);

// reservationValues["QJoinTime"] =
//     currentReservation.currentRes.QJoinTime;
// reservationValues["OriginalETA"] =
//     currentReservation.currentRes.OriginalIETA;
// reservationValues["LatestETA"] =
//     currentReservation.currentRes.LatestETA;

// reservationValues["MemberQueuePosition"] =
//     currentReservation.currentRes.MemberQueuePosition;
// reservationValues["LastReportedLocationTimeStamp"] =
//     currentReservation
//         .currentRes.LastReportedLocationStamp;
// reservationValues["LastReportedLocationAccuracy"] =
//     currentReservation
//         .currentRes.LastReportedLocationAccuracy;
// reservationValues["NoShowCount"] =
//     currentReservation.currentRes.NoShowCount;

// reservationValues["MemberStateUpdateTimeStamp"] =
//     currentReservation
//         .currentRes.MemberStateUpdateTimeStamp;
// reservationValues["WaitTime"] =
//     currentReservation.currentRes.WaitTime;

// reservationValues["PhoneNumber"] =
//     currentReservation.currentRes.PhoneNumber;

// reservationValues["ReservationCreatedTimeStamp"] =
//     currentReservation
//         .currentRes.ReservationCreatedTimeStamp;
// reservationValues["ReservationUpdatedTimeStamp"] =
//     currentReservation
//         .currentRes.ReservationUpdatedTimeStamp;
// reservationValues["CompanyName"] =
//     currentReservation.currentRes.CompanyName;
// reservationValues["LocationName"] =
//     currentReservation.currentRes.LocationaName;
// reservationValues["Address"] =
//     currentReservation.currentRes.Address;
// reservationValues["CompanyLogoURL"] =
//     currentReservation.currentRes.CompanyLogoURL;
// reservationValues["QName"] =
//     currentReservation.currentRes.QName;
// reservationValues["AuthorizedUsers"] =
//     currentReservation.currentRes.AuthorizedUsers;

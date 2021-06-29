import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/member_state_changed.dart';
import 'package:skywa/api_calls/add_update_reservation.dart';
import 'package:skywa/api_calls/delete_reservation.dart';
import 'package:skywa/api_calls/get_single_reservation.dart';
import 'package:skywa/api_calls/q_meta_data.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

const completeColor = Colors.teal;

const inProgressColor = Color(0xFFFFA63C);

const todoColor = Color(0xffd1d2d7);

bool stopDistanceTimer = false;
bool stopArrivedTimer = true;//todo

void callUpdateReservationApi(Map<String, dynamic> reservationValues) async {
  await addUpdateReservation.addUpdateRes(reservationValues);
  await getSingleReservation.getCurrentReservation();
}

List<IconData> timelineIcons = [
  Icons.check_circle,
  Icons.place,
  Icons.meeting_room,
  Icons.airline_seat_recline_normal
];

Map<String, dynamic> resObject() {
  Map<String, dynamic> reservationValues = {};
  reservationValues["DeviceID"] = currentReservation.currentRes.DevideID;
  reservationValues["QID"] = currentReservation.currentRes.QID;
  reservationValues["MemberState"] = "Arrived";
  reservationValues["ReservationID"] =
      currentReservation.currentRes.ReservationID;
  reservationValues["ReservationStartTime"] =
      currentReservation.currentRes.ReservationStartTime;
  reservationValues["ReservationType"] =
      currentReservation.currentRes.ReservationType;
  reservationValues["Latitude"] = currentReservation.currentRes.Latitude;
  reservationValues["Longitude"] = currentReservation.currentRes.Longitude;
  reservationValues["NumberOfPeopleOnReservation"] =
      currentReservation.currentRes.NumberOfPeopleOnReservation;
  reservationValues["AttendeeData"] =
      currentReservation.currentRes.AttendeeData;
  return reservationValues;
}

class AppointmentStatus extends StatefulWidget {
  @override
  _AppointmentStatusState createState() => _AppointmentStatusState();
}

class _AppointmentStatusState extends State<AppointmentStatus> {
  Color getColor(int index) {
    if (index == context.read<MemberStateChanged>().statusIndex) {
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
    await getSingleReservation.getCurrentReservation();
    if (currentReservation.currentRes.MemberState == "Called To Enter") {
      stopArrivedTimer = true;
      setState(() {});
    }
  }

  Future<void> checkForDistance() async {
    double calculatedDistance = await qMetaData.calculateDistance();
    if (calculatedDistance != -1) {
      if (calculatedDistance <= qMetaData.parkingLotDistance) {
        Map<String, dynamic> reservationValues = resObject();
        await addUpdateReservation.addUpdateRes(reservationValues);
        await getSingleReservation.getCurrentReservation();
        stopDistanceTimer = true;
        setState(() {});
      }
    }
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 5000), (timer) {
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
    if (currentReservation.currentRes.MemberState == "Arrived")
      setUpTimedFetch();
    if (currentReservation.currentRes.MemberState == "Not Arrived")
      setUpTimedDistanceFetch();
  }

  @override
  Widget build(BuildContext context) {
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
                  if (index == context.read<MemberStateChanged>().statusIndex) {
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
          ),
        ],
      ),
    );
  }
}


class StatusMessage extends StatefulWidget {
  final Function() updateParent;
  const StatusMessage({Key key , @required this.updateParent}) : super(key: key);

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
              color: Color(0xFFFFA63C),
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
            height: 20.0,
          ),
          if (context.read<MemberStateChanged>().statusIndex == 0)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.place,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Text(
                        'Reached the business but appointment status is not updated. Manually update the status.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print(currentReservation.currentRes.DevideID);
                        Map<String, dynamic> reservationValues = resObject();
                        await addUpdateReservation.addUpdateRes(reservationValues);
                        await getSingleReservation.getCurrentReservation();
                        if (currentReservation.currentRes.MemberState == "Arrived"){
                          Provider.of<MemberStateChanged>(context, listen: false).changeStatusIndex(1);
                        }
                        widget.updateParent();
                      },
                      child: Text(
                        'Arrived',
                      ),
                    ),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}


class ButtonRow extends StatefulWidget {
  final Function() notifyParent;
  const ButtonRow({Key key , @required this.notifyParent}) : super(key: key);

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
            IconButton(
              onPressed: () {
                //MapUtils.openMap(31.968599, -99.901810);
              },
              icon: Icon(Icons.directions),
              iconSize: 30.0,
              color: Theme.of(context).primaryColor,

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
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Delete Reservation',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[850],
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Are you sure you want to permanently delete this Reservation.',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey[800],
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
                            widget.notifyParent();
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
                            MaterialStateProperty.all(Colors.redAccent),
                          ),
                        )
                      ],
                    );
                  }
              );
            },
            child: Text(
              'Cancel',
            ),
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.redAccent)),
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
];

final statusMess = [
  'You have not arrived at the Business, once you arrive the business will be notified that you are ready for your appointment.',
  'You have arrived for the appointment. please wait near by until called.',
  'We are ready for you please walk to the entrance.',
  'Your appointment is in progress.',
];


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

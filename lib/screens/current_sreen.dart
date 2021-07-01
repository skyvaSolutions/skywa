import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/Providers/member_state_changed.dart';
import 'package:skywa/api_calls/get_my_reservations.dart';
import 'package:skywa/api_calls/get_single_reservation.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/api_responses/reservations.dart';
import 'package:skywa/components/businessWidget.dart';
import 'package:skywa/components/footer_tile.dart';
import 'package:skywa/components/show_more_info_dailog.dart';
import 'package:skywa/model/reservation.dart';
import 'package:skywa/screens/appointment_status.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/screens/questionairre_screen.dart';

bool isReservationToday = false;
bool showFooter = false;
bool customQuestionnaireVisited = false;

Future<void> _future;

List<Reservation> todayRes = [];

Future<void> getAndSortReservations() async {
  await getMyReservations.findReservations();
  isReservationToday = false;
  if (myReservations.noReservations == false) {
    for (int i = 0; i < myReservations.reservationsList.length; i++) {
      if (myReservations.reservationsList[i].MemberState
              .compareTo("Completed") !=
          0) {
        DateTime today = DateTime.now();
        int todayDay = today.day;
        int todayMonth = today.month;
        int todayYear = today.year;
        DateTime reservationTime = convertDateFromString(
            myReservations.reservationsList[i].ReservationStartTime);
        int resDay = reservationTime.day;
        int resMonth = reservationTime.month;
        int resYear = reservationTime.year;
        todayRes.add(myReservations.reservationsList[i]);
        if (resDay == todayDay &&
            resMonth == todayMonth &&
            resYear == todayYear) {
          print(myReservations.reservationsList[i].MemberState);
          todayRes.add(myReservations.reservationsList[i]);
        }
      }
    }
    print(todayRes.length);
    if (todayRes.length >= 1) {
      isReservationToday = true;
      todayRes.sort((res1, res2) =>
          convertDateFromString(res1.ReservationStartTime)
              .compareTo(convertDateFromString(res2.ReservationStartTime)));
      print(todayRes[0].ReservationStartTime);
      print(todayRes[0].MemberState);
      currentReservation.CurrentReservationId = todayRes[0].ReservationID;
      currentReservation.QId = todayRes[0].QID;
      await getSingleReservation.getCurrentReservation();
    }
  }
}

class CurrentScreen extends StatefulWidget {
  @override
  _CurrentScreenState createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  setUpApiCall() {
    setState(() {
      _future = getAndSortReservations();
    });
  }

  @override
  void initState() {
    super.initState();
    setUpApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Image.asset(
                      'assets/images/loading.png',
                    ),
                  ),
                  Text(
                    'Fetching your current Reservation...',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.hasError) {
              print(snapshot);
              return Center(child: Text(snapshot.error.toString()));
            } else {
              if (myReservations.noReservations == true ||
                  isReservationToday == false ||
                  todayRes.length == 0) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Image.asset(
                          'assets/images/no_reservations.png',
                        ),
                      ),
                      Text(
                        'No Reservations for today.',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (myReservations.noReservations == false) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider<MemberStateChanged>(
                        create: (context) => MemberStateChanged()),
                  ],
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Header(
                        notifyParent: setUpApiCall,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 1.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      AppointmentStatus(
                        notifyGrandParent: setUpApiCall,
                      ),
                      Footer(),
                    ],
                  ),
                );
              } else
                return Container();
            }
          }
        });
  }
}

class Header extends StatefulWidget {
  final Function() notifyParent;
  const Header({Key key, @required this.notifyParent}) : super(key: key);
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.0),
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                color: Color(0xFF3CD1BB),
                borderRadius: BorderRadius.circular(80),
              ),
              child: Center(
                child: Text(
                  getInitials(currentReservation.currentRes.CompanyName),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    currentReservation.currentRes.CompanyName,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                AppointmentDateTime(),
              ],
            ),
          ],
        ),
        ButtonRow(notifyParent: widget.notifyParent),
      ],
    );
  }
}

class AppointmentDateTime extends StatefulWidget {
  @override
  _AppointmentDateTimeState createState() => _AppointmentDateTimeState();
}

Map<String, String> convertDateToProperFormat(DateTime dateCon) {
  int resDay = dateCon.day;
  int resMonth = dateCon.month;
  int resHour = dateCon.hour;
  int resMin = dateCon.minute;
  int resSec = dateCon.second;

  String resDayStr = resDay < 10 ? "0" + resDay.toString() : resDay.toString();
  String resMonthStr =
      resMonth < 10 ? "0" + resMonth.toString() : resMonth.toString();

  String resHourStr =
      resHour < 10 ? "0" + resHour.toString() : resHour.toString();
  String resMinStr = resMin < 10 ? "0" + resMin.toString() : resMin.toString();
  String resSecStr = resSec < 10 ? "0" + resSec.toString() : resSec.toString();

  String date = resDayStr + "-" + resMonthStr + "-" + dateCon.year.toString();
  String time = resHourStr + ":" + resMinStr + ":" + resSecStr;
  Map<String, String> convertedDateTime = {};
  convertedDateTime['Date'] = date;
  convertedDateTime['Time'] = time;
  return convertedDateTime;
}

class _AppointmentDateTimeState extends State<AppointmentDateTime> {
  @override
  Widget build(BuildContext context) {
    DateTime dateCon = convertDateFromString(
        currentReservation.currentRes.ReservationStartTime);

    Map<String, String> resDateTime = convertDateToProperFormat(dateCon);
    String date = resDateTime['Date'];
    String time = resDateTime['Time'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date : $date',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Time : $time',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          FooterTile(
            icon: Icons.info,
            text: 'More Information',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      companyName: currentReservation.currentRes.CompanyName,
                    );
                  });
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          FooterTile(
            icon: Icons.person,
            text: 'Forms',
            onPressed: () {
              setState(() {
                customQuestionnaireVisited = true;
              });
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuestionnairePage(
                        pageNum: 0,
                      )));
            },
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

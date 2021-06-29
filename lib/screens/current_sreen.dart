import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/member_state_changed.dart';
import 'package:skywa/api_calls/delete_reservation.dart';
import 'package:skywa/api_calls/get_my_reservations.dart';
import 'package:skywa/api_calls/get_single_reservation.dart';
import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/api_responses/reservations.dart';
import 'package:skywa/model/reservation.dart';
import 'package:skywa/screens/appointment_status.dart';
import 'package:skywa/screens/homeScreen.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/screens/questionairre_screen.dart';

bool isReservationToday = false;
bool showFooter = false;
bool customQuestionnaireVisited = false;

Future<void> _future;



Future<void> getAndSortReservations() async {
  await getMyReservations.findReservations();
  List<Reservation> todayRes = [];
  if (myReservations.noReservations == false) {
    for (int i = 0; i < myReservations.reservationsList.length; i++) {
      DateTime today = DateTime.now();
      int todayDay = today.day;
      int todayMonth = today.month;
      int todayYear = today.year;
      DateTime reservationTime = convertDateFromString(
          myReservations.reservationsList[i].ReservationStartTime);
      print("$i th time" + reservationTime.toString());
      int resDay = reservationTime.day;
      int resMonth = reservationTime.month;
      int resYear = reservationTime.year;
      todayRes.add(myReservations.reservationsList[i]);
      if (resDay == todayDay &&
          resMonth == todayMonth &&
          resYear == todayYear) {
        print(resDay);
        print(resYear);
        print(resMonth);
        todayRes.add(myReservations.reservationsList[i]);
      }
    }
    print(todayRes.length);
    if (todayRes.length >= 1) {
      isReservationToday = true;
      todayRes.sort((res1, res2) =>
          convertDateFromString(res1.ReservationStartTime)
              .compareTo(convertDateFromString(res2.ReservationStartTime)));
      print(todayRes[0].ReservationStartTime);
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
                  SizedBox(height: 10.0,),
                  CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                ],
              ),
            );
          } else {
            if (snapshot.hasError) {
              print(snapshot);
              return Center(child: Text(snapshot.error.toString()));
            } else {
              if (myReservations.noReservations == true ||
                  isReservationToday == false) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Header(notifyParent: setUpApiCall,),
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
                      AppointmentStatus(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Footer(),
                          ],
                        ),
                      ),
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
  const Header({Key key , @required this.notifyParent}) : super(key: key);
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
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                      scale: 1,
                      image: NetworkImage(
                          "https://image.shutterstock.com/image-vector/medical-care-logo-design-260nw-1281695074.jpg"),
                      fit: BoxFit.scaleDown)),
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
                Text(
                  currentReservation.currentRes.CompanyName,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
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

Map<String , String> convertDateToProperFormat(DateTime dateCon){
  int resDay = dateCon.day;
  int resMonth = dateCon.month;
  int resHour = dateCon.hour;
  int resMin = dateCon.minute;
  int resSec = dateCon.second;

  String resDayStr =
  resDay < 10 ? "0" + resDay.toString() : resDay.toString();
  String resMonthStr =
  resMonth < 10 ? "0" + resMonth.toString() : resMonth.toString();

  String resHourStr =
  resHour < 10 ? "0" + resHour.toString() : resHour.toString();
  String resMinStr =
  resMin < 10 ? "0" + resMin.toString() : resMin.toString();
  String resSecStr =
  resSec < 10 ? "0" + resSec.toString() : resSec.toString();

  String date = resDayStr + "-" + resMonthStr + "-" + dateCon.year.toString();
  String time = resHourStr + ":" + resMinStr + ":" + resSecStr;
  Map<String , String> convertedDateTime = {};
  convertedDateTime['Date'] = date;
  convertedDateTime['Time'] = time;
  return convertedDateTime;
}

class _AppointmentDateTimeState extends State<AppointmentDateTime> {
  @override
  Widget build(BuildContext context) {
    DateTime dateCon = convertDateFromString(
        currentReservation.currentRes.ReservationStartTime);

   Map<String , String> resDateTime = convertDateToProperFormat(dateCon);
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info , color: Theme.of(context).primaryColor,),
            title: Text('More Information' , style: TextStyle(fontWeight: FontWeight.bold),),
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
            leading: Icon(Icons.person , color: Theme.of(context).primaryColor,),
            title: Text('Forms' , style: TextStyle(fontWeight: FontWeight.bold),),
            trailing: Icon(Icons.arrow_forward_ios),
            tileColor: Theme.of(context).primaryColor.withOpacity(0.3),
            horizontalTitleGap: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onTap: (){setState(() {
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
    );
  }
}


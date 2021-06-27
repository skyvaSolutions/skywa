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
import 'package:skywa/components/current_screen__circlular_buttons.dart';
import 'package:skywa/components/questionnaire_one.dart';
import 'package:skywa/model/reservation.dart';
import 'package:skywa/screens/appointment_status.dart';
import 'package:skywa/screens/homeScreen.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/screens/questionairre_screen.dart';


bool isReservationToday = false;
bool showFooter = false;
bool customQuestionnaireVisited = false;

Future<void> getAndSortReservations() async {
  await getMyReservations.findReservations();
  List<Reservation> todayRes = [];
  if (myReservations.noReservations == false) {
    for(int i =0;i<myReservations.reservationsList.length ; i++){
      DateTime today = DateTime.now();
      int todayDay = today.day;
      int todayMonth = today.month;
      int todayYear = today.year;
      DateTime reservationTime = convertDateFromString(myReservations.reservationsList[i].ReservationStartTime);
      int resDay = reservationTime.day;
      int resMonth = reservationTime.month;
      int resYear = reservationTime.year;
      if(resDay == todayDay && resMonth == todayMonth && resYear == todayYear){
        todayRes.add(myReservations.reservationsList[i]);
      }

    }
    if(todayRes.length >=1){
      isReservationToday = true;
      todayRes.sort((res1, res2) =>
          convertDateFromString(res1.ReservationStartTime)
              .compareTo(convertDateFromString(res2.ReservationStartTime)));
      print(todayRes[0].ReservationStartTime);
      currentReservation.CurrentReservationId =
          todayRes[0].ReservationID;
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getAndSortReservations(),
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
                    'Getting your current Reservation...',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error));
            } else {
              if (myReservations.noReservations == true || isReservationToday == false) {
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
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Column(
                          children: [
                            UpperContainer(),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(child: AppointmentStatus()),
                          ],
                        )),
                        Footer(),
                      ],
                    ),
                  ),
                );
              } else
                return Container();
            }
          }
        });
  }

  @override
  void initState() {
    super.initState();
    //callGetMyReservationsApi(context);
    // getMyReservations.findReservations(context);
  }
}

class UpperContainer extends StatefulWidget {
  @override
  _UpperContainerState createState() => _UpperContainerState();
}

class _UpperContainerState extends State<UpperContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 9,
                offset: Offset(4, 4) // changes position of shadow
                ),
          ],
          color: Theme.of(context).primaryColor),
      child: Header(),
    );
  }
}

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                height: 8.0,
              ),
              Text(
                currentReservation.currentRes.CompanyName,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
          AppointmentDateTime(),
        ],
      ),
    );
  }
}

class AppointmentDateTime extends StatefulWidget {
  @override
  _AppointmentDateTimeState createState() => _AppointmentDateTimeState();
}

class _AppointmentDateTimeState extends State<AppointmentDateTime> {
  @override
  Widget build(BuildContext context) {
    DateTime dateCon = convertDateFromString(
        currentReservation.currentRes.ReservationStartTime);

    int resDay = dateCon.day;
    int resMonth = dateCon.month;
    int resHour = dateCon.hour;
    int resMin = dateCon.minute;

    String resDayStr = resDay < 10 ? "0"+ resDay.toString() : resDay.toString();
    String resMonthStr = resMonth < 10 ? "0"+ resMonth.toString() : resMonth.toString();

    String resHourStr = resHour < 10 ? "0" + resHour.toString() : resHour.toString();
    String resMinStr = resMin < 10 ? "0" + resMin.toString() : resMin.toString();

    String date = resDayStr + "-" + resMonthStr + "-" + dateCon.year.toString();
    String time = resHourStr+ ":" + resMinStr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Date : $date',
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Time : $time',
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircularIconButtons(
            bg: Theme.of(context).primaryColor,
            icon: Icons.info,
            text: 'Information about Appointment',
            onPressed: (){},
          ),
          CircularIconButtons(
            bg: customQuestionnaireVisited ? Theme.of(context).primaryColor : Colors.redAccent,
            icon: Icons.question_answer,
            text : 'Complete Questionnaire',
            onPressed: () {
              setState(() {
                customQuestionnaireVisited = true;
              });
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionnairePage(pageNum: 0,)));
            },
          ),
          CircularIconButtons(
            bg: Colors.grey[400],
            icon: Icons.chat,
            text : 'Chat with Business',
            onPressed: (){},
          ),
          CircularIconButtons(
            bg: Theme.of(context).primaryColor,
            icon: Icons.phone_in_talk,
            text: 'Call Business',
            onPressed: (){},
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/appointmentScreenProvider.dart';
import 'package:skywa/Providers/appointment_tap_provider.dart';
import 'package:skywa/components/fetching_image_widget.dart';
import 'package:skywa/components/no_appointments_widget.dart';
import 'package:skywa/components/upcomingScreen.dart';

class Appointment extends StatefulWidget {
  final Function() goToCurrentScreen;
  const Appointment({Key key, this.goToCurrentScreen}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  void initState() {
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pa = Provider.of<appointmentScreenProvider>(context, listen: false);
    return DefaultTabController(
      initialIndex: context.read<AppointmentTabIndex>().tab,
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).primaryColor,
            tabs: <Widget>[
              Tab(
                text: "Past",
              ),
              Tab(
                text: "Active",
              ),
              Tab(
                text: "Upcoming",
              ),
            ],
          ),
        ),
        body: FutureBuilder<bool>(
            future:
                Provider.of<appointmentScreenProvider>(context, listen: false)
                    .getReservations(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return FetchingScreen(
                    imagePath: 'assets/images/fetching.png',
                    displayText: 'Fetching your appointments',
                  );
                case ConnectionState.active:
                  return Text('');
                case ConnectionState.waiting:
                  return FetchingScreen(
                    imagePath: 'assets/images/fetching.png',
                    displayText: 'Fetching your appointments',
                  );
                case ConnectionState.done:
                  print(pa.activeRes.length);
                  return TabBarView(
                    children: <Widget>[
                      pa.pastRes.length == 0
                          ? NoAppointments(
                              imagePath: 'assets/images/no_appointments.png',
                              text: 'No past appointments',
                            )
                          : Upcoming(
                              tab: 0,
                              list: pa.pastRes,
                              refreshParent: refresh,
                            ),
                      pa.activeRes.length == 0
                          ? NoAppointments(
                              imagePath: 'assets/images/no_appointments.png',
                              text: 'No Active appointments',
                            )
                          : Upcoming(
                              tab: 1,
                              list: pa.activeRes,
                              goToCurrentScreen: widget.goToCurrentScreen,
                            ),
                      pa.upcomingRes.length == 0
                          ? NoAppointments(
                              imagePath: 'assets/images/no_appointments.png',
                              text: 'No upcoming appointments',
                            )
                          : Upcoming(
                              tab: 2,
                              list: pa.upcomingRes,
                              refreshParent: refresh,
                            ),
                    ],
                  );
              }
              return Container();
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skywa/components/upcomingScreen.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Upcoming",
              ),
              Tab(
                text: "Past",
              ),
              Tab(
                text: "Active",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Upcoming(),
            Center(
              child: Text("Past"),
            ),
            Center(
              child: Text("Active"),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

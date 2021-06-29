import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/appointmentScreenProvider.dart';
import 'package:skywa/components/upcomingScreen.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final p = Provider.of<appointmentScreenProvider>(context, listen: false);
      p.getReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pa = Provider.of<appointmentScreenProvider>(context);
    return DefaultTabController(
      initialIndex: 1,
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
        body: TabBarView(
          children: <Widget>[
            Upcoming(
              list: pa.upcomingRes,
            ),
            Upcoming(
              list: pa.pastRes,
            ),
            Upcoming(
              list: pa.activeRes,
            ),
          ],
        ),
      ),
    );
    ;
  }
}

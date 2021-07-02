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
  }

  @override
  Widget build(BuildContext context) {
    final pa = Provider.of<appointmentScreenProvider>(context, listen: false);
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
        body: FutureBuilder<bool>(
            future:
                Provider.of<appointmentScreenProvider>(context, listen: false)
                    .getReservations(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text(
                    'Fetching data',
                    textAlign: TextAlign.center,
                  );
                case ConnectionState.active:
                  return Text('');
                case ConnectionState.waiting:
                  return Text("Fetching Data...");
                case ConnectionState.done:
                  return TabBarView(
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
                  );
              }
              return Text("Fetching Chucky Categories...");
            }),
      ),
    );
    ;
  }
}

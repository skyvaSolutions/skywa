import 'package:flutter/material.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/components/AppointmentsWidget.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({Key key}) : super(key: key);

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: nearbyQs.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, top: 8.0),
              child: AppointmentTab(
                name: nearbyQs[index].companyName,
                address: nearbyQs[index].address,
              ),
            );
          }),
    );
  }
}

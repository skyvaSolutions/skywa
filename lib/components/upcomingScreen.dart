import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/Providers/ThemeProvider.dart';
import 'package:skywa/Providers/appointmentScreenProvider.dart';
import 'package:skywa/components/AppointmentsWidget.dart';
import 'package:skywa/model/reservation.dart';

class Upcoming extends StatefulWidget {
  final int tab;
  final List<Reservation> list;
  final Function() goToCurrentScreen;
  final Function() refreshParent;
  const Upcoming({Key key, this.list , @required this.tab , this.goToCurrentScreen , this.refreshParent}) : super(key: key);

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: widget.list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, top: 8.0),
              child: AppointmentTab(
                id: widget.list[index].ReservationID,
                name: widget.list[index].CompanyName,
                address: widget.list[index].Address,
                tab : widget.tab,
                goToCurrentScreen : widget.goToCurrentScreen,
                refreshParent : widget.refreshParent,
                status : widget.list[index].MemberState,
              ),
            );
          }),
    );
  }
}

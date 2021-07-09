import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/components/business_card.dart';
import 'package:skywa/utils/showDialogforName.dart';

class BusinessWidget extends StatefulWidget {
  final name, address, index , openTime, closeTime;
  final Function() goToAppointmentScreen;
  final Function() goToCurrentScreen;
  const BusinessWidget(
      {Key key,
        this.name,
        this.address,
        this.index,
        this.openTime,
        this.closeTime,
        this.goToAppointmentScreen,
        this.goToCurrentScreen})
      : super(key: key);
  @override
  _BusinessWidgetState createState() => _BusinessWidgetState();
}

String getInitials(company_name) {
  List<String> names = company_name.split(" ");
  String initials = "";
  int numWords = 2;

  if (numWords < names.length) {
    numWords = names.length;
  }
  if (names.length == 1) {
    numWords = 1;
  }
  for (var i = 0; i < numWords; i++) {
    print(names[i]);
    initials += '${names[i][0]}';
  }
  return initials;
}

class _BusinessWidgetState extends State<BusinessWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withAlpha(40),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BusinessDetail(
              contextParent : context,
              companyName: widget.name,
              address: widget.address,
              index: widget.index,
              openTime: widget.openTime,
              closeTime: widget.closeTime,
              goToAppointmentScreen: widget.goToAppointmentScreen,
              goToCurrentScreen: widget.goToCurrentScreen,
            )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35.0,
                      backgroundColor: [
                        Color(0xFF4C44B3),
                        Color(0xFF3CD1BB),
                      ][widget.index % 2],
                      child: Center(
                        child: Text(
                          widget.name.toString().length == 0
                              ? ""
                              : getInitials(widget.name),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          child: Text(
                            widget.address.toString().trim(),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: GoogleFonts.poppins(
                                fontSize: 15.2, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      // shape: RoundedRectangleBorder(
                      //     side:
                      //     BorderSide(color: Theme.of(context).primaryColor),
                      //     borderRadius: BorderRadius.circular(10)),
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BusinessDetail(
                          contextParent : context,
                          companyName: widget.name,
                          address: widget.address,
                          index: widget.index,
                          openTime: widget.openTime,
                          closeTime: widget.closeTime,
                          goToAppointmentScreen: widget.goToAppointmentScreen,
                          goToCurrentScreen: widget.goToCurrentScreen,
                        )));
                      },
                      child: Text("More" ,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        DB.box.put(DB.index, widget.index);

                        await showMyDialog(
                            context,
                            widget.name.toString(),
                            widget.index,
                            widget.goToAppointmentScreen,
                            widget.goToCurrentScreen,
                            false,
                        );
                      },
                      child: Text("Check In"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        shadowColor: Colors.black.withAlpha(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 10.0,
              offset: Offset(2, 4)),
        ],
      ),
    );
  }
}

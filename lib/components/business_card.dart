import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/utils/showDialogforName.dart';

import 'businessWidget.dart';

bool businessOpen = false;

void isOpen(String openTime, String closeTime) {
  List<String> openHour = openTime.split(':');
  List<String> closeHour = closeTime.split(':');
  DateTime today = DateTime.now();
  int nowHour = today.hour;
  int nowMin = today.minute;
  int openBusinessHour = int.parse(openHour[0]);
  int openBusinessMinute = int.parse(openHour[0]);
  int closeBusinessHour = int.parse(closeHour[0]);
  int closeBusinessMinute = int.parse(closeHour[0]);
  if (nowHour > openBusinessHour && nowHour < closeBusinessHour) {
    print('open');
    businessOpen = true;
  }
  if (nowHour < openBusinessHour || nowHour > closeBusinessHour) {
    print('closed');
    businessOpen = false;
  }
}

class BusinessDetail extends StatefulWidget {
  final BuildContext contextParent;
  final int index;
  final String companyName;
  final String address;
  final String openTime;
  final String closeTime;
  final Function() goToAppointmentScreen;
  final Function() goToCurrentScreen;
  const BusinessDetail(
      {Key key,
      this.index,
      this.companyName,
      this.address,
      this.openTime,
      this.closeTime,
      this.goToAppointmentScreen,
      this.goToCurrentScreen,
      this.contextParent})
      : super(key: key);

  @override
  _BusinessDetailState createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  @override
  Widget build(BuildContext context) {
    isOpen(widget.openTime, widget.closeTime);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset(
                          "assets/images/image-placeholder.png",
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.grey.withOpacity(0.5),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                    child: Icon(Icons.warning),
                    width: 90,
                    height: 90,
                  ),
                  imageUrl: [
                    "http://nebula.wsimg.com/f8718f1686ddf5364fb59d810396dfd8?AccessKeyId=7308F00505C458ECD224&disposition=0&alloworigin=1",
                    "https://images1-fabric.practo.com/practices/1255057/dr-maneesha-singh-clinic-gynaecologist-ghaziabad-5cc44e9a814e8.jpg",
                    "https://www.thedoctorsclinic.com/images/content/Cardiology%20Waiting%20Room.jpg"
                  ][widget.index % 3],
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                Spacer(),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25 - 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60.0,
                    ),
                    Center(
                      child: Text(
                        widget.companyName,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        widget.address,
                        style: GoogleFonts.poppins(fontSize: 17.0),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (businessOpen)
                      Center(
                        child: Text('Open',
                            style: GoogleFonts.poppins(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 17.0)),
                      ),
                    if (!businessOpen)
                      Center(
                        child: Text('Closed',
                            style: GoogleFonts.poppins(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w700,
                              fontSize: 17.0,
                            )),
                      ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 1.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Open Time  : ' + widget.openTime,
                              style: GoogleFonts.poppins(
                                fontSize: 17.0,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Close Time  : ' + widget.closeTime,
                              style: GoogleFonts.poppins(
                                fontSize: 17.0,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            // shape: RoundedRectangleBorder(
                            //     side:
                            //     BorderSide(color: Theme.of(context).primaryColor),
                            //     borderRadius: BorderRadius.circular(10)),
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              await showMyDialog(
                                  widget.contextParent,
                                  widget.companyName.toString(),
                                  widget.index,
                                  widget.goToAppointmentScreen,
                                  widget.goToCurrentScreen,
                                  true,
                              );
                            },
                            child: Text(
                              "Check In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25 - 70,
              left: MediaQuery.of(context).size.width * 0.5 - 50,
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: [
                    Color(0xFF4C44B3),
                    Color(0xFF3CD1BB),
                  ][widget.index % 2],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    getInitials(widget.companyName),
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    isOpen(widget.openTime, widget.closeTime);
  }
}

/* import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/utils/showDialogforName.dart';

class BusinessWidget extends StatefulWidget {
  final name, address, index;
  final Function() goToAppointmentScreen;
  final Function() goToCurrentScreen;
  const BusinessWidget(
      {Key key,
      this.name,
      this.address,
      this.index,
      this.goToAppointmentScreen,
      this.goToCurrentScreen
      })
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
      height: MediaQuery.of(context).size.height * 0.36,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 20,
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.23,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      placeholder: (context, url) => Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Image.asset(
                              "assets/images/image-placeholder.png",
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: double.infinity,
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.grey.withOpacity(0.5),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                      errorWidget: (context, url, error) => SizedBox(
                        child: Icon(Icons.warning),
                        width: 90,
                        height: 90,
                      ),
                      imageUrl: [
                        "http://nebula.wsimg.com/f8718f1686ddf5364fb59d810396dfd8?AccessKeyId=7308F00505C458ECD224&disposition=0&alloworigin=1",
                        "https://images1-fabric.practo.com/practices/1255057/dr-maneesha-singh-clinic-gynaecologist-ghaziabad-5cc44e9a814e8.jpg",
                        "https://www.thedoctorsclinic.com/images/content/Cardiology%20Waiting%20Room.jpg"
                      ][widget.index % 3],
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.11,
                      left: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.height * 0.11,
                        decoration: BoxDecoration(
                          color: [
                            Color(0xFF4C44B3),
                            Color(0xFF3CD1BB),
                          ][widget.index % 2],
                          borderRadius: BorderRadius.circular(100),
                        ),
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
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        widget.address.toString().trim(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                            fontSize: 15.2, fontWeight: FontWeight.w300),
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          side:
                          BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () async {
                        DB.box.put(DB.index, widget.index);
                        await showMyDialog(context, widget.name.toString(),
                            widget.index, widget.goToAppointmentScreen , widget.goToCurrentScreen);
                      },
                      child: Text("Check In"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */

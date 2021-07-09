

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/createReservationProvider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:skywa/screens/appointment_status.dart';

Future<void> showDialogForDate(contextParent, name, index  , goToAppointmentScreen , goToCurrentScreen , returnBack) async {
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();


  DateTime selectedDate = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    int nowYear = DateTime.now().year;
    int nowDay = DateTime.now().day;
    int nowMonth = DateTime.now().month;
    final DateTime picked = await
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(nowYear, nowMonth, nowDay),
        maxTime: DateTime(nowYear, nowMonth, nowYear + 14), onChanged: (date) {
        }, onConfirm: (date) {
        }, currentTime: DateTime.now(),
        locale: LocaleType.en,
        theme: DatePickerTheme(
          doneStyle: TextStyle(
            color: Theme.of(context).primaryColor
          ),
          cancelStyle: TextStyle(
            color: cancelColor
          ),

        )
    );
    if (picked != null && picked != selectedDate)
      selectedDate = picked;
    var day = picked.day.toString().length == 1 ? "0" + picked.day.toString() : picked.day.toString();
    var month = picked.month.toString().length == 1 ? "0" + picked.month.toString() : picked.month.toString();
    var year = picked.year.toString().length == 1 ? "0" + picked.year.toString() : picked.year.toString();

    var hour = picked.hour.toString().length == 1 ? "0" + picked.hour.toString() : picked.hour.toString();
    var min = picked.minute.toString().length == 1 ? "0" + picked.minute.toString() : picked.minute.toString();
    _timeController.text = hour.toString() + ":" + min.toString();
    _dateController.text = day.toString() + "-" + month.toString() + "-" + year.toString();
    _dateTimeController.text = day.toString() + "-" + month.toString() + "-" + year.toString() + "  " + hour.toString() + ":" + min.toString();
    print(picked);

  }
  // Future<Null> _selectTime(BuildContext context) async {
  //   final TimeOfDay picked = await showTimePicker(
  //     context: context,
  //     initialTime: selectedTime,
  //   );
  //   if (picked != null)
  //     selectedTime = picked;
  //   var hour = picked.hour.toString().length == 1 ? "0" + picked.hour.toString() : picked.hour.toString();
  //   var min = picked.minute.toString().length == 1 ? "0" + picked.minute.toString() : picked.minute.toString();
  //   _timeController.text = hour + ":" + min.toString();
  // }

  final p = Provider.of<createReservationProvider>(contextParent, listen: false);
  return showDialog<void>(
    context: contextParent,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Welcome'),
        content: p.loading == true
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Select appointment Date & Time',
                style: GoogleFonts.poppins(),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () async {
                  await _selectDateTime(context);
                },
                child: TextFormField(
                  enabled: false,
                  controller: _dateTimeController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: 'Now',
                      border: OutlineInputBorder()),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // GestureDetector(
              //   onTap: () async {
              //     await _selectTime(context);
              //   },
              //   child: TextFormField(
              //     enabled: false,
              //     controller: _timeController,
              //     style: GoogleFonts.poppins(),
              //     decoration: InputDecoration(
              //         contentPadding: EdgeInsets.all(5),
              //         hintText: 'None',
              //         border: OutlineInputBorder()),
              //   ),
              // ),
              SizedBox(
                height: 6,
              ),
              Text(
                'Note : Now for current date & time',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child:
            Text('Cancel', style: GoogleFonts.poppins(color: Color(0xFFEDAF11))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Submit',
              style: GoogleFonts.poppins(),
            ),
            onPressed: () {
              print("here");
              print(_timeController.text);
              print(_dateController.text);
              print(selectedDate);

              DateTime now = new DateTime.now();
              String dateFormatted =
              DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(now);
              String date = dateFormatted;

              // Map<String, String> dateTimeFormat =
              //     convertDateToProperFormat(now);
              // String nowTime = dateTimeFormat['Time'];
              String nowHour =  now.hour.toString().length == 1 ? "0" + now.hour.toString() : now.hour.toString();
              String nowMinutes =  now.minute.toString().length == 1 ? "0" + now.minute.toString() : now.minute.toString();
              String nowSeconds =  now.second.toString().length == 1 ? "0" + now.second.toString() : now.second.toString();
              String nowTime = nowHour + ":" + nowMinutes + ":" + nowSeconds;
              print(nowTime);

              String nowMonth =  now.month.toString().length== 1 ? "0" + now.month.toString() : now.month.toString();
              String nowDay =  now.day.toString().length== 1 ? "0" + now.day.toString() : now.day.toString();
              String nowDate = now.year.toString() + "-" + nowMonth + "-" + nowDay;
              print(nowDate);

              if (_timeController.text.length != 0){
                date = date.replaceAll(
                    nowTime, _timeController.text + ":00");
              }
              if (_dateController.text.length != 0){
                List<String> splitDate = _dateController.text.split("-");

                String convSelectedDate = splitDate[2] + "-" + splitDate[1] + "-" + splitDate[0];
                date = date.replaceAll(
                    nowDate, convSelectedDate);
              }
              print(date);
              p.createReservation(contextParent , date, name, index , goToAppointmentScreen , goToCurrentScreen , returnBack);
              Navigator.of(context).pop();
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Adding Reservation'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          width: 30.0,
                          height: 30.0,
                          child: CircularProgressIndicator()
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      );
    },
  );
}

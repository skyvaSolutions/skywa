import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/createReservationProvider.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:intl/intl.dart';

Future<void> showDialogForDate(context, name, index) async {
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) selectedTime = picked;
    var hour = picked.hour.toString().length == 1 ? "0" + picked.hour.toString() : picked.hour.toString();
    var min = picked.minute.toString().length == 1
        ? "0" + picked.minute.toString()
        : picked.minute.toString();
    _timeController.text = hour + ":" + min.toString();
  }

  final p = Provider.of<createReservationProvider>(context, listen: false);
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Welcome'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Select appointment time',
                style: GoogleFonts.poppins(),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () async {
                  await _selectTime(context);
                },
                child: TextFormField(
                  enabled: false,
                  controller: _timeController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(5),
                      hintText: 'None',
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'Note : None for current time',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child:
                Text('Cancel', style: GoogleFonts.poppins(color: Colors.red)),
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
              DateTime now = new DateTime.now();
              String dateFormatted =
                  DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(now);
              String date = _timeController.text.length == 0
                  ? dateFormatted
                  : _timeController.text;
              Map<String, String> dateTimeFormat =
                  convertDateToProperFormat(now);
              String nowTime = dateTimeFormat['Time'];
              if (_timeController.text.length != 0){
                date = dateFormatted.replaceAll(
                    nowTime, _timeController.text + ":00");
              }
              print(date);
              p.createReservation(date, name, index);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

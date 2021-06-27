import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/createReservationProvider.dart';

Future<void> showDialogForDate(context, name , index) async {
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) selectedTime = picked;
    var min = picked.minute.toString().length == 1
        ? "0" + picked.minute.toString()
        : picked.minute.toString();
    _timeController.text = picked.hour.toString() + ":" + min.toString();
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
              p.createReservation(_timeController.text, name , index);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

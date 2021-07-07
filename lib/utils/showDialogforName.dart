import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:skywa/DB/DB.dart';
import 'package:skywa/utils/showDialogforDate.dart';

Future<void> showMyDialog(contextParent, name , index , goToAppointmentScreen , goToCurrentScreen , returnBack) async {
  TextEditingController t1 = new TextEditingController();
  DB.box.get(DB.name) != null ? t1.text = DB.box.get(DB.name) : "";
  return showDialog<void>(
    context: contextParent,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Welcome'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Please enter your name',
                style: GoogleFonts.poppins(),
              ),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: t1,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(5),
                    hintText: 'Tell us your name',
                    border: OutlineInputBorder()),
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
              'Next',
              style: GoogleFonts.poppins(),
            ),
            onPressed: () {
              DB.box.put(DB.name, t1.text);
              Navigator.of(context).pop();
              showDialogForDate(contextParent, name , index , goToAppointmentScreen , goToCurrentScreen , returnBack);
            },
          ),
        ],
      );
    },
  );
}

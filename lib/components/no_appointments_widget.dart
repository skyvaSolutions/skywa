import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoAppointments extends StatelessWidget {
  final String imagePath;
  final String text;
  const NoAppointments({Key key, this.imagePath , this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Image.asset(
              imagePath,
            ),
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

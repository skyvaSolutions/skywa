import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ErrorPage extends StatelessWidget {
  const ErrorPage({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/images/noi.jpg"),
            Text("No Internet Connected",style: GoogleFonts.poppins(fontSize: 21))
          ],
        ),
      ),
      
    );
  }
}
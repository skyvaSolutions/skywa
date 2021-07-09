import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FetchingScreen extends StatelessWidget {
  final String imagePath;
  final String displayText;
  const FetchingScreen({Key key , this.imagePath , this.displayText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child :Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Image.asset(
                imagePath,
              ),
            ),
            Text(
              displayText,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

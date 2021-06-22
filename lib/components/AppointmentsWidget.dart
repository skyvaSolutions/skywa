import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentTab extends StatefulWidget {
  final name, address;

  AppointmentTab({Key key, this.name, this.address}) : super(key: key);

  @override
  _AppointmentTabState createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 20,
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  widget.address.toString().trim(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      fontSize: 15.2, fontWeight: FontWeight.w300),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () async {},
                  child: Text("Message"),
                )),
          ),
        ),
      ),
    );
    ;
  }
}

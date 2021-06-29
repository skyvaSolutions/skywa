import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/utils/showDialogforName.dart';

class BusinessWidget extends StatefulWidget {
  final name, address, index;
  const BusinessWidget({Key key, this.name, this.address, this.index})
      : super(key: key);
  @override
  _BusinessWidgetState createState() => _BusinessWidgetState();
}

class _BusinessWidgetState extends State<BusinessWidget> {
  String getInitials(company_name) {
    List<String> names = company_name.split(" ");
    String initials = "";
    int numWords = 2;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

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
                        width: MediaQuery.of(context).size.width * 0.19,
                        decoration: BoxDecoration(
                          color: [
                            Colors.orange,
                            Colors.purple,
                            Colors.teal,
                            Colors.red
                          ][widget.index % 4],
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            getInitials(widget.name),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () async {
                        await showMyDialog(
                            context, widget.name.toString(), widget.index);
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

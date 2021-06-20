import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/utils/showDialogforName.dart';

class BusinessWidget extends StatefulWidget {
  final name, address;
  const BusinessWidget({Key key, this.name, this.address}) : super(key: key);
  @override
  _BusinessWidgetState createState() => _BusinessWidgetState();
}

class _BusinessWidgetState extends State<BusinessWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
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
                      imageUrl:
                          "https://4.imimg.com/data4/NL/MG/MY-14358752/2-pcs-copy-500x500.png",
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.11,
                      left: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.width * 0.21,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                scale: 1,
                                image: NetworkImage(
                                    "https://image.shutterstock.com/image-vector/medical-care-logo-design-260nw-1281695074.jpg"),
                                fit: BoxFit.scaleDown)),
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
                        await showMyDialog(context, widget.name.toString());
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

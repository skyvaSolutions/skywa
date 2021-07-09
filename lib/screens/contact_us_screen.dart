import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skywa/utils/mail_phone.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Contact Us',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Image.asset('assets/images/contact.png'),
              ),
              // Expanded(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColor,
              //     ),
              //     child: Align(
              //       alignment: Alignment.topCenter,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text('Get in touch' , style: GoogleFonts.poppins(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 20.0
              //         ),),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
              ]

            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  // TextField(
                  //   maxLines: 5,
                  //   textAlign: TextAlign.start,
                  //   autofocus: true,
                  //   decoration: InputDecoration(
                  //     // labelText: 'Type here..',
                  //     // labelStyle: GoogleFonts.poppins(
                  //     //   fontSize: 15.0,
                  //     // ),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10)),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    leading: Icon(Icons.mail , color: Theme.of(context).primaryColor,),
                    title: Text(' Mail to Skywa Support' , style: GoogleFonts.poppins(
                        color: Theme.of(context).primaryColor,
                        fontSize: 19.0
                    ),),
                    subtitle: Text('admin@skywasolutions.com'),
                    onTap: (){
                      mailAndPhone.contact('mailto:admin@skywasolutions.com');
                    },

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on_outlined , color: Theme.of(context).primaryColor,),
                    title: Text('Skywa Address' , style: GoogleFonts.poppins(
                        color: Theme.of(context).primaryColor,
                        fontSize: 19.0
                    ),),

                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skywa/screens/appointment_status.dart';

class CurrentScreen extends StatefulWidget {
  @override
  _CurrentScreenState createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(),
        Container(
          height: 1.5,
          width: double.maxFinite,
          color: Colors.black,
        ),
        AppointmentStatus(),
        StatusMessage(),
        Expanded(child: Footer()),
      ],
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.white,
            child: Image.network(
              'https://image.shutterstock.com/image-vector/medical-care-logo-design-260nw-1281695074.jpg',
              width: 80.0,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctors Hospital West',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '17 Blake Rd, Nassau \n Bahamas',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              AppointmentDateTime(),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentDateTime extends StatefulWidget {
  @override
  _AppointmentDateTimeState createState() => _AppointmentDateTimeState();
}

class _AppointmentDateTimeState extends State<AppointmentDateTime> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Date : 23/06/2021 \t 03:00 PM',
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
          color: Color(0xff6EB4CA),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info),
                        iconSize: 40.0,
                        color: Colors.teal,
                        onPressed: () {},
                      ),
                      Text(
                        'Information about my appointment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(2, 4), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.question_answer),
                        iconSize: 40.0,
                        color: Colors.teal,
                        onPressed: () {},
                      ),
                      Text(
                        'Complete Questionnaire',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.teal),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(2, 4), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chat),
                        iconSize: 40.0,
                        color: Colors.teal,
                        onPressed: () {},
                      ),
                      Text(
                        'Chat with the business',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.teal),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(2, 4), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_call),
                        iconSize: 40.0,
                        color: Colors.teal,
                        onPressed: () {},
                      ),
                      Text(
                        'Call Business',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.teal),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(2, 4), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:skywa/Global&Constants/DeviceDetailsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/api_calls/get_my_reservations.dart';
import 'package:skywa/components/businessWidget.dart';
import 'package:skywa/components/tileWidgets.dart';
import 'package:skywa/screens/appointment_status.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:skywa/screens/Appointment.dart';
import 'package:skywa/screens/CurrentBookings.dart';
import 'package:skywa/screens/helpScreen.dart';
import 'package:skywa/screens/onBoarding.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/screens/searchPage.dart';
import 'package:skywa/screens/settingScreen.dart';
import 'package:skywa/screens/splashScreen.dart';
import 'package:skywa/services/deviceConnection.dart';
import 'package:skywa/utils/Network_aware.dart';
import 'package:http/http.dart' as http;
import 'package:skywa/api_calls/find_users.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;

  final _pageOptions = [HomeBar(), CurrentScreen(), HomeBar()];
  StreamSubscription _connectionChangeStream;
  @override
  void initState() {
    super.initState();
  }

  @override
  final List<String> names = <String>[
    'Aby',
    'Aish',
    'Ayan',
    'Ben',
    'Bob',
    'Charlie',
    'Cook',
    'Carline'
  ];
  int _selected = 0;
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
  List<Widget> body = [HomeBar(), CurrentScreen(), Appointment()];
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Welcome",
            style: GoogleFonts.poppins(),
          ),
          actions: [
            if (selectedPage != 1)
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPage.id);
                  },
                  icon: Icon(Icons.search))
          ],
//        leading: IconButton(
//          icon: Icon(Icons.help),
//          onPressed: () => Navigator.pushNamed(context, HelpScreen.id),
//        ),
          //   backgroundColor: kAppBarColor,
        ),
        drawer: AppDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (e) {
            setState(() {
              _selected = e;
            });
          },
          currentIndex: _selected,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 15),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Current Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Appointments',
            )
          ],
        ),
        body: StreamProvider<NetworkStatus>(
          initialData: NetworkStatus.Online,
          create: (context) =>
              NetworkStatusService().networkStatusController.stream,
          child: NetworkAwareWidget(
            // onlineChild: ListView.builder(
            //     padding: const EdgeInsets.all(4),
            //     itemCount: nearbyQs.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Padding(
            //         padding:
            //             const EdgeInsets.only(left: 13, right: 13, top: 8.0),
            //         child: BusinessWidget(
            //           name: nearbyQs[index].companyName,
            //           address: nearbyQs[index].address,
            //         ),
            //       );
            //     }),
            onlineChild: body[_selected],
          ),
        ));
  }
}

class HomeBar extends StatelessWidget {
  const HomeBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(4),
        itemCount: nearbyQs.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 8.0),
            child: BusinessWidget(
              name: nearbyQs[index].companyName,
              address: nearbyQs[index].address,
              index: index,
            ),
          );
        });
  }
}

// class TestWidget extends StatelessWidget {
//   const TestWidget({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 10,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${nearbyQs[index].companyName} ',
//               textAlign: TextAlign.left,
//               style: GoogleFonts.poppins(
//                   fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               '${nearbyQs[index].address}',
//               textAlign: TextAlign.left,
//               style: GoogleFonts.poppins(fontSize: 15),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: 10.0, right: 10.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
// //                              style: ElevatedButton.styleFrom(
// //                                  primary: Colors.blueAccent),
//                   onPressed: () {
//                     // On button presed
//                   },
//                   child: const Text("Check In"),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createHeader(),
          createDrawerItem(
            icon: Icons.account_box,
            text: 'Update Profile',
            onTap: () => Navigator.pushNamed(context, ProfileEditPage.id),
          ),
          createDrawerItem(
            icon: Icons.help,
            text: 'Help',
            onTap: () => Navigator.pushNamed(context, HelpScreen.id),
          ),
          createDrawerItem(
            icon: Icons.category,
            text: 'Introduction',
            onTap: () => Navigator.pushNamed(context, OnBoardingPage.id),
          ),
          createDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => Navigator.pushNamed(context, SettingScreen.id),
          ),
          /*
         onTap: () =>

          */
          Divider(),
          createDrawerItem(
            icon: Icons.share,
            text: 'Tell a Friend',
            onTap: () => {
              // if (userDevice.isIOS)
              //   {
              //     Share.share('Download our cool new App' + appName,
              //         subject: 'Check Out ' + appName + '\n  ' + appleStoreURL)
              //   }
              // else
              //   {
              //     Share.share('Download our cool new App' + appName,
              //         subject:
              //             'Check Out ' + appName + '\n  ' + androidStoreURL)
              //   }
            },
          ),
          createDrawerItem(
              icon: Icons.email, text: 'Contact Us', onTap: () => sendemail()),
        ],
      ),
    );
  }
}

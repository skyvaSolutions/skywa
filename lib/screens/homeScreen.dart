import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:skywa/Global&Constants/DeviceDetailsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/components/businessWidget.dart';
import 'package:skywa/components/tileWidgets.dart';
import 'package:skywa/screens/contact_us_screen.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:skywa/screens/Appointment.dart';
import 'package:skywa/screens/helpScreen.dart';
import 'package:skywa/screens/onBoarding.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/screens/searchPage.dart';
import 'package:skywa/screens/settingScreen.dart';
import 'package:skywa/services/deviceConnection.dart';
import 'package:skywa/utils/Network_aware.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 // StreamSubscription _connectionChangeStream;
  @override
  void initState() {
    super.initState();
  }

  goToAppointmentScreen() {
    setState(() {
      _selected = 1;
    });
  }

  goToCurrentScreen(){
    setState(() {
      _selected = 2;
    });
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
  String appBarText = "";
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
  List<Widget> body = [];
  Widget build(BuildContext context) {
    body = [
      HomeBar(goToAppointmentScreen: goToAppointmentScreen , goToCurrentScreen : goToCurrentScreen),
      Appointment(goToCurrentScreen : goToCurrentScreen),
      CurrentScreen(goToAppointmentScreen: goToAppointmentScreen,),
    ];
    if(_selected == 0){
      appBarText = "Home";
    }
    else if(_selected == 1){
      appBarText = "Appointments";
    }
    else{
      appBarText = "Current Appointment";
    }
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title:
          Text(
            appBarText,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            if (_selected == 0)
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
          selectedItemColor: Theme.of(context).primaryColor,
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
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.today),
              label: 'Current Appt.',
            ),
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

class HomeBar extends StatefulWidget {
  final Function() goToAppointmentScreen;
  final Function() goToCurrentScreen;
  const HomeBar({Key key, @required this.goToAppointmentScreen , this.goToCurrentScreen}) : super(key: key);

  @override
  _HomeBarState createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        print("Refreshing");
      },
      child: ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: nearbyQs.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 3, right: 3, top: 8.0),
              child: BusinessWidget(
                name: nearbyQs[index].companyName,
                address: nearbyQs[index].address,
                openTime : nearbyQs[index].openTime,
                closeTime : nearbyQs[index].closeTime,
                index: index,
                goToAppointmentScreen: widget.goToAppointmentScreen,
                goToCurrentScreen : widget.goToCurrentScreen,
              ),
            );
          }),
    );
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
      child: Container(
        color: Color(0xFF4C44B3),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createHeader(),
            Divider(
              height: 2.0,
              color: Colors.white,
            ),
            createDrawerItem(
              icon: Icons.account_circle,
              text: 'Update Profile',
              onTap: () => Navigator.pushNamed(context, ProfileEditPage.id),
            ),
            // createDrawerItem(
            //   icon: Icons.settings,
            //   text: 'Settings',
            //   onTap: () => Navigator.pushNamed(context, SettingScreen.id),
            // ),
            createDrawerItem(
              icon: Icons.help,
              text: 'Help',
              onTap: () => Navigator.pushNamed(context, HelpScreen.id),
            ),
            createDrawerItem(
              icon: Icons.category,
              text: 'Getting Started',
              onTap: () => Navigator.pushNamed(context, OnBoardingPage.id),
            ),
            /*
           onTap: () =>

            */

            createDrawerItem(
              icon: Icons.people,
              text: 'Invite a Friend',
              onTap: () => {
                if (userDevice.isIOS)
                  {
                    Share.share('Skywa allows you to check into a business remotely. ' + appName,
                        subject: 'Check Out ' + appName + '\n  ' + "www.skywasolutions.com")
                  }
                else
                  {
                    Share.share('Skywa allows you to check into a business remotely.' + appName,
                        subject:
                            'Check Out ' + appName + '\n  ' + "www.skywasolutions.com")
                  }
              },
            ),
            createDrawerItem(
                icon: Icons.email, text: 'Contact Us', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ContactUs()))
                //sendemail()
            ),
          ],
        ),
      ),
    );
  }
}

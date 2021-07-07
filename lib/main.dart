
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Providers/ThemeProvider.dart';
import 'package:skywa/Providers/appointmentScreenProvider.dart';
import 'package:skywa/Providers/appointment_tap_provider.dart';
import 'package:skywa/Providers/createReservationProvider.dart';
import 'package:skywa/Providers/loading_provider.dart';
import 'package:skywa/Providers/searchProvider.dart';
import 'package:skywa/components/AppointmentsWidget.dart';
import 'package:skywa/components/business_card.dart';
import 'package:skywa/screens/helpScreen.dart';
import 'package:skywa/screens/homeScreen.dart';
import 'package:skywa/screens/onBoarding.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/screens/searchPage.dart';
import 'package:skywa/screens/settingScreen.dart';
import 'package:skywa/screens/splashScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'DB/DB.dart';
import 'Providers/member_state_changed.dart';

void main() async {
  await Hive.initFlutter();
  DB.box = await Hive.openBox(DB.boxName);
  // imageCache.clear();
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // print("firebase initialized, ${DateTime.now()}");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => appointmentScreenProvider()),
    ChangeNotifierProvider(create: (context) => searchProvider()),
    ChangeNotifierProvider(create: (context) => createReservationProvider()),
    ChangeNotifierProvider<MemberStateChanged>(create: (context) => MemberStateChanged()),
    ChangeNotifierProvider<AppointmentTabIndex>(create: (context) => AppointmentTabIndex()),
    ChangeNotifierProvider<LoadingScreen>(create: (context) => LoadingScreen()),
  ], child: MyApp()));
}

const FlexSchemeData customFlexScheme = FlexSchemeData(
  name: 'Skywa Theme',
  description: 'Purple theme created from custom defined colors.',
  light: FlexSchemeColor(
    primary: Color(0xFF4C44B3),
    primaryVariant: Color(0xFF383285),
    secondary: Color(0xFF3CD1BB),
    secondaryVariant: Color(0xFF31A191),
    accentColor: Color(0xFF3CD1BB),
    error: Color(0xFFEDAF11),
  ),
  dark: FlexSchemeColor(
    primary: Color(0xFF9E7389),
    primaryVariant: Color(0xFF775C69),
    secondary: Color(0xFF738F81),
    secondaryVariant: Color(0xFF5C7267),
  ),
);


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _prov = Provider.of<ThemeProvider>(context);
    return OverlaySupport(
      child: MaterialApp(
        title: 'App Template',
        debugShowCheckedModeBanner: false,
        themeMode: _prov.DarkMode == true ? ThemeMode.dark : ThemeMode.light,
        theme: FlexColorScheme.light(colors: customFlexScheme.light).toTheme,
        darkTheme: FlexColorScheme.dark(scheme: FlexScheme.hippieBlue
                //  fontFamily: 'Georgia',
                )
            .toTheme,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          HelpScreen.id: (context) => HelpScreen(),
          OnBoardingPage.id: (context) => OnBoardingPage(),
          SettingScreen.id: (context) => SettingScreen(),
          ProfileEditPage.id: (context) => ProfileEditPage(),
          SearchPage.id: (context) => SearchPage(),

        },
      ),
    );
  }
}

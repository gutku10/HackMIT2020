import 'package:GuardianAngel/pages/cmt.dart';
import 'package:GuardianAngel/pages/emergency_dashboard.dart';
import 'package:GuardianAngel/pages/emergency_map.dart';
import 'package:GuardianAngel/pages/emergency_people_list.dart';
import 'package:GuardianAngel/pages/home_page.dart';
import 'package:GuardianAngel/pages/login_page.dart';
import 'package:GuardianAngel/pages/main_dashboard.dart';
import 'package:GuardianAngel/pages/ml.dart';
import 'package:GuardianAngel/pages/photo_capture.dart';
import 'package:GuardianAngel/pages/emergency_tips.dart';
import 'package:GuardianAngel/pages/sos.dart';
import 'package:GuardianAngel/pages/switcher.dart';
import 'package:GuardianAngel/pages/take_picture_page.dart';
import 'package:GuardianAngel/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: (BuildContext context) {
        return ProfileProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => LoginPage(),
          'Switcher': (context) => Switcher(),
          'sos': (context) => SOSPage(),
          'Safe_Dashboard': (context) => MainDashboard(),
          'Emergency_Dashboard': (context) => EmergencyDashboard(),
          'Tips': (context) => EmergencyTips(),
          'Strategy': (context) => DefenseInfoPage(),
          'Shake': (context) => PhotoCapture(),
          'Emergency_List': (_) => EmergencyPeopleList(),
          'Emergency_Map': (_) => EmergencyMap(),
          'ML': (_) => MLModel(),
          'CMT': (_) => CMT(),
          'Image_Picker': (_) => HomePage(),
        },
      ),
    );
  }
}

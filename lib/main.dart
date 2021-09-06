import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zameen_stage_2_dashboard/home.dart';
import 'package:zameen_stage_2_dashboard/utils/dashboard_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor primaryColor = MaterialColor(
      DashboardConstants.dashboardPrimaryColor,
      DashboardConstants.primaryColorSwatch);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
        bottomAppBarColor: primaryColor,
      ),
      home: Home(),
    );
  }
}

import 'package:flutter/material.dart';

import './services/db.dart';

import './screens/dashboard_screen.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      debugShowCheckedModeBanner: false,
      theme:
      ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: DashboardScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:researchrover/routes.dart';
import 'package:researchrover/screens/auth_screen.dart';
import 'package:researchrover/theme.dart';


Future<void> main() async {
  //Main App run
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Research Rover',
      theme: myTheme,
      // initialRoute: '/welcome',
      initialRoute: '/auth',
      routes: routes,
    );
  }
}
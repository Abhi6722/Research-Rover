import 'package:flutter/material.dart';
import 'package:researchrover/screens/auth_screen.dart';
import 'package:researchrover/screens/home_screen.dart';
import 'package:researchrover/screens/login_screen.dart';
import 'package:researchrover/screens/preferences_screen.dart';
import 'package:researchrover/screens/register_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const HomeScreen(),
  '/auth': (BuildContext context) => AuthScreen(),
  '/register': (BuildContext context) => const RegisterScreen(),
  '/login': (BuildContext context) => const LoginScreen(),
  '/preferences': (BuildContext context) => const PreferencesScreen(),
};
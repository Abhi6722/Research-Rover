import 'package:flutter/material.dart';
import 'package:researchrover/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkEmailExists(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final emailExists = snapshot.data!;
          if (emailExists) {
            // Email exists, navigate to HomeScreen
            return const HomeScreen();
          } else {
            // Email does not exist, navigate to RegisterScreen
            return const RegisterScreen();
          }
        } else {
          // Loading state, show a loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<bool> checkEmailExists() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    return email != null;
  }
}
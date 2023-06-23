import 'package:flutter/material.dart';
import 'package:researchrover/screens/welcome_screen.dart';
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
            return const HomeScreen(); // Renders the HomeScreen widget
          } else {
            // Email does not exist, navigate to RegisterScreen
            return const WelcomeScreen(); // Renders the WelcomeScreen widget
          }
        } else {
          // Loading state, show a loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Renders a CircularProgressIndicator while loading
            ),
          );
        }
      },
    );
  }

  Future<bool> checkEmailExists() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    return email != null; // Returns a boolean indicating if the email exists in SharedPreferences
  }
}

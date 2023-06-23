import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  Set<String> selectedGenres = {};
  bool loading = false; // Add a loading flag

  // Logic to handle the selection
  void _onButtonPressed(String genreName) {
    setState(() {
      if (selectedGenres.contains(genreName)) {
        selectedGenres.remove(genreName);
      } else {
        selectedGenres.add(genreName);
      }
    });
  }

  // Function to Update the User preferences
  Future<void> saveSelectedTopics() async {
    setState(() {
      loading = true; // Show the loading indicator
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedGenres', selectedGenres.toList());

    final email = prefs.getString('email');
    final url = Uri.parse('https://research-rover.onrender.com/api/users/preferences');
    final body = jsonEncode({
      'email': email,
      'interests': selectedGenres.toList(),
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    setState(() {
      loading = false; // Hide the loading indicator
    });

    if (response.statusCode == 200) {
      // Preferences saved successfully
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.green,
            title: const Center(
              child: Text(
                'Preferences Saved',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );

      // Redirect to PreferencesScreen after successful registration
      await Future.delayed(const Duration(seconds: 2)); // Delay for 2 seconds
      Navigator.pushReplacementNamed(context, '/');

    } else {
      // Failed to save preferences
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: const Center(
              child: Text(
                'Error',
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: Text(
              'Failed to save preferences. Please try again.',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  // Widget that builds the single option
  Widget _buildGenreButton(String genreName) {
    final isSelected = selectedGenres.contains(genreName);
    return InkWell(
      onTap: () => _onButtonPressed(genreName),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: myTheme.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30.0),
          color: isSelected ? myTheme.primaryColor : Colors.transparent,
        ),
        child: Text(
          genreName,
          style: TextStyle(
            color: isSelected ? Colors.white : myTheme.primaryColor,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Preferences",
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Container(
              width: 700,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Choose your interests",
                            style: TextStyle(
                              fontFamily: 'Playfair',
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xFF003559),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Select your preferred topics for recommendation",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 20.0,
                            runSpacing: 18.0,

                            // We can add as many topics we want here
                            children: [
                              _buildGenreButton('Computing and Processing'),
                              _buildGenreButton('Transportation'),
                              _buildGenreButton('Bioengineering'),
                              _buildGenreButton('Aerospace'),
                              _buildGenreButton('Engineering Profession'),
                              _buildGenreButton('Photonics and Electrooptics'),
                              _buildGenreButton('Geoscience'),
                              _buildGenreButton('Nuclear Engineering'),
                              _buildGenreButton('Components, Circuits, Devices and Systems'),
                              _buildGenreButton('Communication, Networking and Broadcast Technologies'),
                              _buildGenreButton('Signal Processing and Analysis'),
                              _buildGenreButton('Power, Energy and Industry Applications'),
                              _buildGenreButton('Fields, Waves and Electromagnetics'),
                              _buildGenreButton('General Topics for Engineers'),
                              _buildGenreButton('Robotics and Control Systems'),
                              _buildGenreButton('Engineered Materials, Dielectrics and Plasmas'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 100.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: saveSelectedTopics,
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: myTheme.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (loading) CircularProgressIndicator(), // Show the loading indicator if loading is true
              ],
            ),
          ),
        ),
      ),
    );
  }
}

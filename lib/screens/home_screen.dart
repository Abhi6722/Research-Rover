import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:researchrover/theme.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? email;
  List<String>? interests;
  String? day;
  String? time;
  TextEditingController dayController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  // String to store the Days
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    // Calling the get user info function initially to get user details as soon as page loads
    super.initState();
    getUserInfo();
  }

  // Fetch user information from the API
  void getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString('email');
    if (userEmail != null) {
      final url = Uri.parse('https://research-rover.onrender.com/api/users/$userEmail');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> user = data['user'] as Map<String, dynamic>;
        final List<dynamic> interestsList = user['interests'] as List<dynamic>;
        final List<String> interestNames = interestsList.map((interest) => interest['name'] as String).toList();
        setState(() {
          name = user['name'] as String?;
          email = user['email'] as String?;
          interests = interestNames;
          day = user['emailDay'] as String?;
          time = user['emailTime'] as String?;
          dayController.text = day!;
          timeController.text = time!;
        });
      } else {
        // Print the response body and status code for debugging
        print('Failed to fetch user information. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }


  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final selectedTimeString =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        timeController.text = selectedTimeString;
      });
    }

    return selectedTime;
  }

  // Function to update the user preferences of Day and Time
  void updatePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString('email');
    if (userEmail != null) {
      final url =
      Uri.parse('https://research-rover.onrender.com/api/users/preferences/$userEmail');
      final body = jsonEncode({
        'day': dayController.text,
        'time': timeController.text,
      });

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Update Successful'),
              content: const Text('Day and time updated successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Update Failed'),
              content: const Text(
                  'Failed to update day and time. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (name == null || email == null || interests == null) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'Research Rover',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('email'); // Remove the email from shared preferences
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to the login page
              },
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Research Rover',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('email'); // Remove the email from shared preferences
              Navigator.pushReplacementNamed(context, '/login'); // Navigate to the login page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Name: ${name ?? ''}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Interests:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (interests != null && interests!.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: interests!
                          .map((interest) => ListTile(
                        title: Text(
                          interest,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff003559)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/preferences');
                    },
                    child: const Text('Update Preferences'),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Day:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: day,
                  items: daysOfWeek.map((day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      day = value;
                      dayController.text = value!;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Select day',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Time:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final selectedTime = await _selectTime(context);
                    if (selectedTime != null) {
                      final selectedTimeString =
                          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                      setState(() {
                        timeController.text = selectedTimeString;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: timeController,
                      decoration: InputDecoration(
                        hintText: 'Select time',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff003559)),
                    ),
                    onPressed: updatePreferences,
                    child: const Text('Update Email Schedule'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
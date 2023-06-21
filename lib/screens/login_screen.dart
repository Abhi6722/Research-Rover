import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  bool otpSent = false;
  bool loading = false;

  // Generate OTP
  void generateOTP() async {
    setState(() {
      loading = true;
    });

    final url = Uri.parse('https://research-rover.onrender.com/api/users/login');
    final body = jsonEncode({
      'email': emailController.text,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        otpSent = true;
      });
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.green,
            title: Center(
              child: Text(
                'OTP sent successfully.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    } else {
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
            content: const Text(
              'Failed to send OTP. Please try again.',
              style: TextStyle(color: Colors.white),
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

  // Verify OTP and Register User
  void loginUser() async {
    setState(() {
      loading = true;
    });

    final url = Uri.parse('https://research-rover.onrender.com/api/users/login');
    final body = jsonEncode({
      'email': emailController.text,
      'otp': otpController.text,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.green,
            title: Center(
              child: Text(
                'Login Success',
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: Text(
              'Login success.',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Store email in shared preferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('email', emailController.text);

                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
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
            backgroundColor: Colors.red,
            title: const Center(
              child: Text(
                'Login Failed',
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: Text(
              'Failed to Login user. Please try again.',
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

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Login into Your Account',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  otpSent
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: otpController,
                      obscureText: false,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "OTP",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  )
                      : Container(),
                  const SizedBox(height: 25),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      otpSent
                          ? GestureDetector(
                        onTap: loginUser,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: myTheme.primaryColor,
                          ),
                          child: const Center(
                            child: Text(
                              "Verify OTP and Login",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                          : GestureDetector(
                        onTap: generateOTP,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: myTheme.primaryColor,
                          ),
                          child: const Center(
                            child: Text(
                              "Generate OTP",
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
                      if (loading)
                        const CircularProgressIndicator(),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a Member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

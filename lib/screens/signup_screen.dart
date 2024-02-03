import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shuttle_tracker/api/shuttle_api.dart';

String baseUrl = ShuttleApi.baseUrl;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String message = '';

  void _signup() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        message = 'Please fill in all fields';
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        message = 'Password and Confirm Password do not match';
      });
      return;
    }

    // Password constraints
    if (!isValidPassword(passwordController.text)) {
      setState(() {
        message =
            'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    Map<String, dynamic> jsonMap = json.decode(response.body);
    final msg = jsonMap['message'];
    if (response.statusCode == 200) {
      // Signup successful
      setState(() {
        message = msg.toString();
      });
    } else {
      // Signup failed
      setState(() {
        message = msg.toString();
      });
    }
  }

  bool isValidPassword(String password) {
    const passwordPattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[\w!@#$%^&*]{8,}$';
    return RegExp(passwordPattern).hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background_image.jpg'), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white70, // Background color
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Username TextField
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Password TextField
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),

                  // Confirm Password TextField
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _signup,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF0a0e21)),
                      elevation: MaterialStateProperty.all(8.0),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(300, 60)),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Message Text
                  Text(
                    message,
                    style: TextStyle(
                      color: message.contains('successfully')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shuttle_tracker/api/shuttle_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = ShuttleApi.baseUrl;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String message = '';

  void _login() async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
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
      // Login successful
      setState(() {
        message = 'Login successful';
      });

      // Store login state using shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('username', usernameController.text);

      // Navigate to the "/main" route after a successful login
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Login failed
      setState(() {
        message = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors
                      .white70, // Background color of the content container
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
                    const SizedBox(height: 30),

                    // Login Button
                    ElevatedButton(
                      onPressed: _login,
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
                        'Login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Message Text
                    Text(
                      message,
                      style: TextStyle(
                        color: message.contains('successful')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

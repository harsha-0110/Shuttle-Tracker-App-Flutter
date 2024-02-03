import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/trip_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(ShuttleTrackingApp(isLoggedIn: isLoggedIn));
}

class ShuttleTrackingApp extends StatelessWidget {
  final bool isLoggedIn;

  const ShuttleTrackingApp({Key? key, required this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIT Shuttle Tracker',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0a0e21),
            elevation: 5.0,
            shadowColor: Colors.black87,
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0a0e21),
          )),
      initialRoute: isLoggedIn ? '/main' : '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/main': (context) => const MainScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/payment': (context) => PaymentScreen(),
        '/trip': (context) => const TripHistoryPage(),
      },
    );
  }
}

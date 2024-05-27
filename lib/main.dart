
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Make sure the path is correct based on your project structure
import 'SignUpPage.dart'; // Make sure this path is correct
import 'forgot_password.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Social App',
      theme: ThemeData(
        
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.standard,
      ),
      initialRoute: '/', // default is login page
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(), 
        '/forgotPassword': (context) => ForgotPassword()
        
      },
    );
  }
}


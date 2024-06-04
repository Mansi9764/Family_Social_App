import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GmailInputPage(),
    );
  }
}

class GmailInputPage extends StatefulWidget {
  @override
  _GmailInputPageState createState() => _GmailInputPageState();
}

class _GmailInputPageState extends State<GmailInputPage> {
  final _emailController = TextEditingController();
  String _errorMessage = '';

  void _handleSubmit() {
    final email = _emailController.text;

    if (_isValidGmail(email)) {
      setState(() {
        _errorMessage = 'Email is valid';
      });
    } else {
      setState(() {
        _errorMessage = 'Please enter a valid Gmail address';
      });
    }
  }

  bool _isValidGmail(String email) {
    final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return gmailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Sign in',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'with your Google Account',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email or phone',
                    errorText: _errorMessage.isEmpty ? null : _errorMessage,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot email?'),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 40),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Not your computer? Use Guest mode to sign in privately.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: Text('Learn more'),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: () {},
                  child: Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

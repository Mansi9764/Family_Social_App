import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key); 
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signupWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // The user is signed in
        // You can now navigate to another screen or do other things
        Navigator.pushNamed(context, '/signup');
      }
    } catch (error) {
      // Handle error
      print('Error signing in with Google: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 226, 240, 247),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _logo(context),
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
              _orText(context),
              _signupWithGoogleButton(context),
            ],
          ),
        ), 
      ),
    );
  }

 _logo(context){
  return Image.asset(
      'welcome.png',
      height: 100, // Set the desired height for the logo
      fit: BoxFit.contain,
    );
 }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome To SoFam",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              
              ),
              fillColor: Color.fromARGB(255, 6, 52, 89).withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Color.fromARGB(255, 6, 52, 89).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 13, 61, 101),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 22,color: Colors.white),
            
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/forgotPassword');
      },
      child: const Text("Forgot password?",
        style: TextStyle(color: Color.fromARGB(255, 17, 32, 116)),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text("Sign Up", style: TextStyle(color: Color.fromARGB(255, 17, 32, 116)),)
        )
      ],
    );
  }

Widget _orText(BuildContext context) {
    return Text(
      "or",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }


//signup with google

 Widget _signupWithGoogleButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Login with Google "),
        TextButton(
          onPressed: () => _signupWithGoogle(context),
          child: const Text(
            "Login",
            style: TextStyle(color: Color.fromARGB(255, 17, 32, 116)),
          ),
        ),
      ],
    );
  }
}
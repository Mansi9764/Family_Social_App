import 'package:family_social/Json_Models/users.dart';
import 'package:flutter/material.dart';
// import 'package:family_social/databases/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }



 void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      Map<String, dynamic> user = {
        'username': username,
        'email': email,
        'password': password,
      };
      print("register method");
      try {
        // Register the user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        var user = userCredential.user;
        if (user != null) {
          // Prepare the user data
          Map<String, dynamic> userData = {
            'id': randomAlphaNumeric(10),
            'username': username,
            'email': email,
            
          };

          // Add the user data to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userData);

          Fluttertoast.showToast(
            msg: "User has been added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          print(userData);
          print("User Registration done");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User registered successfully')),
          );
          _formKey.currentState?.reset();
          Navigator.pushNamed(context, '/profile'); // Ensure the route exists
        }
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 240, 247),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(255, 6, 52, 89).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(255, 6, 52, 89).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(255, 6, 52, 89).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(255, 6, 52, 89).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 13, 61, 101),
                    ),
                  ),
                ),
                const Center(child: Text("Or")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Color.fromARGB(255, 13, 61, 101)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

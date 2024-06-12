import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:family_social/databases/database_helper.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); 

   @override
  State<LoginPage> createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage>{

//Controllers when we enter into it
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
   //for password
  bool isVisible= false;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      print("Going to login screen");
      String username = _usernameController.text;
      String password = _passwordController.text;
  
      // final _formKey = GlobalKey<FormState>();



      Map<String, dynamic>? user = await DatabaseHelper().getUserByUsername(username);
      
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful')),
        );
        print("user"+user.toString());
        Navigator.pushNamed(context, '/home'); // Navigate to the home page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Username or Password')),
        );
        print("user"+user.toString());
        print("Invalid");
      }
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

    Widget _inputField(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            obscureText: isVisible,
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
              }
              return null;
            },
          ),
          Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 13, 61, 101),
                    ),
                  ),
                ),
        ],
      ),
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

  Widget _signup(context) {
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
      "--------or--------",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }


//signup with google
Widget _signupWithGoogleButton(BuildContext context) {
  
       return Center(
        child: SizedBox(
          height: 50,
          child: SignInButton(
            Buttons.google,
            text:"Sign In with Google",
            onPressed : (){
              Navigator.pushNamed(context, '/signUpWithGoogle');
              },
          )
        )
       );
}


Widget _userInfo(){
  return SizedBox();
}

// void _handleGoogleSignIn(){
//   try{
//     GoogleAuthProvider _googleAuthprovider = GoogleAuthProvider();
//     _auth.signInWithProvider(_googleAuthprovider);

//   }catch(error){
//     print(error);
//   }
// }

}

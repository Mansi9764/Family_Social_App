
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'features/login_screen.dart'; 
import 'features/SignUpPage.dart'; 
import 'features/forgot_password.dart';
import 'features/GoogleSignUp.dart';
import 'features/profiles_screen/father_profile.dart';
//import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    try {
        await Firebase.initializeApp();
      } catch (e) {
        print("Firebase ka initialization error: $e");
      }
  runApp(MyApp());
}



// Future main() async{
//   WidgetsFlutterBinding.ensureInitialized();
  
//   if(kIsWeb){
//     //sqfliteFfiInit();

//     databaseFactory = databaseFactoryFfi;
//     // await Firebase.initializeApp(options:FirebaseOptions(
//     // apiKey: "AIzaSyAjvuQJ7M_Fnk7IJLmTx2B-eLo0ap74-_o",
//     // appId: "1:804874830676:web:ce08f1862bfd7994433ec1", 
//     // messagingSenderId: "804874830676",
//     // projectId: "sofam-de5b9",),
//     // );
//   }else{
//     sqfliteFfiInit();


//     databaseFactory = databaseFactoryFfi;
//     //await Firebase.initializeApp();

//   }
  
//   runApp(MyApp());
// }


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
        '/home':(context) => ProfilePage(),
        '/signup': (context) => SignUpPage(), 
        '/forgotPassword': (context) => ForgotPassword(),
        '/signUpWithGoogle': (context) => GmailInputPage(),
        '/profile':(context) => ProfilePage(),
      },
    );
  }
}


import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key}); 

   @override
  State<ProfilePage> createState() => _ProfilePagestate();
}

class _ProfilePagestate extends State<ProfilePage>{

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

}
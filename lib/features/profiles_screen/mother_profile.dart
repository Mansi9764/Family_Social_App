import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_social/features/profiles_screen/children_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'tree.dart';

class MotherProfilePage extends StatelessWidget {
  final String fatherName;
  final DateTime fatherBirthDate;
  final String fatherSex;
  final String fatherEmail;
  final String fatherLocation;
  final String fatherPhoneNumber;
  final String fatherAboutMe;

  MotherProfilePage({
    required this.fatherName,
    required this.fatherBirthDate,
    required this.fatherSex,
    required this.fatherEmail,
    required this.fatherLocation,
    required this.fatherPhoneNumber,
    required this.fatherAboutMe,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Form',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ProfileForm(
        fatherName: fatherName,
        fatherBirthDate: fatherBirthDate,
        fatherSex: fatherSex,
        fatherEmail: fatherEmail,
        fatherLocation: fatherLocation,
        fatherPhoneNumber: fatherPhoneNumber,
        fatherAboutMe: fatherAboutMe,
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  final String fatherName;
  final DateTime fatherBirthDate;
  final String fatherSex;
  final String fatherEmail;
  final String fatherLocation;
  final String fatherPhoneNumber;
  final String fatherAboutMe;

  ProfileForm({
    required this.fatherName,
    required this.fatherBirthDate,
    required this.fatherSex,
    required this.fatherEmail,
    required this.fatherLocation,
    required this.fatherPhoneNumber,
    required this.fatherAboutMe,
  });

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String _motherName = '';
  DateTime _birthDate = DateTime.now();
  String _sex = '';
  String _email = '';
  String _location = '';
  String _phoneNumber = '';
  String _aboutMe = '';
  TextEditingController _birthDateController = TextEditingController();
  List<String> _childrenNames = [];

  @override
  void initState() {
    super.initState();
    _birthDateController.text = DateFormat.yMd().format(_birthDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = DateFormat.yMd().format(_birthDate);
      });
    }
  }

  void _addChild() {
    setState(() {
      _childrenNames.add('');
    });
  }

  void _removeChild(int index) {
    setState(() {
      _childrenNames.removeAt(index);
    });
  }
  
Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

          // Save mother details
          Map<String, dynamic> motherData = {
            'motherName': _motherName,
            'birthDate': _birthDate,
            'sex': _sex,
            'email': _email,
            'location': _location,
            'phoneNumber': _phoneNumber,
            'aboutMe': _aboutMe,
          };
          await userRef.collection('Mother').doc(user.uid).set(motherData);

          // // Save children detailsR
          // for (var child in _children) {
          //   await userRef.collection('children').add(child);
          // }

           Fluttertoast.showToast(
            msg: "Profile saved successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MotherProfilePage(
                fatherName: _motherName,
                fatherBirthDate: _birthDate,
                fatherSex: _sex,
                fatherEmail: _email,
                fatherLocation: _location,
                fatherPhoneNumber: _phoneNumber,
                fatherAboutMe: _aboutMe,
              ),
            ),
          );
        } else {
          throw Exception('No user logged in');
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Up Mother\'s Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 226, 240, 247),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Profile Image Upload
                Center(
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[800],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            // Handle profile image upload
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Mother Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mother\'s Name:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mother\'s Name',
                        hintText: 'Enter Mother\'s name',
                        suffixText: '*required',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter mother\'s name';
                        }
                        return null;
                      },
                      onSaved: (value) => _motherName = value!,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                // Birthdate
                SizedBox(height: 8),
                TextFormField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    hintText: 'Enter birthdate',
                    suffixText: '*required',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 16),
                // Sex
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender*',
                    hintText: 'Select Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select sex';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _sex = value!;
                    });
                  },
                  onSaved: (value) => _sex = value!,
                ),
                SizedBox(height: 16),
                // Email
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Type here your email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(Icons.email),
                    suffixText: 'Home',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(height: 16),
                // Location
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'Your current location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(Icons.location_on),
                    suffixText: 'Current Location',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your current location';
                    }
                    return null;
                  },
                  onSaved: (value) => _location = value!,
                ),
                SizedBox(height: 16),
                // Phone Number
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Type here your telephone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    prefixIcon: Icon(Icons.phone),
                    suffixText: 'Mobile',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your telephone number';
                    }
                    return null;
                  },
                  onSaved: (value) => _phoneNumber = value!,
                ),
                SizedBox(height: 16),
                // About Me
                Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'About Me',
                    hintText: 'Tell us about yourself',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  maxLines: 5,
                  onSaved: (value) => _aboutMe = value!,
                ),
                SizedBox(height: 16),
                // // Children
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Children:',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     SizedBox(height: 8),
                //     ..._childrenNames.asMap().entries.map((entry) {
                //       int index = entry.key;
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 4.0),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: TextFormField(
                //                 decoration: InputDecoration(
                //                   labelText: 'Child\'s Name',
                //                   hintText: 'Enter Child\'s name',
                //                   border: OutlineInputBorder(
                //                     borderRadius: BorderRadius.circular(30.0),
                //                   ),
                //                 ),
                //                 onChanged: (value) {
                //                   setState(() {
                //                     _childrenNames[index] = value;
                //                   });
                //                 },
                //               ),
                //             ),
                //             IconButton(
                //               icon: Icon(Icons.remove_circle),
                //               onPressed: () => _removeChild(index),
                //             ),
                //           ],
                //         ),
                //       );
                //     }).toList(),
                //     SizedBox(height: 8),
                //     ElevatedButton(
                //       onPressed: _addChild,
                //       child: Text('Add Child'),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 16),
                // Next Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChildrenProfilePage(),
                                    ),
                                  );
                                },
                                child: Text('Add Children'),
                            ),
                  ],
                ),
                SizedBox(height: 16),
                // Note at the end
                SizedBox(height: 16),
                Text(
                  '* All fields marked with an asterisk are required.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

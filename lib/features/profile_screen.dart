import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Form',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ProfileForm(),
    );
  }
}

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String _fatherName = '';
  String _motherName = '';
  String _email = '';
  String _location = '';
  DateTime _birthDate = DateTime.now(); // Default to current date
  String _phoneNumber = '';
  List<Map<String, dynamic>> _children = [];

  void _addChild() {
    setState(() {
      _children.add({'name': '', 'birthDate': DateTime.now()});
    });
  }

  void _removeChild(int index) {
    setState(() {
      _children.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Up Your Profile'),
      ),
      backgroundColor: const Color.fromARGB(255, 226, 240, 247),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                // Father Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Father\'s Name',
                    hintText: 'Enter Father name',
                    suffixText: '*required',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter father\'s name';
                    }
                    return null;
                  },
                  onSaved: (value) => _fatherName = value!,
                ),
                SizedBox(height: 16),
                // Mother Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mother\'s Name',
                    hintText: 'Enter Mother name',
                    suffixText: '*required',
                    border: OutlineInputBorder(),
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
                Text(
                  'More info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 35, 31, 22)),
                ),
                // Email
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Type here your email address',
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                // Children Section
                Text(
                  'Add Your Children',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _children.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Child Name',
                            hintText: 'Enter child\'s name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter child\'s name';
                            }
                            return null;
                          },
                          onSaved: (value) => _children[index]['name'] = value!,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Child Birth Date',
                            hintText: 'Select child\'s birth date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _children[index]['birthDate'],
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _children[index]['birthDate'] = picked;
                              });
                            }
                          },
                          controller: TextEditingController(
                            text: "${_children[index]['birthDate'].year}-${_children[index]['birthDate'].month}-${_children[index]['birthDate'].day}",
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removeChild(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addChild,
                  child: Text('Add Child'),
                ),
                SizedBox(height: 16),
                // Create Profile Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Handle form submission
                    }
                  },
                  child: Text('Create Profile'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 13, 36, 72),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

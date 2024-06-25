 import 'package:family_social/features/profiles_screen/tree.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildrenProfilePage extends StatefulWidget {
  @override
  _ChildrenProfilePageState createState() => _ChildrenProfilePageState();
}

class _ChildrenProfilePageState extends State<ChildrenProfilePage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _children = [];
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _birthDateControllers = [];

  @override
  void dispose() {
    _nameControllers.forEach((controller) => controller.dispose());
    _birthDateControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addChild() {
    setState(() {
      _children.add({'name': '', 'birthDate': DateTime.now()});
      _nameControllers.add(TextEditingController());
      _birthDateControllers.add(TextEditingController(text: DateFormat.yMd().format(DateTime.now())));
    });
  }

  void _removeChild(int index) {
    setState(() {
      _children.removeAt(index);
      _nameControllers[index].dispose();
      _birthDateControllers[index].dispose();
      _nameControllers.removeAt(index);
      _birthDateControllers.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _children[index]['birthDate'],
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _children[index]['birthDate']) {
      setState(() {
        _children[index]['birthDate'] = picked;
        _birthDateControllers[index].text = DateFormat.yMd().format(picked);
      });
    }
  }

  Future<void> _saveChildren() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

          // Save children details
          for (var child in _children) {
            await userRef.collection('children').add(child);
          }

          Fluttertoast.showToast(
            msg: "Children details saved successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.push(context, TreePage as Route<Object?>);
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
        title: Text('Children Profiles'),
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _children.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _nameControllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Child\'s Name',
                                  hintText: 'Enter child\'s name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter child\'s name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _children[index]['name'] = value!;
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () => _removeChild(index),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _birthDateControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Birthdate',
                            hintText: 'Enter birthdate',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            prefixIcon: Icon(Icons.calendar_today), // Add calendar icon
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context, index),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: _addChild,
                  child: Text('Add Child'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveChildren,
                  child: Text('Save Children'),
                ),
                SizedBox(height: 16),
                Text(
                  '* All fields marked with an asterisk are required.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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

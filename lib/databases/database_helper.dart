import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final querySnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }

  Future<void> addUser(Map<String, dynamic> userData, String id) async {
    print("add user");
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).set(userData);
    } else {
      throw Exception('No user logged in');
    }
  }
}

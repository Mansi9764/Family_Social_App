import 'dart:convert';

// Function to convert User object to JSON string
String userToMap(User data) => json.encode(data.toMap());

class User {
  int? _usrId;
  late String _username;
  late String _email;
  late String _password;

  // Constructor for creating a new user
  User(this._username, this._email, this._password, [this._usrId]);

  // Named constructor to create a User object from a map
  User.map(dynamic obj) {
    _usrId = obj['id'];
    _username = obj['username'];
    _email = obj['email'];
    _password = obj['password'];
  }

  int? get id => _usrId;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": _usrId,
      "username": _username,
      "email": _email,
      "password": _password,
    };
    return map;
  }

  // Factory constructor to create a User object from a map
  factory User.fromMap(Map<String, dynamic> json) => User(
        json["username"],
        json["email"],
        json["password"],
        json["id"],
      );
}

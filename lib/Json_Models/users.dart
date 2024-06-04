// To parse this JSON data, do
//
//     final users = usersFromMap(jsonString);

import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
    String usrId;
    String userName;
    String usrPassword;

    Users({
        required this.usrId,
        required this.userName,
        required this.usrPassword,
    });

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        userName: json["userName"],
        usrPassword: json["usrPassword"],
    );

    Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "userName": userName,
        "usrPassword": usrPassword,
    };
}

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.online,
        this.name,
        this.email,
        this.uid,
    });

    bool online;
    String name;
    String email;
    String uid;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        online: json["online"],
        name: json["name"],
        email: json["email"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "name": name,
        "email": email,
        "uid": uid,
    };
}

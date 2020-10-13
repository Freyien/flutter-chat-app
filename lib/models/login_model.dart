// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';
import 'package:chat/models/user_model.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.ok,
        this.user,
        this.token,
    });

    bool ok;
    UserModel user;
    String token;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        ok: json["ok"],
        user: UserModel.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "user": user.toJson(),
        "token": token,
    };
}

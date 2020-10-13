import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/helpers/errors.dart';
import 'package:chat/global/enviroment.dart';
import 'package:chat/models/login_model.dart';
import 'package:chat/models/user_model.dart';

class AuthService with ChangeNotifier {

  UserModel user;
  bool _waiting = false;
  final _storage = new FlutterSecureStorage();

  bool get waiting => this._waiting;

  set waiting( bool waiting ) {
    this._waiting = waiting;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');

    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.delete(key: 'token');
  }
  
  Future<bool> login(String email, String password) async {
    bool loginStatus = false;
    this.waiting = true;
    
    final data = {
      'email': email,
      'password': password
    };

    final res = await http.post('${Enviroment.apiUrl}/login', 
      body: jsonEncode(data),
      headers: { 'Content-Type': 'application/json' }
    );

    print(res.body);
    if (res.statusCode == 200) {
      final loginResponse = loginModelFromJson(res.body);
      this.user = loginResponse.user;

      await this._saveToken(loginResponse.token);

      loginStatus = true;
    }

    this.waiting = false;
    return loginStatus;

  }

  Future<String> register(String name, String email, String password) async {
    String registerError = '';
    this.waiting = true;
    
    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final res = await http.post('${Enviroment.apiUrl}/login/new', 
      body: jsonEncode(data),
      headers: { 'Content-Type': 'application/json' }
    );

    print(res.body);
    if (res.statusCode == 200) {
      final registerResponse = loginModelFromJson(res.body);
      this.user = registerResponse.user;

      await this._saveToken(registerResponse.token);

    } else {
      final errorMessage = jsonDecode(res.body)['msg'];
      registerError = errors[errorMessage]??'Error desconocido';
    }

    this.waiting = false;
    return registerError;
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    final res = await http.get('${Enviroment.apiUrl}/login/renew', 
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token
      }
    );

    if (res.statusCode == 200) {
      final registerResponse = loginModelFromJson(res.body);
      this.user = registerResponse.user;

      await this._saveToken(registerResponse.token);
      return true;
    } else {
      await this.logOut();
      return false;
    }

    
  }

  Future<void> _saveToken( String token ) async {
    await this._storage.write(key: 'token', value: token);
  }

  Future logOut( ) async {
    await this._storage.delete(key: 'token');
  }
  
}
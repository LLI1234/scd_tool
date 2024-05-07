import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginData with ChangeNotifier {
  String _cookie = "";

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(Uri.parse('https://scd-tool-api.onrender.com/session'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }));
    if (response.statusCode == 200) {
      print(response.headers['set-cookie']);
      _cookie = response.headers['set-cookie']!;
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logoutUser() async {
    final response = await http.delete(
      Uri.parse('https://scd-tool-api.onrender.com/session'),
      headers: {'Cookie': _cookie},
    );
    if (response.statusCode == 200) {
      _cookie = "";
      notifyListeners();
    } else {
      throw Exception('Failed to logout');
    }
  }

  String getCookie() {
    return _cookie;
  }
}

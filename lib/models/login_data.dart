import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginData with ChangeNotifier {
  String _cookie = "";

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(Uri.parse('http://localhost:5000/session'),
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

  String getCookie() {
    return _cookie;
  }
}

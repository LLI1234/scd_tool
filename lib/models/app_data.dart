import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_data.dart';

class AppData with ChangeNotifier {
  final LoginData loginData;
  List<Map<String, dynamic>> savedPhysicians = [];
  bool error = false;

  AppData({required this.loginData});

  Future<void> getSavedPhysicians() async {
    final cookie = loginData.getCookie();
    final response = await http.get(
      Uri.parse('http://localhost:5000/user/current/saved-physician'),
      headers: {'Cookie': cookie},
    );
    //print(response.body);
    if (response.statusCode == 200) {
      savedPhysicians =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      notifyListeners();
    } else {
      error = true;
      throw Exception('Failed to load center data');
    }
  }
}

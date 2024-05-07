import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_data.dart';

class AppData with ChangeNotifier {
  final LoginData loginData;
  Map<String, dynamic> userInfo = {};
  List<Map<String, dynamic>> savedPhysicians = [];
  List<Map<String, dynamic>> dailySymptoms = [];
  bool error = false;

  List<Map<String, dynamic>> scoredPhysicians = [];
  Map<String, dynamic> similarPhysician = {};
  bool _isFetched = false;

  AppData({required this.loginData});

  Future<void> getUserInfo() async {
    final cookie = loginData.getCookie();
    final response = await http.get(
      Uri.parse('https://scd-tool-api.onrender.com/user/current'),
      headers: {'Cookie': cookie},
    );
    //print(response.body);
    if (response.statusCode == 200) {
      userInfo = Map<String, dynamic>.from(json.decode(response.body));
      notifyListeners();
    } else {
      error = true;
      throw Exception('Failed to load center data');
    }
  }

  Future<void> fetchScoredPhysicians() async {
    final cookie = loginData.getCookie();
    if (!_isFetched) {
      final response = await http.get(
        Uri.parse('https://scd-tool-api.onrender.com/user/current/score-match'),
        headers: {'Cookie': cookie},
      );

      if (response.statusCode == 200) {
        scoredPhysicians =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load center data');
      }

      _isFetched = true;
      notifyListeners();
    }
  }

  Future<void> fetchSimilarPhysician() async {
    final cookie = loginData.getCookie();
    if (!_isFetched) {
      final response = await http.get(
        Uri.parse('https://scd-tool-api.onrender.com/user/current/KNN-match'),
        headers: {'Cookie': cookie},
      );

      if (response.statusCode == 200) {
        similarPhysician =
            Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load center data');
      }

      _isFetched = true;
      notifyListeners();
    }
  }

  Future<void> getSavedPhysicians() async {
    final cookie = loginData.getCookie();
    final response = await http.get(
      Uri.parse('https://scd-tool-api.onrender.com/user/current/saved-physician'),
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

  Future<void> getDailySymptoms() async {
    final cookie = loginData.getCookie();
    final response = await http.get(
      Uri.parse('https://scd-tool-api.onrender.com/user/current/daily-symptoms'),
      headers: {'Cookie': cookie},
    );
    //print(response.body);
    if (response.statusCode == 200) {
      dailySymptoms =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      notifyListeners();
    } else {
      error = true;
      throw Exception('Failed to load center data');
    }
  }
}

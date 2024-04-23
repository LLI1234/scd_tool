import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../components/match_card.dart';
import '../models/login_data.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<Map<String, dynamic>> scoredPhysicians = [];
  Map<String, dynamic> similarPhysician = {};
  late Future<void> scoredPhysiciansFuture;
  late Future<void> similarPhysicianFuture;

  Future<void> getScoredPhysicians() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/user/current/score-match'),
        headers: {'Cookie': context.read<LoginData>().getCookie()});
    //print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        scoredPhysicians =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load center data');
    }
  }

  Future<void> getSimilarPhysician() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/user/current/KNN-match'),
      headers: {'Cookie': context.read<LoginData>().getCookie()},
    );

    if (response.statusCode == 200) {
      setState(() {
        similarPhysician =
            Map<String, dynamic>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load center data');
    }
  }

  @override
  void initState() {
    super.initState();
    scoredPhysiciansFuture = getScoredPhysicians();
    similarPhysicianFuture = getSimilarPhysician();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([scoredPhysiciansFuture, similarPhysicianFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Loading spinner
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Selected By Users Like You',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: MatchCard(
                        physician: similarPhysician,
                        hasScore: false,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Matches For You',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    ...scoredPhysicians.map((physician) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: MatchCard(
                          physician: physician,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/center_card.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<Map<String, dynamic>> scoredCenters = [];
  Map<String, dynamic> similarCenter = {};
  late Future<void> scoredCentersFuture;
  late Future<void> similarCenterFuture;

  Future<void> getScoredCenters() async {
    final response = await http.get(Uri.parse('http://localhost:5000/center'));
    //print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        scoredCenters =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load center data');
    }
  }

  Future<void> getSimilarCenter() async {
    final response = await http.get(Uri.parse('http://localhost:5000/center'));
    //print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        similarCenter =
            Map<String, dynamic>.from(json.decode(response.body)[0]);
      });
    } else {
      throw Exception('Failed to load center data');
    }
  }

  @override
  void initState() {
    super.initState();
    scoredCentersFuture = getScoredCenters();
    similarCenterFuture = getSimilarCenter();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([scoredCentersFuture, similarCenterFuture]),
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
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: SingleChildScrollView(
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CenterCard(
                        center: similarCenter,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Matches For You',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...scoredCenters.map((center) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CenterCard(
                          center: center,
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

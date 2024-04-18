import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/match_card.dart';

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
    final response =
        await http.get(Uri.parse('http://localhost:5000/physician'));
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

  // Future<void> getSimilarPhysician() async {
  //   final loginBloc = BlocProvider.of<LoginBloc>(context);
  //   String cookie = loginBloc.state.props[0] as String;

  //   final response = await http.get(
  //     Uri.parse('http://localhost:5000/match/KNN'),
  //     headers: {'Cookie': 'session=.$cookie;'},
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       similarPhysician = Map<String, dynamic>.from(json.decode(response.body));
  //     });
  //   } else {
  //     throw Exception('Failed to load center data');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    scoredPhysiciansFuture = getScoredPhysicians();
    similarPhysicianFuture = getScoredPhysicians();
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: MatchCard(
                        physician: scoredPhysicians[0],
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

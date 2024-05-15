import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../components/match_card.dart';
import '../models/login_data.dart';
import '../models/app_data.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  late Future<void> scoredPhysiciansFuture;
  late Future<void> similarPhysicianFuture;

  @override
  void initState() {
    super.initState();
    var appData = Provider.of<AppData>(context, listen: false);
    scoredPhysiciansFuture = appData.fetchScoredPhysicians();
    similarPhysicianFuture = appData.fetchSimilarPhysician();
  }

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);

    return FutureBuilder(
      future: Future.wait([scoredPhysiciansFuture, similarPhysicianFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(), // Loading spinner
                  SizedBox(height: 20), // Add some spacing
                  Text(
                    'Please Wait,\nGenerating Matches...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0, // Set the font size
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Change the text color
                    ),
                  ),
                ],
              ),
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
                        'Explore Matched Physicians',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Top Physician Selected By Similar Users',
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
                        physician: appData.similarPhysician,
                        hasScore: false,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Best Matching Physicians',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    ...appData.scoredPhysicians.map((physician) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
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

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/match_card.dart';
import 'login_bloc.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<Map<String, dynamic>> savedPhysicians = [];
  late Future<void> savedPhysiciansFuture;

  Future<void> getSavedPhysicians() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/physician'));
    //print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        var physicians =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        savedPhysicians = physicians.take(3).toList();
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
    savedPhysiciansFuture = getSavedPhysicians();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        savedPhysiciansFuture,
      ]),
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
                        'Saved Physicians',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    ...savedPhysicians.map((physician) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: MatchCard(
                          physician: physician,
                          hasScore: false,
                          hasSaved: true,
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

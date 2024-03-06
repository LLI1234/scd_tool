import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
    print(response.body);
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
    print(response.body);
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
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90, //Max width
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20.0),
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
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class CenterCard extends StatelessWidget {
  final Map<String, dynamic> center;

  const CenterCard({
    Key? key,
    required this.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CenterDetailsPage(center: center)),
        );
      },
      child: Center(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    NetworkImage(center['image_link'] ?? 'default_image_link'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                // Add this
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            width: double.infinity,
            height: 120.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    center['name'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    center['address'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class CenterDetailsPage extends StatelessWidget {
  final Map<String, dynamic> center;

  const CenterDetailsPage({super.key, required this.center});

  void _launchURL() async {
    final url = Uri.parse(center['website']);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 180,
                    child: Image.network(
                      center['image_link'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          center['name'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              center['reviews'].toString(),
                              style: TextStyle(
                                color: Colors.yellow[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          center['address'],
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.directions_walk_outlined,
                                    color: Colors.black45, size: 36.0),
                                Text(
                                  '30 Min',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.directions_car_outlined,
                                    color: Colors.black45, size: 36.0),
                                Text(
                                  '5 Min',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.directions_transit_outlined,
                                    color: Colors.black45, size: 36.0),
                                Text(
                                  '20 Min',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.directions_bike_outlined,
                                    color: Colors.black45, size: 36.0),
                                Text(
                                  '15 Min',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          "Treatments Offered",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children:
                              center['treatments'].map<Widget>((treatment) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('•',
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 16.0)),
                                SizedBox(width: 5.0), // Add some space
                                Text(
                                  treatment['type']
                                      .split('_')
                                      .map((str) =>
                                          '${str[0].toUpperCase()}${str.substring(1)}')
                                      .join(' '), // The name of the insurance
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 16.0),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          "Insurances Accepted",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children:
                              center['insurances'].map<Widget>((insurance) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('•',
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 16.0)),
                                SizedBox(width: 5.0), // Add some space
                                Text(
                                  insurance['name']
                                      .split('_')
                                      .map((str) =>
                                          '${str[0].toUpperCase()}${str.substring(1)}')
                                      .join(' '), // The name of the insurance
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 16.0),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 25.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _launchURL,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.web),
                                    SizedBox(width: 5),
                                    Text('Website'),
                                  ],
                                ),
                              ),
                              ButtonTheme(
                                minWidth: 50.0,
                                height: 50.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: _launchURL,
                                    icon: Icon(Icons.call),
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  shape: BoxShape.circle, // Make it circular
                  boxShadow: [
                    // Give it a shadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Positioned(
                  top: 0,
                  left: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

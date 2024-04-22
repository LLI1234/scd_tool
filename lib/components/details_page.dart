import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../components/bulleted_list_item.dart';
import '../models/login_data.dart';
import '../models/app_data.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> physician;

  DetailsPage({
    super.key,
    required this.physician,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  void _launchURL() async {
    final url = Uri.parse(widget.physician['center']['website']);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> savePhysician() async {
    String cookie = context.read<LoginData>().getCookie();
    final response = await http.put(
      Uri.parse(
          'http://localhost:5000/user/current/saved-physician/${widget.physician["id"]}'),
      headers: {'Cookie': cookie},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Request successful');
      if (mounted) {
        await context.read<AppData>().getSavedPhysicians();
      }
    } else {
      // If the server returns an unsuccessful response code, throw an exception.
      throw Exception('Failed to save physician');
    }
  }

  Future<void> unsavePhysician() async {
    String cookie = context.read<LoginData>().getCookie();
    final response = await http.delete(
      Uri.parse(
          'http://localhost:5000/user/current/saved-physician/${widget.physician["id"]}'),
      headers: {'Cookie': cookie},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Request successful');
      if (mounted) {
        await context.read<AppData>().getSavedPhysicians();
      }
    } else {
      // If the server returns an unsuccessful response code, throw an exception.
      throw Exception('Failed to unsave physician');
    }
  }

  @override
  void initState(){
    context.read<AppData>().getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget pill(label, [match]) {
      return Chip(
          label: Text(
            label,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          backgroundColor: Colors.white,
          side: match != null && match
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2)
              : BorderSide(color: Theme.of(context).colorScheme.onBackground),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))));
    }

    var traits = [
      ['Efficient', 'Patient'],
      ['Empathetic', 'Analytical'],
      ['Structured', 'Flexible'],
      ['Respectful', 'Direct'],
      ['Humble', 'Ambitious']
    ];
    var userData = context.read<AppData>().userInfo;
    List<Widget> attrs = [];

    for (var i = 0; i < traits.length; i++) {
      var attr = widget.physician["avg_attr"]["attribute${i + 1}"];
      var pref = userData["attribute${i + 1}"];
      if (attr == null) {
        continue;
      }
      if (attr < 0.4) {
        attrs.add(pill(traits[i][0], pref < 0.4));
      } else if (attr > 0.6) {
        attrs.add(pill(traits[i][0], pref > 0.6));
      }
    }

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
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(children: [
                        Flexible(
                            child:
                                widget.physician['image_link'] == null
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'images/placeholder.png',
                                        // image: widget.physician['image_link'],
                                        image:
                                            "https://www.ucsfbenioffchildrens.org/-/media/project/ucsf/ucsf-bch/images/provider/card/dr-elliot-vichinsky-md-82485-320x320-2x.jpg?h=526&w=526&hash=EA6ACF344531E2CA7F4EC9614BA34C07",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        alignment: Alignment.topCenter,
                                      )
                                    : Image.asset(
                                        'images/placeholder.png',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.physician['first_name'] +
                                            ' ' +
                                            widget.physician['last_name'],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w500,
                                            height: 1.0),
                                      ),
                                      Consumer<AppData>(
                                        builder: (context, appData, child) {
                                          bool isSaved = appData.savedPhysicians
                                              .any((savedPhysician) =>
                                                  savedPhysician['id'] ==
                                                  widget.physician['id']);

                                          return InputChip(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            label: Text(
                                              isSaved ? 'Saved' : 'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            selected: isSaved,
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            checkmarkColor: Colors.white,
                                            onSelected: (bool selected) {
                                              if (isSaved) {
                                                unsavePhysician();
                                              } else {
                                                savePhysician();
                                              }
                                              // Trigger a rebuild of the Consumer widget to update isSaved
                                              appData.notifyListeners();
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.physician['title'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.physician['center']['address'],
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      pill(widget.physician['ethnicity']),
                                      widget.physician['additional_language'] ==
                                              'None'
                                          ? pill("Speaks English")
                                          : pill(
                                              "Speaks English and ${widget.physician['additional_language']}"),
                                      ...attrs
                                    ],
                                  ),
                                  SizedBox(height: 10.0)
                                ]))
                      ])),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(right: 7.5),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.physician["avg_user_rating"]
                                        .toStringAsFixed(1),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 50,
                                        height: 1.0),
                                  ),
                                  Text(
                                    'User Rating',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 7.5),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.physician["match_score"] != null ?
                                        widget.physician["match_score"].toStringAsFixed(1) : "5.0"
                                        ,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 50,
                                            height: 1.0),
                                      ),
                                      Text(
                                        'Match Score',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color:
                                    Theme.of(context).colorScheme.background),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              Text(
                                widget.physician['center']['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                    widget.physician['center']['address'],
                                    textAlign: TextAlign.center,),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.directions_walk_outlined,
                                          color: Colors.black87, size: 36.0),
                                      Text(
                                        '30 Min',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.directions_car_outlined,
                                          color: Colors.black87, size: 36.0),
                                      Text(
                                        '5 Min',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.directions_transit_outlined,
                                          color: Colors.black87, size: 36.0),
                                      Text(
                                        '20 Min',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.directions_bike_outlined,
                                          color: Colors.black87, size: 36.0),
                                      Text(
                                        '15 Min',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                "Insurances Accepted",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 7.5),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8.0, // gap between adjacent chips
                                runSpacing: 8.0, // gap between lines
                                children: widget.physician['center']
                                        ['insurances']
                                    .map<Widget>((insurance) {
                                  return pill(
                                      insurance['name']
                                          .split('_')
                                          .map((str) =>
                                              '${str[0].toUpperCase()}${str.substring(1)}')
                                          .join(' '),
                                      insurance['name'] ==
                                          userData['insurance']['name']);
                                }).toList(),
                              ),
                            ])),
                        SizedBox(height: 10.0),
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
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // This is the color of the text
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary, // This is the background color
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.arrow_back_ios, size: 15.0),
                      Text('Physician Match'),
                    ],
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

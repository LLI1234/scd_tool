import "package:flutter/material.dart";
import 'package:scd_tool/components/bulleted_list_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/login_bloc.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> physician;
  bool isSaved;
  final Function getSavedPhysicians;

  static void defaultFunction() {
    // This is an empty function that does nothing.
  }

  DetailsPage({
    super.key,
    required this.physician,
    this.isSaved = false,
    this.getSavedPhysicians = defaultFunction,
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
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    String cookie = loginBloc.state.props[0] as String;
    final response = await http.put(
      Uri.parse(
          'http://localhost:5000/user/current/saved-physician/${widget.physician["id"]}'),
      headers: {'Cookie': 'session=.$cookie;'},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Request successful');
      widget.getSavedPhysicians();
    } else {
      // If the server returns an unsuccessful response code, throw an exception.
      throw Exception('Failed to save physician');
    }
  }

  Future<void> unsavePhysician() async {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    String cookie = loginBloc.state.props[0] as String;
    final response = await http.delete(
      Uri.parse(
          'http://localhost:5000/user/current/saved-physician/${widget.physician["id"]}'),
      headers: {'Cookie': 'session=.$cookie;'},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('Request successful');
      widget.getSavedPhysicians();
    } else {
      // If the server returns an unsuccessful response code, throw an exception.
      throw Exception('Failed to unsave physician');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> traits = ['Welcoming', 'Knowledgeable'];

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
                    child: widget.physician['center']['image_link'] != null
                        ? FadeInImage.assetNetwork(
                            placeholder: 'images/placeholder.png',
                            image: widget.physician['center']['image_link'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Image.asset(
                            'images/placeholder.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.physician['first_name'] +
                                  ' ' +
                                  widget.physician['last_name'],
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0),
                            ),
                            InputChip(
                              label: Text(widget.isSaved ? 'Saved' : 'Save'),
                              selected: widget.isSaved,
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.isSaved = !widget.isSaved;
                                });
                                if (widget.isSaved) {
                                  savePhysician();
                                } else {
                                  unsavePhysician();
                                }
                              },
                              labelStyle: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
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
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '5.0',
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
                            ),
                            SizedBox(width: 20.0),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '5.0',
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          "Ethnicity",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child:
                              BulletedListItem(widget.physician['ethnicity']),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Additional Language",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: BulletedListItem(
                              widget.physician['additional_language']),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Traits",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ...traits.map((trait) {
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: BulletedListItem(trait));
                        }).toList(),
                        SizedBox(height: 10.0),
                        Text(
                          "Center Information",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: BulletedListItem(
                              widget.physician['center']['name']),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: BulletedListItem(
                              widget.physician['center']['address']),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children: widget.physician['center']['insurances']
                              .map<Widget>((insurance) {
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

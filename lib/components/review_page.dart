import "package:flutter/material.dart";
import 'package:scd_tool/components/bulleted_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewPage extends StatefulWidget {
  final Map<String, dynamic> physician;
  bool selected;

  ReviewPage({
    super.key,
    required this.physician,
    this.selected = false,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  void _launchURL() async {
    final url = Uri.parse(widget.physician['center']['website']);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 60.0),
                    Text(
                      widget.physician['first_name'] +
                          ' ' +
                          widget.physician['last_name'],
                      textAlign: TextAlign.center, // Add t
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w500,
                          height: 1.0),
                    ),
                    Text(
                      widget.physician['title'],
                      textAlign: TextAlign.center, // Add t
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.physician['center']['name'],
                      textAlign: TextAlign.center, // Add t
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.physician['center']['address'],
                      textAlign: TextAlign.center, // Add t
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
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
                      Text('Saved Physicians'),
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

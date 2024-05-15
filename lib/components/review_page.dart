import "package:flutter/material.dart";
import 'package:scd_tool/components/bulleted_list_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  double _rating = 0.0;

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

    return SafeArea(child: Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 48.0),
                    Text("How was your visit with",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        )),
                    SizedBox(height: 10),
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
                    SizedBox(height: 6),
                    Text(
                      widget.physician['title'] +
                          ', ' +
                          widget.physician['center']['name'],
                      textAlign: TextAlign.center, // Add t
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      'Overall experience',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Care to share more?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'How was your overall experience? What did you like or dislike?',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0), // Add some space before the button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary, // background color
                        foregroundColor: Theme.of(context)
                            .colorScheme
                            .onPrimary, // text color
                      ),
                    ),
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
    ));
  }
}

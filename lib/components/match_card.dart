import "package:flutter/material.dart";

import "details_page.dart";
import "review_page.dart";

class MatchCard extends StatefulWidget {
  final Map<String, dynamic> physician;
  final bool hasScore;
  final bool hasVisited;
  bool isVisited;

  MatchCard({
    Key? key,
    required this.physician,
    this.hasScore = true,
    this.hasVisited = false,
    this.isVisited = false,
  }) : super(key: key);

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsPage(
                    physician: widget.physician,
                  )),
        );
      },
      child: Center(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1)),
              ],
            ),
            width: double.infinity,
            height: 110.0,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: widget.physician['center']['image_link'] !=
                                  null
                              ? NetworkImage(
                                      widget.physician['center']['image_link'])
                                  as ImageProvider<Object>
                              : const AssetImage('images/placeholder.png')
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(3.0)),
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.physician['first_name'] +
                                      ' ' +
                                      widget.physician['last_name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                    height: 0.8,
                                  ),
                                ),
                                if (widget
                                    .hasScore) // If hasScore is true, render the score
                                  Text(
                                    "5.0",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      height: 0.8,
                                    ),
                                  ),
                                if (widget
                                    .hasVisited) // If hasVisited is true, render the saved icon
                                  InputChip(
                                    label: Text(widget.isVisited
                                        ? 'Visited'
                                        : 'Visited?'),
                                    selected: widget.isVisited,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (!widget.isVisited && selected) {
                                          Future.delayed(
                                              Duration(milliseconds: 500), () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Center(
                                                    child: Text(
                                                      'Leave a review for this physician?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextButton(
                                                          child: Text('SKIP'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          child: Text('OK',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ReviewPage(
                                                                          physician:
                                                                              widget.physician)),
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty.all<
                                                                    Color>(Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                        widget.isVisited = selected;
                                      });
                                    },
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 10.0),
                                    selectedColor:
                                        Theme.of(context).colorScheme.primary,
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  )
                              ],
                            ),
                            Text(
                              widget.physician['title'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.physician['center']['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.physician['center']['address'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

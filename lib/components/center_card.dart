import "package:flutter/material.dart";
import "center_details.dart";

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
                image: center['image_link'] != null
                    ? NetworkImage(center['image_link'])
                        as ImageProvider<Object>
                    : const AssetImage('images/placeholder.png')
                        as ImageProvider<Object>,
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

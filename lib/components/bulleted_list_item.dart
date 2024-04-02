import "package:flutter/material.dart";

class BulletedListItem extends StatelessWidget {
  final String text;

  const BulletedListItem(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('•', style: TextStyle(color: Colors.black87, fontSize: 16.0)),
        SizedBox(width: 5.0), // Add some space
        Text(text, style: TextStyle(color: Colors.black87, fontSize: 16.0)),
      ],
    );
  }
}

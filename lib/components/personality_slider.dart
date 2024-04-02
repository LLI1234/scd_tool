import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";


class PersonalitySlider extends StatefulWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Function(double) onChanged;

  PersonalitySlider ({
    Key? key,
    required this.title,
    required this.value,
    this.min = 0,
    this.max = 10,
    this.divisions = 10,
    required this.onChanged
  }) : super(key: key);

  @override
  State<PersonalitySlider> createState()   => _PersonalitySliderState();
}

class _PersonalitySliderState extends State<PersonalitySlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20)
          )
        ),
        Slider(
          value: widget.value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
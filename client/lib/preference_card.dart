import 'package:flutter/material.dart';

class PreferenceCard extends StatefulWidget {
  final String category;
  final Function onTap;

  const PreferenceCard(
      {super.key, required this.category, required this.onTap});

  @override
  State<PreferenceCard> createState() => _PreferenceCardState();
}

class _PreferenceCardState extends State<PreferenceCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      surfaceTintColor: selected ? ThemeData().primaryColor : Colors.white,
      child: InkWell(
          splashColor: ThemeData().primaryColor.withAlpha(30),
          onTap: () {
            setState(() {
              selected = !selected;
            });
            widget.onTap();
          },
          child: SizedBox.expand(
              child: Center(
            child: Text(
              widget.category,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ))),
    );
  }
}

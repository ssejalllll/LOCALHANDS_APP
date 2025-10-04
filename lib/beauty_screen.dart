import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BeautyScreen(),
  ));
}

class BeautyScreen extends StatefulWidget {
  @override
  _BeautyScreenState createState() => _BeautyScreenState();
}

class _BeautyScreenState extends State<BeautyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      Row(children: [
        Icon(
            icons.location_on,
        )
      ],)
    );
  }
}
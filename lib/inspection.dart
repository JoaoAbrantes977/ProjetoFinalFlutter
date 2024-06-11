import 'package:flutter/material.dart';

class InspectionsPage extends StatefulWidget {
  @override
  InspectionsPageState createState() => InspectionsPageState();
}

class InspectionsPageState extends State<InspectionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Inspections'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Inspections Page',
                style: TextStyle(fontSize: 24),
              ),
              // Add your registration form fields here
            ],
          ),
        ),
      ),
    );
  }
}

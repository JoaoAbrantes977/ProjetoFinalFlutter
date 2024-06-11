import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/login.dart';

import 'inspection/create-inspection.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    // Placeholder for user profile picture
                    backgroundImage: AssetImage('assets/user_profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'user@example.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
              onTap: () {
                // Show app version information
              },
            ),
            // Add more list tiles for other features
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 150,
                  color: Colors.blue,
                  child: const Center(child: Text('Box 1')),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 150,
                  color: Colors.green,
                  child: const Center(child: Text('Box 2')),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 150,
                  color: Colors.orange,
                  child: const Center(child: Text('Box 3')),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateInspectionPage()),
          );
        },
        label: Text('Novo Projeto'),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

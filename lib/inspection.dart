import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drone/drone.dart';
import 'recommendations.dart';
import 'inspection/create-inspection.dart';
import 'inspection/details-inspection.dart';
import 'package:projeto_final_flutter/user/login.dart';

class InspectionsPage extends StatefulWidget {
  @override
  InspectionsPageState createState() => InspectionsPageState();
}

class InspectionsPageState extends State<InspectionsPage> {
  // Access the User class
  User user = User.userInstance;
  List<dynamic> inspections = []; // List to store inspection data
  int _selectedIndex = 0; // Index for the selected tab

  @override
  void initState() {
    super.initState();
    fetchInspections(); // Fetch inspections when the widget initializes
  }

  // Function to fetch inspections
  Future<void> fetchInspections() async {
    String userId = user.id;
    String url = 'http://10.0.2.2:3000/inspection/all/$userId'; // Replace with your API endpoint
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON and update the state
      List<dynamic> data = json.decode(response.body)['inspections'];
      setState(() {
        inspections = data;
      });
    } else {
      // If the server did not return a 200 OK response, throw an error.
      throw Exception('Failed to load inspections');
    }
  }

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = user.email;

    // List of pages corresponding to each tab
    List<Widget> _pages = [
      buildInspectionsList(),
      DronesPage(),
      RecommendationsPage(),
    ];

    // List of titles for each tab
    List<String> _titles = [
      'Os meus Projetos',
      'Drones',
      'Recomendações',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    // Placeholder for user profile picture
                    backgroundImage: AssetImage('assets/user_profile.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'João', // Replace with user name if available
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    userEmail, // Display user's email
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                // Reset user instance upon logout
                User.setUserInstance(User("default_email", "default_id"));

                // Navigate to login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            const Divider(),
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
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Projetos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_active),
            label: 'Drones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recomendações',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateInspectionPage()),
          );
        },
        label: const Text('Novo Projeto'),
        icon: const Icon(Icons.add),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Widget to build the list of inspections
  Widget buildInspectionsList() {
    return ListView.builder(
      itemCount: inspections.length,
      itemBuilder: (BuildContext context, int index) {
        dynamic inspection = inspections[index];
        String inspectionName = inspection['tipo']['nome'];
        String inspectionId = inspection['id'].toString(); // Get inspection ID
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 4, // Add elevation for a shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: InkWell(
              onTap: () {
                // Navigate to inspection details page when card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InspectionDetailsPage(inspectionId: inspectionId),
                  ),
                );
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue, // Background color
                ),
                child: Center(
                  child: Text(
                    inspectionName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

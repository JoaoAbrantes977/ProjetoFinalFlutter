import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final_flutter/user/edit-user.dart';
import 'dart:convert';
import 'drone/drone.dart';
import 'project/edit-project.dart';
import 'recommendations.dart';
import 'project/create-project.dart';
import 'project/details-project.dart';
import 'package:projeto_final_flutter/user/login.dart';

// Main Page after login - Inspections page

class InspectionsPage extends StatefulWidget {
  @override
  InspectionsPageState createState() => InspectionsPageState();
}

class InspectionsPageState extends State<InspectionsPage> {
  // Access the User class
  User user = User.userInstance;
  // List to store inspection data
  List<dynamic> inspections = [];
  // Index for the selected tab
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // fetch inspections when the widget initialzes
    fetchInspections();
  }

  // function to fetch inspections
  Future<void> fetchInspections() async {
    String userId = user.id;
    String url = 'http://10.0.2.2:3000/inspection/all/$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON and update the state with inspection data
      List<dynamic> data = json.decode(response.body)['inspections'];
      setState(() {
        inspections = data;
      });
    } else {
      // error
      throw Exception('Failed to load inspections');
    }
  }

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // If Projetos tab is clicked, fetch inspections again
        fetchInspections();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // email to populate in drawerHeader
    String userEmail = user.email;

    // list of pages corresponding to each tab
    List<Widget> _pages = [
      buildInspectionsList(),
      DronesPage(),
      RecommendationsPage(),
    ];

    // List of titles for each tab (change title of the page)
    List<String> _titles = [
      'Os meus Projetos',
      'Drones',
      'Recomendações',
    ];

    // drawerHeader
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
                    backgroundImage: AssetImage('assets/user_profile.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'João',
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
              title: const Text('Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditUserPage()),
                );
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
              },
            ),
          ],
        ),
      ),
      // BottomNavigationBar
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

  // function to delete an inspection
  Future<void> deleteInspection(String inspectionId) async {
    String url = 'http://10.0.2.2:3000/inspection/$inspectionId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      // Remove the deleted inspection from the list and update the state
      setState(() {
        inspections.removeWhere((inspection) => inspection['id'].toString() == inspectionId);
      });
    } else {
      throw Exception('Failed to delete inspection');
    }
  }

  // widget to build the list of inspections
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
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // go to inspection details after card is pressed,  it takes its id
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
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        inspectionName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'Editar') {
                            // navigates to inspection edit page, when 3 point buton is click
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditInspectionPage(inspectionId: inspectionId)),
                            );
                          } else if (result == 'Apagar') {
                            // delete function
                            deleteInspection(inspectionId);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Editar',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Apagar',
                            child: Text('Apagar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

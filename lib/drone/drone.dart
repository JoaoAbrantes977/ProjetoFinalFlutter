import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drone-details.dart';
import 'new-drone.dart';

class DronesPage extends StatefulWidget {
  @override
  _DronesPageState createState() => _DronesPageState();
}

class _DronesPageState extends State<DronesPage> {
  Future<List<Map<String, dynamic>>> fetchDrones() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/drone/'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> drones =
      List<Map<String, dynamic>>.from(body);
      return drones;
    } else {
      throw Exception('Failed to load drones');
    }
  }

  Future<void> deleteDrone(String id) async {
    final response =
    await http.delete(Uri.parse('http://10.0.2.2:3000/drone/$id'));

    if (response.statusCode == 200) {
      setState(() {

      });
    } else {
      throw Exception('Falha ao apagar drones');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewDronePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDrones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No drones available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> drone = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DroneDetailsPage(drone: drone),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(drone['gama']),
                        subtitle:
                        Text('Propulsão: ${drone['propulsao']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar"),
                                  content: const Text(
                                      "Apagar Drone?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Apagar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteDrone(drone['id'].toString())
                                            .then((_) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                              Text('Drone apagado'),
                                            ),
                                          );
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Falha ao apagar drone'),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

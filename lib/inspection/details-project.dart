import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_final_flutter/inspection/plano-voo.dart';
import 'dart:convert';

class InspectionDetailsPage extends StatefulWidget {
  final String inspectionId; // Pass inspection ID to the details page

  const InspectionDetailsPage({Key? key, required this.inspectionId})
      : super(key: key);

  @override
  _InspectionDetailsPageState createState() => _InspectionDetailsPageState();
}

class _InspectionDetailsPageState extends State<InspectionDetailsPage> {
  Map<String, dynamic>? inspectionDetails; // To store inspection details
  int _currentIndex = 0; // To keep track of the selected tab

  @override
  void initState() {
    super.initState();
    fetchInspectionDetails(); // Fetch inspection details when the page initializes
  }

  // Function to fetch inspection details
  Future<void> fetchInspectionDetails() async {
    String url =
        'http://10.0.2.2:3000/inspection/${widget.inspectionId}'; // Replace with your API endpoint
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON and update the state
      setState(() {
        inspectionDetails = json.decode(response.body);
      });
    } else {
      // If the server did not return a 200 OK response, throw an error.
      throw Exception('Failed to load inspection details');
    }
  }

  // Function to build the content based on the selected tab
  Widget _buildContent() {
    if (_currentIndex == 0) {
      return inspectionDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailCard(
                      'Nome do Projeto:', inspectionDetails!['tipo']['nome']),
                  _buildDetailCard(
                      'Descrição:', inspectionDetails!['tipo']['descricao']),
                  _buildDetailCard(
                      'Tipologia:', inspectionDetails!['tipo']['tipologia']),
                  _buildDetailCard(
                      'Área:', inspectionDetails!['tipo']['area'].toString()),
                  _buildDetailCard('Altura:',
                      inspectionDetails!['tipo']['altura'].toString()),
                  _buildDetailCard(
                      'Data Útil:', inspectionDetails!['tipo']['data_util']),
                  _buildDetailCard('Período:',
                      inspectionDetails!['tipo']['periodo'].toString()),
                  _buildDetailCard('Funcionamento:',
                      inspectionDetails!['tipo']['funcionamento']),
                  _buildDetailCard(
                      'Utilização:', inspectionDetails!['tipo']['utilizacao']),
                  _buildDetailCard('Número de Fachadas:',
                      inspectionDetails!['tipo']['num_fachadas'].toString()),
                  _buildDetailCard('Número de Coberturas:',
                      inspectionDetails!['tipo']['num_coberturas'].toString()),
                  _buildDetailCard('Pré-Esforço:',
                      inspectionDetails!['tipo']['pre_esforco']),
                  _buildDetailCard('Kilômetro Inicial:',
                      inspectionDetails!['tipo']['km_inicio'].toString()),
                  _buildDetailCard('Kilômetro Final:',
                      inspectionDetails!['tipo']['km_fim'].toString()),
                  _buildDetailCard('Material Estrutural:',
                      inspectionDetails!['tipo']['material_estrutural']),
                  _buildDetailCard(
                      'Extensão do Tabuleiro:',
                      inspectionDetails!['tipo']['extensao_tabuleiro']
                          .toString()),
                  _buildDetailCard('Vias de Circulação:',
                      inspectionDetails!['tipo']['vias_circulacao'].toString()),
                  _buildDetailCard('Material do Pavimento:',
                      inspectionDetails!['tipo']['material_pavi']),
                  _buildDetailCard('Sistema de Drenagem:',
                      inspectionDetails!['tipo']['sistema_drenagem']),
                  _buildDetailCard('Número de Pilares:',
                      inspectionDetails!['tipo']['num_pilares'].toString()),
                  _buildDetailCard('Geometria:',
                      inspectionDetails!['tipo']['geometria'].toString()),
                  _buildDetailCard('Material de Revestimento:',
                      inspectionDetails!['tipo']['material_revestimento']),
                ],
              ),
            );
    } else {
      // Placeholder for the "Inspections" tab
      return const Center(child: Text('Inspections content goes here'));
    }
  }

  // Function to build a detail card
  Widget _buildDetailCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Projeto'),
      ),
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Detalhes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Inspeções',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanoDeVooPage(inspectionId: widget.inspectionId),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Nova Inspeção'),
            )
          : null,
    );
  }
}
// para um determinado utilizador quero saber o numero de inspeçoes esse numero
// depois por cada um cria um retangulo, dentro do retangulo tenho uma top bar com o
// plano_voo, pos_voo e process_voo, onde o id da inspeçao esta nesse plano_de voo e depois
// os restantes inner joins com as outras tabelas
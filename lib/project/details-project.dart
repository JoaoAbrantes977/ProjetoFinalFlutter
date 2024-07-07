import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import '../inspection/all-inspections.dart';
import '../user/login.dart';

// Access the User class
User user = User.userInstance;
String userEmail = user.email;
String userId = user.id;

class InspectionDetailsPage extends StatefulWidget {
  final String inspectionId;

  const InspectionDetailsPage({Key? key, required this.inspectionId}) : super(key: key);

  @override
  _InspectionDetailsPageState createState() => _InspectionDetailsPageState();
}

class _InspectionDetailsPageState extends State<InspectionDetailsPage> {
  Map<String, dynamic>? inspectionDetails; // save inspection details
  List<dynamic>? userInspections; // save inspections by user
  int _currentIndex = 0; // which tab is selected

  @override
  void initState() {
    super.initState();
    fetchInspectionDetails(); // Fetch inspection details when the page initializes
    fetchUserInspections(); // Fetch user inspections when the page initializes
  }

  // fecth inspection details by id
  Future<void> fetchInspectionDetails() async {
    String url = 'http://10.0.2.2:3000/inspection/${widget.inspectionId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        inspectionDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load inspection details');
    }
  }

  // user inspections
  Future<void> fetchUserInspections() async {
    String url = 'http://10.0.2.2:3000/inspection/user/$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        userInspections = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load user inspections');
    }
  }


// Fetch for download report
  Future<void> downloadPdfReport(BuildContext context, int inspectionId) async {
    String url = 'http://10.0.2.2:3000/report/pre-inspecao/$inspectionId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('filePath')) {
          final filePath = jsonResponse['filePath'];
          final pdfUrl = 'http://10.0.2.2:3000/$filePath';

          final responsePdf = await http.get(Uri.parse(pdfUrl));
          if (responsePdf.statusCode == 200) {
            final bytes = responsePdf.bodyBytes;
            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/inspection_$inspectionId.pdf');
            await file.writeAsBytes(bytes);

            // Snackbar se o download for bem sucedido
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF downloaded to ${file.path}')),
            );
          } else {
            throw Exception('Failed to download PDF');
          }
        } else {
          throw Exception('PDF generation response missing filePath');
        }
      } else {
        throw Exception('Failed to generate PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during PDF download: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


// function based on the select tab
  Widget _buildContent() {
    if (_currentIndex == 0) {
      return inspectionDetails == null
          ? const Center(child: CircularProgressIndicator())
          : _buildDetailsContent();
    } else if (_currentIndex == 1) {
      return userInspections == null
          ? const Center(child: CircularProgressIndicator())
          : _buildInspectionsContent();
    } else if (_currentIndex == 2) {
      // generate report
      return Center(
        child: ElevatedButton(
          onPressed: () {
            if (userInspections != null && userInspections!.isNotEmpty) {
              final inspectionId = userInspections![0]['id'];
              downloadPdfReport(context, inspectionId);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Detalhes de inspeção não disponíveis')),
              );
            }
          },
          child: const Text('Gerar Relatorio'),
        ),
      );
    } else {
      return const SizedBox();
    }
  }




  // Function to build inspection details content
  Widget _buildDetailsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDetailCard('Nome do Projeto:', inspectionDetails!['tipo']['nome']),
          _buildDetailCard('Descrição:', inspectionDetails!['tipo']['descricao']),
          _buildDetailCard('Tipologia:', inspectionDetails!['tipo']['tipologia']),
          _buildDetailCard('Área:', inspectionDetails!['tipo']['area'].toString()),
          _buildDetailCard('Altura:', inspectionDetails!['tipo']['altura'].toString()),
          _buildDetailCard('Data Útil:', inspectionDetails!['tipo']['data_util']),
          _buildDetailCard('Período:', inspectionDetails!['tipo']['periodo'].toString()),
          _buildDetailCard('Funcionamento:', inspectionDetails!['tipo']['funcionamento']),
          _buildDetailCard('Utilização:', inspectionDetails!['tipo']['utilizacao']),
          _buildDetailCard('Número de Fachadas:', inspectionDetails!['tipo']['num_fachadas'].toString()),
          _buildDetailCard('Número de Coberturas:', inspectionDetails!['tipo']['num_coberturas'].toString()),
          _buildDetailCard('Pré-Esforço:', inspectionDetails!['tipo']['pre_esforco']),
          _buildDetailCard('Kilômetro Inicial:', inspectionDetails!['tipo']['km_inicio'].toString()),
          _buildDetailCard('Kilômetro Final:', inspectionDetails!['tipo']['km_fim'].toString()),
          _buildDetailCard('Material Estrutural:', inspectionDetails!['tipo']['material_estrutural']),
          _buildDetailCard('Extensão do Tabuleiro:', inspectionDetails!['tipo']['extensao_tabuleiro'].toString()),
          _buildDetailCard('Vias de Circulação:', inspectionDetails!['tipo']['vias_circulacao'].toString()),
          _buildDetailCard('Material do Pavimento:', inspectionDetails!['tipo']['material_pavi']),
          _buildDetailCard('Sistema de Drenagem:', inspectionDetails!['tipo']['sistema_drenagem']),
          _buildDetailCard('Número de Pilares:', inspectionDetails!['tipo']['num_pilares'].toString()),
          _buildDetailCard('Geometria:', inspectionDetails!['tipo']['geometria'].toString()),
          _buildDetailCard('Material de Revestimento:', inspectionDetails!['tipo']['material_revestimento']),
        ],
      ),
    );
  }

  // Function to build user inspections content
  Widget _buildInspectionsContent() {
    return ListView.builder(
      itemCount: userInspections!.length,
      itemBuilder: (context, index) {
        final inspection = userInspections![index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Inspeção ${inspection['id']}'),
            subtitle: Text('Data: ${inspection['createdOn']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllInspectionsPage(inspectionId: inspection['id'].toString()),
                ),
              );
            },
          ),
        );
      },
    );
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

  // Scafoold - BottomNavigationBar with tabs
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
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Gerar Relatório',
          ),
        ],
      ),
    );
  }
}

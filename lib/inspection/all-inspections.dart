import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:projeto_final_flutter/inspection/plano-voo.dart';
import 'package:open_file/open_file.dart';

class AllInspectionsPage extends StatefulWidget {
  final String inspectionId;

  const AllInspectionsPage({Key? key, required this.inspectionId}) : super(key: key);

  @override
  _AllInspectionsPageState createState() => _AllInspectionsPageState();
}

class _AllInspectionsPageState extends State<AllInspectionsPage> {
  int _selectedIndex = 0;
  int? _planoVooId;
  late String _inspectionId; // Hold the inspection ID
  int? _infoIdFromPosVoo; // Hold the info ID received from PosVooPage

  @override
  void initState() {
    super.initState();
    _inspectionId = widget.inspectionId; // Initialize inspection ID
  }

  // Function to build content for each tab
  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return PlanoDeVooInspectionPage(
          inspectionId: _inspectionId,
          onPlanoVooIdChanged: (id) {
            setState(() {
              _planoVooId = id; // Update plano_voo ID when fetched
            });
          },
        );
      case 1:
        if (_planoVooId == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return FutureBuilder(
            future: fetchPosVooEntries(_planoVooId!),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data found'));
              } else {
                List<Map<String, dynamic>> posVooEntries = snapshot.data!['posVooEntries'];
                int id = snapshot.data!['id']; // Extracted ID from response
                _infoIdFromPosVoo = id; // Save the info ID received
                return PosVooPage(
                  inspectionId: _inspectionId,
                  planoVooId: _planoVooId!,
                  posVooEntries: posVooEntries,
                  infoId: id, // Pass ID to PosVooPage
                );
              }
            },
          );
        }
      case 2:
        return InfoPage(inspectionId: _inspectionId, infoIdFromPosVoo: _infoIdFromPosVoo);
      default:
        return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Inspeção'),
      ),
      body: _buildTabContent(_selectedIndex),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlanoDeVooPage(inspectionId: _inspectionId)),
          );
        },
        label: Text('Nova Inspeção'),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.flight_takeoff),
            label: 'Plano Voo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight_land),
            label: 'Pos Voo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<Map<String, dynamic>> fetchPosVooEntries(int planoVooId) async {
    String url = 'http://10.0.2.2:3000/afterFlight/$planoVooId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> posVooEntries = data.cast<Map<String, dynamic>>();
      int id = data.first['id']; // Assuming ID is present in the first entry of data
      return {'posVooEntries': posVooEntries, 'id': id};
    } else {
      throw Exception('Failed to load pos_voo entries');
    }
  }
}

class PlanoDeVooInspectionPage extends StatefulWidget {
  final String inspectionId;
  final void Function(int) onPlanoVooIdChanged;

  const PlanoDeVooInspectionPage({Key? key, required this.inspectionId, required this.onPlanoVooIdChanged}) : super(key: key);

  @override
  _PlanoDeVooInspectionPageState createState() => _PlanoDeVooInspectionPageState();
}

class _PlanoDeVooInspectionPageState extends State<PlanoDeVooInspectionPage> {
  Map<String, dynamic>? flightPlan;

  @override
  void initState() {
    super.initState();
    fetchFlightPlan();
  }

  Future<void> fetchFlightPlan() async {
    String url = 'http://10.0.2.2:3000/flightPlan/${widget.inspectionId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        flightPlan = json.decode(response.body);
        widget.onPlanoVooIdChanged(flightPlan!['id']); // Notify parent with plano_voo ID
      });
    } else {
      throw Exception('Failed to load flight plan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return flightPlan == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDetailCard('Distância Objecto:', flightPlan!['distancia_objecto'].toString()),
          _buildDetailCard('OSD:', flightPlan!['osd'].toString()),
          _buildDetailCard('Área de Mapeamento:', flightPlan!['area_mapeamento'].toString()),
          _buildDetailCard('Taxa de Sobreposição:', flightPlan!['taxa_sobrepos'].toString()),
          _buildDetailCard('Intervalo de Foto:', flightPlan!['intervalo_foto'].toString()),
          _buildDetailCard('Tipo de Voo:', flightPlan!['tipo_voo']),
          _buildImageCard('Linha de Voo:', flightPlan!['linha_voo']),
        ],
      ),
    );
  }

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

  Widget _buildImageCard(String title, String imagePath) {
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
            Image.file(File(imagePath)), // Display image from local file path
          ],
        ),
      ),
    );
  }
}

class PosVooPage extends StatelessWidget {
  final String inspectionId;
  final int planoVooId; // Receive plano_voo ID
  final List<Map<String, dynamic>> posVooEntries; // Hold pos_voo entries
  final int infoId; // Hold info ID

  const PosVooPage({Key? key, required this.inspectionId, required this.planoVooId, required this.posVooEntries, required this.infoId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posVooEntries.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> entry = posVooEntries[index];
        return _buildDetailCard(entry);
      },
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> entry) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            _buildDetailRow('Números de Voos:', entry['num_voos'].toString()),
            _buildDetailRow('Data de Início:', entry['hora_inicio']),
            _buildDetailRow('Data de Fim:', entry['hora_fim']),
            _buildDetailRow('Tempo Total:', entry['tempo_total']),
            _buildDetailRow('Número de Fotos:', entry['num_fotos'].toString()),
            _buildDetailRow('Número de Vídeos:', entry['num_videos'].toString()),
            _buildDetailRow('Data de Inspeção:', entry['createdOn']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class InfoPage extends StatefulWidget {
  final String inspectionId;
  final int? infoIdFromPosVoo; // Info ID received from PosVooPage

  const InfoPage({Key? key, required this.inspectionId, required this.infoIdFromPosVoo}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late Future<List<Map<String, dynamic>>> _processInfoFuture;

  @override
  void initState() {
    super.initState();
    _processInfoFuture = fetchProcessInfo(widget.infoIdFromPosVoo!);
  }

  Future<List<Map<String, dynamic>>> fetchProcessInfo(int idPos) async {
    String url = 'http://10.0.2.2:3000/processInfo/$idPos';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> processInfoEntries = data.cast<Map<String, dynamic>>();
      return processInfoEntries;
    } else {
      throw Exception('Failed to load process_info entries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _processInfoFuture,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No process_info entries found'));
          } else {
            List<Map<String, dynamic>> processInfoEntries = snapshot.data!;
            return ListView.builder(
              itemCount: processInfoEntries.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> entry = processInfoEntries[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0) _buildGenerateReportButton(), // Add the button before the first entry
                    _buildProcessInfoCards(entry),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildGenerateReportButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _generateReport,
          child: const Text('Gerar Relatório'),
        ),
      ),
    );
  }

  void _generateReport() async {
    String url = 'http://10.0.2.2:3000/report/pos-inspecao/${widget.inspectionId}';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Obter o diretório de downloads
        final directory = await getExternalStorageDirectory();
        String filePath = '${directory!.path}/report.pdf';

        // Escrever o conteúdo do arquivo no diretório de downloads
        File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(response.bodyBytes);

        // Exibir um SnackBar indicando que o download foi concluído com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report download with sucess at ${directory.path}/report.pdf'),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Abrir',
              onPressed: () {
                // Abrir o arquivo PDF com o visualizador padrão
                OpenFile.open(filePath);
              },
            ),
          ),
        );
      } else {
        throw Exception('Falha ao baixar o relatório');
      }
    } catch (e) {
      // Exibir um SnackBar indicando que ocorreu um erro durante o download
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao baixar o relatório: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  Widget _buildProcessInfoCards(Map<String, dynamic> entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard('Número de Anomalias:', entry['num_anomalias'].toString()),
        _buildDetailCard('Foto:', entry['foto']),
        _buildDetailCard('Descrição:', entry['descricao']),
        _buildDetailCard('Causas:', entry['causas']),
        _buildDetailCard('Reparação:', entry['reparacao']),
        _buildDetailCard('Data de Criação:', entry['createdOn']),
        _buildDetailCard('Data de Atualização:', entry['updatedOn']),
        SizedBox(height: 16), // spacing between cards
      ],
    );
  }

  Widget _buildDetailCard(String title, dynamic value) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (title == 'Foto:')
              Image.file(
                value != null ? File(value) : File(''), // Assuming value is a file path
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Text(
                value.toString(),
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
          ],
        ),
      ),
    );
  }
}


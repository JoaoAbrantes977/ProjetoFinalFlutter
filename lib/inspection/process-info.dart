import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../projects.dart';

class ProcessInfoPage extends StatefulWidget {
  final int afterFlightId;

  ProcessInfoPage({required this.afterFlightId});

  @override
  _ProcessInfoPageState createState() => _ProcessInfoPageState();
}

class _ProcessInfoPageState extends State<ProcessInfoPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registar Anomalias'),
      ),
      body: _selectedIndex == 0
          ? AddAnomalyTab(afterFlightId: widget.afterFlightId)
          : AnomaliesListTab(afterFlightId: widget.afterFlightId),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Adicionar Anomalia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista das Anomalias',
          ),
        ],
      ),
    );
  }
}

class AddAnomalyTab extends StatefulWidget {
  final int afterFlightId;

  AddAnomalyTab({required this.afterFlightId});

  @override
  _AddAnomalyTabState createState() => _AddAnomalyTabState();
}

class _AddAnomalyTabState extends State<AddAnomalyTab> {
  final TextEditingController numAnomAliasController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController causasController = TextEditingController();
  final TextEditingController reparacaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imagePath = pickedFile.path;
      } else {
        print('Imagem não foi selecionada');
      }
    });
  }

  Future<void> _submitForm(int afterFlightId) async {
    if (_formKey.currentState!.validate()) {
      final numAnomAlias = int.tryParse(numAnomAliasController.text) ?? 0;
      final descricao = descricaoController.text;
      final causas = causasController.text;
      final reparacao = reparacaoController.text;
      final foto = _imagePath ?? '';

      final url = Uri.parse('http://10.0.2.2:3000/processInfo/create');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'num_anomalias': numAnomAlias,
          'foto': foto,
          'descricao': descricao,
          'causas': causas,
          'reparacao': reparacao,
          'id_pos': afterFlightId,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, show success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anomalia inserida com sucesso'),
            backgroundColor: Colors.green,
          ),
        );

        // Optionally, you can reset the form and image state here
        _formKey.currentState!.reset();
        numAnomAliasController.clear();
        descricaoController.clear();
        causasController.clear();
        reparacaoController.clear();
        setState(() {
          _image = null;
          _imagePath = null;
        });
      } else {
        // If the server returns an error response, show error Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao inserir anomalia. Status: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        print('Failed to submit form: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Add Picture'),
            ),
            if (_image != null) ...[
              SizedBox(height: 10),
              Image.file(
                _image!,
                height: 200,
              ),
            ],
            SizedBox(height: 20),
            _buildTextField(
              controller: numAnomAliasController,
              labelText: 'Número de Anomalias',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o número de anomalias';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: descricaoController,
              labelText: 'Descrição',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a descrição';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: causasController,
              labelText: 'Causas',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira as causas';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: reparacaoController,
              labelText: 'Reparação',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a reparação';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _submitForm(widget.afterFlightId);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Submeter'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InspectionsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Terminar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: validator,
    );
  }
}

class AnomaliesListTab extends StatefulWidget {
  final int afterFlightId;

  AnomaliesListTab({required this.afterFlightId});

  @override
  _AnomaliesListTabState createState() => _AnomaliesListTabState();
}

class _AnomaliesListTabState extends State<AnomaliesListTab> {
  List<dynamic> anomalies = [];

  @override
  void initState() {
    super.initState();
    fetchAnomalies();
  }

  Future<void> fetchAnomalies() async {
    final url = Uri.parse('http://10.0.2.2:3000/processInfo/${widget.afterFlightId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        anomalies = jsonDecode(response.body);
      });
    } else {
      print('Erra ao obter anomalias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: anomalies.length,
      itemBuilder: (context, index) {
        final anomaly = anomalies[index];
        return ListTile(
          title: Text('Anomalia ${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descrição: ${anomaly['descricao']}'),
              Text('Causas: ${anomaly['causas']}'),
              Text('Reparação: ${anomaly['reparacao']}'),
              if (anomaly['foto'] != null)
                _buildImageWidget(anomaly['foto']),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(String foto) {
    if (foto.startsWith('http')) {
      // If foto is a URL, use Image.network
      return Image.network(foto);
    } else {
      // Otherwise, assume foto is a local file path, use Image.file
      return Image.file(File(foto));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditInspectionPage extends StatefulWidget {
  final String inspectionId;

  EditInspectionPage({required this.inspectionId});

  @override
  _EditInspectionPageState createState() => _EditInspectionPageState();
}

class _EditInspectionPageState extends State<EditInspectionPage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> inspectionData = {};
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    fetchInspectionDetails();
  }

  @override
  void dispose() {
    // dispose text editing controllers to avoid memory leaks and other probelms
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  // Function to fetch inspection details
  Future<void> fetchInspectionDetails() async {
    String url = 'http://10.0.2.2:3000/inspection/${widget.inspectionId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      setState(() {
        inspectionData = data['tipo'];
        controllers = {
          'nome': TextEditingController(text: inspectionData['nome']),
          'descricao': TextEditingController(text: inspectionData['descricao']),
          'tipologia': TextEditingController(text: inspectionData['tipologia']),
          'area': TextEditingController(text: inspectionData['area']?.toString()),
          'altura': TextEditingController(text: inspectionData['altura']?.toString()),
          'data_util': TextEditingController(text: inspectionData['data_util']),
          'periodo': TextEditingController(text: inspectionData['periodo']?.toString()),
          'funcionamento': TextEditingController(text: inspectionData['funcionamento']),
          'utilizacao': TextEditingController(text: inspectionData['utilizacao']),
          'num_fachadas': TextEditingController(text: inspectionData['num_fachadas']?.toString()),
          'num_coberturas': TextEditingController(text: inspectionData['num_coberturas']?.toString()),
          'pre_esforco': TextEditingController(text: inspectionData['pre_esforco']),
          'km_inicio': TextEditingController(text: inspectionData['km_inicio']?.toString()),
          'km_fim': TextEditingController(text: inspectionData['km_fim']?.toString()),
          'material_estrutural': TextEditingController(text: inspectionData['material_estrutural']),
          'extensao_tabuleiro': TextEditingController(text: inspectionData['extensao_tabuleiro']?.toString()),
          'largura_tabuleiro': TextEditingController(text: inspectionData['largura_tabuleiro']?.toString()),
          'vias_circulacao': TextEditingController(text: inspectionData['vias_circulacao']?.toString()),
          'material_pavi': TextEditingController(text: inspectionData['material_pavi']),
          'sistema_drenagem': TextEditingController(text: inspectionData['sistema_drenagem']),
          'num_pilares': TextEditingController(text: inspectionData['num_pilares']?.toString()),
          'geometria': TextEditingController(text: inspectionData['geometria']?.toString()),
          'material_revestimento': TextEditingController(text: inspectionData['material_revestimento']),
        };
      });
    } else {
      throw Exception('Failed to load inspection details');
    }
  }

  // Function to update inspection details
  Future<void> updateInspection() async {
    String url = 'http://10.0.2.2:3000/inspection/${widget.inspectionId}';

    // Remove 'id' from inspectionData if present
    inspectionData.remove('id');

    // Extract updated values from text editing controllers
    controllers.forEach((key, controller) {
      inspectionData[key] = controller.text;
    });

    print('Data sent to PATCH: ${jsonEncode(inspectionData)}');

    final response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(inspectionData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Projeto editado com sucesso'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      // If the server did not return a 200 OK response, throw an error.
      throw Exception('Erro ao atualizar projeto');
    }
  }

  // edit project form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Projeto'),
      ),
      body: inspectionData.isEmpty || controllers == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              buildTextField('Nome', 'nome'),
              buildTextField('Descrição', 'descricao'),
              buildTextField('Tipologia', 'tipologia'),
              buildNumberField('Área', 'area'),
              buildNumberField('Altura', 'altura'),
              buildDateField('Data Util', 'data_util'),
              buildNumberField('Período', 'periodo'),
              buildTextField('Funcionamento', 'funcionamento'),
              buildTextField('Utilização', 'utilizacao'),
              buildNumberField('Num Fachadas', 'num_fachadas'),
              buildNumberField('Num Coberturas', 'num_coberturas'),
              buildTextField('Pré Esforço', 'pre_esforco'),
              buildNumberField('KM Início', 'km_inicio'),
              buildNumberField('KM Fim', 'km_fim'),
              buildTextField('Material Estrutural', 'material_estrutural'),
              buildNumberField('Extensão Tabuleiro', 'extensao_tabuleiro'),
              buildNumberField('Largura Tabuleiro', 'largura_tabuleiro'),
              buildNumberField('Vias Circulação', 'vias_circulacao'),
              buildTextField('Material Pavimento', 'material_pavi'),
              buildTextField('Sistema Drenagem', 'sistema_drenagem'),
              buildNumberField('Num Pilares', 'num_pilares'),
              buildNumberField('Geometria', 'geometria'),
              buildTextField('Material Revestimento', 'material_revestimento'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    updateInspection();
                  }
                },
                child: Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // widget style form, and check empty fields
  Widget buildTextField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(color: Colors.blue),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Introduza $label';
          }
          return null;
        },
        onSaved: (value) {
          inspectionData[key] = value!;
        },
      ),
    );
  }

  // widget style form, and check empty fields
  Widget buildNumberField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(color: Colors.blue),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Introduza $label';
          }
          return null;
        },
        onSaved: (value) {
          inspectionData[key] = double.parse(value!);
        },
      ),
    );
  }

  // widget style form, and check empty fields
  Widget buildDateField(String label, String key) {
    TextEditingController _dateController = TextEditingController(text: inspectionData[key]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(color: Colors.blue),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) {
          inspectionData[key] = value!;
        },
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.parse(inspectionData[key]),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            _dateController.text = pickedDate.toIso8601String().split('T').first;
            inspectionData[key] = _dateController.text;
          }
        },
      ),
    );
  }
}

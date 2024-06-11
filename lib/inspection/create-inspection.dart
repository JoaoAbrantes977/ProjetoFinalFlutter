import 'package:flutter/material.dart';

class CreateInspectionPage extends StatefulWidget {
  @override
  _CreateInspectionPageState createState() => _CreateInspectionPageState();
}

class _CreateInspectionPageState extends State<CreateInspectionPage> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _tipologiaController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _dataUtilController = TextEditingController();
  final TextEditingController _periodoController = TextEditingController();
  final TextEditingController _utilizacaoController = TextEditingController();
  final TextEditingController _numFachadasController = TextEditingController();
  final TextEditingController _numCoberturasController = TextEditingController();
  final TextEditingController _kmInicioController = TextEditingController();
  final TextEditingController _kmFimController = TextEditingController();
  final TextEditingController _materialEstruturalController = TextEditingController();
  final TextEditingController _extensaoTabuleiroController = TextEditingController();
  final TextEditingController _larguraTabuleiroController = TextEditingController();
  final TextEditingController _viasCirculacaoController = TextEditingController();
  final TextEditingController _materialPaviController = TextEditingController();
  final TextEditingController _numPilaresController = TextEditingController();
  final TextEditingController _geometriaController = TextEditingController();
  final TextEditingController _materialRevestimentoController = TextEditingController();
  final TextEditingController _idPaisController = TextEditingController();

  // Define variables for dropdown menus
  String _funcionamentoValue = 'Sim';
  String _preEsforcoValue = 'Sim';
  String _sistemaDrenagemValue = 'Sim';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _tipologiaController,
              decoration: InputDecoration(labelText: 'Tipologia'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(labelText: 'Área'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _alturaController,
              decoration: InputDecoration(labelText: 'Altura'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _dataUtilController,
              decoration: InputDecoration(labelText: 'Data Útil'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _periodoController,
              decoration: InputDecoration(labelText: 'Período'),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(labelText: 'Funcionamento'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _funcionamentoValue,
                  onChanged: (newValue) {
                    setState(() {
                      _funcionamentoValue = newValue!;
                    });
                  },
                  items: <String>['Sim', 'Não'].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _utilizacaoController,
              decoration: InputDecoration(labelText: 'Utilização'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _numFachadasController,
              decoration: InputDecoration(labelText: 'Número de Fachadas'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _numCoberturasController,
              decoration: InputDecoration(labelText: 'Número de Coberturas'),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(labelText: 'Pré-Esforço'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _preEsforcoValue,
                  onChanged: (newValue) {
                    setState(() {
                      _preEsforcoValue = newValue!;
                    });
                  },
                  items: <String>['Sim', 'Não'].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _kmInicioController,
              decoration: InputDecoration(labelText: 'Km Início'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _kmFimController,
              decoration: InputDecoration(labelText: 'Km Fim'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _materialEstruturalController,
              decoration: InputDecoration(labelText: 'Material Estrutural'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _extensaoTabuleiroController,
              decoration: InputDecoration(labelText: 'Extensão Tabuleiro'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _larguraTabuleiroController,
              decoration: InputDecoration(labelText: 'Largura Tabuleiro'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _viasCirculacaoController,
              decoration: InputDecoration(labelText: 'Vias Circulação'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _materialPaviController,
              decoration: InputDecoration(labelText: 'Material Pavimentação'),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(labelText: 'Sistema de Drenagem'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _sistemaDrenagemValue,
                  onChanged: (newValue) {
                    setState(() {
                      _sistemaDrenagemValue = newValue!;
                    });
                  },
                  items: <String>['Sim', 'Não'].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _numPilaresController,
              decoration: InputDecoration(labelText: 'Número de Pilares'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _geometriaController,
              decoration: InputDecoration(labelText: 'Geometria'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _materialRevestimentoController,
              decoration: InputDecoration(labelText: 'Material Revestimento'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _idPaisController,
              decoration: InputDecoration(labelText: 'ID Pais'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

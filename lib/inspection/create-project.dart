import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../user/login.dart'; // Adjust the import path as necessary

// Access the User class
User user = User.userInstance;
String userEmail = user.email;
String userId = user.id;

class CreateInspectionPage extends StatefulWidget {
  @override
  _CreateInspectionPageState createState() => _CreateInspectionPageState();
}

class _CreateInspectionPageState extends State<CreateInspectionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _tipologiaController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _dataUtilController = TextEditingController();
  final TextEditingController _periodoController = TextEditingController();
  final TextEditingController _utilizacaoController = TextEditingController();
  final TextEditingController _numFachadasController = TextEditingController();
  final TextEditingController _numCoberturasController =
      TextEditingController();
  final TextEditingController _kmInicioController = TextEditingController();
  final TextEditingController _kmFimController = TextEditingController();
  final TextEditingController _materialEstruturalController =
      TextEditingController();
  final TextEditingController _extensaoTabuleiroController =
      TextEditingController();
  final TextEditingController _larguraTabuleiroController =
      TextEditingController();
  final TextEditingController _viasCirculacaoController =
      TextEditingController();
  final TextEditingController _materialPaviController = TextEditingController();
  final TextEditingController _numPilaresController = TextEditingController();
  final TextEditingController _geometriaController = TextEditingController();
  final TextEditingController _materialRevestimentoController =
      TextEditingController();
  final TextEditingController _distritoController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _freguesiaController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  // Define variables for dropdown menus
  String _funcionamentoValue = 'Sim';
  String _preEsforcoValue = 'Sim';
  String _sistemaDrenagemValue = 'Sim';
  String _selectedCountry = 'Portugal';
  String _selectDistrito = "Castelo Branco";
  String _selectMunicipio = "Covilhã";
  String _selectFreguesia = "Covilhã";

  final List<String> _funcinamento = ['Sim', 'Não'];
  final List<String> _esforco = ['Sim', 'Não'];
  final List<String> _drenagem = ['Sim', 'Não'];
  final List<String> _countries = ['Portugal', 'Spain', 'France', 'UK', 'USA'];
  final List<String> _distrito = ['Castelo Branco', 'Lisboa', 'Porto'];
  final List<String> _municipio = ['Covilhã', 'Fundão', 'Belmonte'];
  final List<String> _freguesia = ['Dominguiso', 'Covilhã', 'Boidobra'];

  // FUNCAO PARA CRIAR NOVA INSPECAO
  Future<void> _register() async {
    if (_validateInputs()) {
      final nome = _nomeController.text;
      final descricao = _descricaoController.text;
      final tipologia = _tipologiaController.text;
      final area = int.tryParse(_areaController.text) ?? 0;
      final altura = int.tryParse(_alturaController.text) ?? 0;
      final data_util = _dataUtilController.text;
      final periodo = int.tryParse(_periodoController.text) ?? 0;
      final utilizacao = _utilizacaoController.text;
      final funcionamento = _funcionamentoValue;
      final num_fachadas = int.tryParse(_numFachadasController.text) ?? 0;
      final num_coberturas = int.tryParse(_numCoberturasController.text) ?? 0;
      final pre_esforco = _preEsforcoValue;
      final km_inicio = int.tryParse(_kmInicioController.text) ?? 0;
      final km_fim = int.tryParse(_kmFimController.text) ?? 0;
      final material_estrutural = _materialEstruturalController.text;
      final extensao_tabuleiro =
          int.tryParse(_extensaoTabuleiroController.text) ?? 0;
      final largura_tabuleiro =
          int.tryParse(_larguraTabuleiroController.text) ?? 0;
      final vias_circulacao = int.tryParse(_viasCirculacaoController.text) ?? 0;
      final material_pavimentacao = _materialPaviController.text;
      final num_pilares = int.tryParse(_numPilaresController.text) ?? 0;
      final geometria = int.tryParse(_geometriaController.text) ?? 0;
      final material_revestimento = _materialRevestimentoController.text;
      final sistema_drenagem = _sistemaDrenagemValue;
      final codigo_postal = _codigoController.text;
      final rua = _ruaController.text;

      final url = Uri.parse('http://10.0.2.2:3000/inspection/create');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "nome": nome,
          "descricao": descricao,
          "tipologia": tipologia,
          "area": area,
          "altura": altura,
          "data_util": data_util,
          "periodo": periodo,
          "funcionamento": funcionamento,
          "utilizacao": utilizacao,
          "num_fachadas": num_fachadas,
          "num_coberturas": num_coberturas,
          "pre_esforco": pre_esforco,
          "km_inicio": km_inicio,
          "km_fim": km_fim,
          "material_estrutural": material_estrutural,
          "extensao_tabuleiro": extensao_tabuleiro,
          "largura_tabuleiro": largura_tabuleiro,
          "vias_circulacao": vias_circulacao,
          "material_pavi": material_pavimentacao,
          "sistema_drenagem": sistema_drenagem,
          "num_pilares": num_pilares,
          "geometria": geometria,
          "material_revestimento": material_revestimento,
          'pais_nome': _selectedCountry,
          'distrito_nome': _selectDistrito,
          'municipio_nome': _selectMunicipio,
          'freguesia_nome': _selectFreguesia,
          'rua': rua,
          'codigo_postal': codigo_postal,
          "id_utilizador": userId
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inspeção Registada com sucesso"),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to the previous screen
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao Registar a Inspeção"),
            backgroundColor: Colors.red,
          ),
        );
        print('Registration failed: ${response.body}');
      }
    }
  }

  // VERIFICAR OS INPUTS
  // Validate Inputs
  bool _validateInputs() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Novo Projeto'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome da Obra',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _tipologiaController,
                    decoration: InputDecoration(
                      labelText: 'Tipologia',
                      hintText: 'ex: Ponte, Edificio, etc',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      // You can add email validation logic here if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _areaController,
                    decoration: InputDecoration(
                      labelText: 'Área (m²)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      // Additional validation logic can be added here
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _alturaController,
                    decoration: InputDecoration(
                      labelText: 'Altura (m)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      // Additional validation logic can be added here
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _dataUtilController,
                    decoration: InputDecoration(
                      labelText: 'Data de Utilização',
                      hintText: 'YYYY-MM-DD',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      // You can add date validation logic here if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _periodoController,
                    decoration: InputDecoration(
                      labelText: 'Período de Construção',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      // Additional validation logic can be added here
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _utilizacaoController,
                    decoration: InputDecoration(
                      labelText: 'Utilização Prevista',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _funcionamentoValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _funcionamentoValue = newValue!;
                      });
                    },
                    items: _funcinamento
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Funcionamento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _numFachadasController,
                    decoration: InputDecoration(
                      labelText: 'Número de Fachadas',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _numCoberturasController,
                    decoration: InputDecoration(
                      labelText: 'Número de Coberturas',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _preEsforcoValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _preEsforcoValue = newValue!;
                      });
                    },
                    items:
                        _esforco.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Pré-Esforço',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _kmInicioController,
                    decoration: InputDecoration(
                      labelText: 'Km Início',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _kmFimController,
                    decoration: InputDecoration(
                      labelText: 'Km Fim',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _materialEstruturalController,
                    decoration: InputDecoration(
                      labelText: 'Material Estrutural',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _extensaoTabuleiroController,
                    decoration: InputDecoration(
                      labelText: 'Extensão do Tabuleiro',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _larguraTabuleiroController,
                    decoration: InputDecoration(
                      labelText: 'Largura do Tabuleiro',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _viasCirculacaoController,
                    decoration: InputDecoration(
                      labelText: 'Vias de Circulação',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _materialPaviController,
                    decoration: InputDecoration(
                      labelText: 'Material de Pavimentação',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _numPilaresController,
                    decoration: InputDecoration(
                      labelText: 'Número de Pilares',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _geometriaController,
                    decoration: InputDecoration(
                      labelText: 'Geometria',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _materialRevestimentoController,
                    decoration: InputDecoration(
                      labelText: 'Material de Revestimento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _sistemaDrenagemValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _sistemaDrenagemValue = newValue!;
                      });
                    },
                    items:
                        _drenagem.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Sistema de Drenagem',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue!;
                      });
                    },
                    items: _countries
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'País',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectDistrito,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectDistrito = newValue!;
                      });
                    },
                    items:
                        _distrito.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Distrito',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectMunicipio,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectMunicipio = newValue!;
                      });
                    },
                    items: _municipio
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Município',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectFreguesia,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectFreguesia = newValue!;
                      });
                    },
                    items: _freguesia
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Freguesia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _codigoController,
                    decoration: InputDecoration(
                      labelText: 'Código Postal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ruaController,
                    decoration: InputDecoration(
                      labelText: 'Rua',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Criar Inspeção'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

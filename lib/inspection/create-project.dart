import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../user/login.dart';

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
      final extensao_tabuleiro = int.tryParse(_extensaoTabuleiroController.text) ?? 0;
      final largura_tabuleiro = int.tryParse(_larguraTabuleiroController.text) ?? 0;
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
        print('Registration successful');
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
                      labelText: 'Área',
                      hintText: 'Em m^2',
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
                    controller: _alturaController,
                    decoration: InputDecoration(
                      labelText: 'Altura',
                      hintText: 'Em metros',
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
                    controller: _dataUtilController,
                    decoration: InputDecoration(
                      labelText: 'Data Útil',
                      hintText: "No formato YYYY-MM-DD",
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
                    controller: _periodoController,
                    decoration: InputDecoration(
                      labelText: 'Périodo de Uso',
                      hintText: 'Numero de anos',
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
                    controller: _utilizacaoController,
                    decoration: InputDecoration(
                      labelText: 'Utilização',
                      hintText: 'Qual é a sua utilização',
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
                    decoration: InputDecoration(
                      labelText: 'Funcionamento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _funcinamento.map((String specialty) {
                      return DropdownMenuItem<String>(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _funcionamentoValue = newValue!;
                      });
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
                    decoration: InputDecoration(
                      labelText: 'Pré-Esforço',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _esforco.map((String specialty) {
                      return DropdownMenuItem<String>(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _preEsforcoValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _kmInicioController,
                    decoration: InputDecoration(
                      labelText: 'Km Inicio',
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
                    controller: _kmFimController,
                    decoration: InputDecoration(
                      labelText: 'Km Fim',
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
                      labelText: 'Extensão Tabuleiro',
                      hintText: 'Em metros',
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
                    controller: _larguraTabuleiroController,
                    decoration: InputDecoration(
                      labelText: 'Largura Tabuleiro',
                      hintText: 'Em metros',
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
                    controller: _viasCirculacaoController,
                    decoration: InputDecoration(
                      labelText: 'Vias Circulação',
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
                    controller: _materialPaviController,
                    decoration: InputDecoration(
                      labelText: 'Material Pavimentação',
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
                      labelText: 'Material Revestimento',
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
                    decoration: InputDecoration(
                      labelText: 'Sistema de Drenagem',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _drenagem.map((String specialty) {
                      return DropdownMenuItem<String>(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _sistemaDrenagemValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: InputDecoration(
                      labelText: 'País',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _countries.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectDistrito,
                    decoration: InputDecoration(
                      labelText: 'Distrito',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _distrito.map((String distrito) {
                      return DropdownMenuItem<String>(
                        value: distrito,
                        child: Text(distrito),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectDistrito = newValue!;
                      });
                      // Update the selected district in the controller
                      _distritoController.text = newValue!;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectMunicipio,
                    decoration: InputDecoration(
                      labelText: 'Municipio',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _municipio.map((String municipio) {
                      return DropdownMenuItem<String>(
                        value: municipio,
                        child: Text(municipio),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectMunicipio = newValue!;
                      });
                      // Update the selected municipality in the controller
                      _municipioController.text = newValue!;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectFreguesia,
                    decoration: InputDecoration(
                      labelText: 'Freguesia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _freguesia.map((String freguesia) {
                      return DropdownMenuItem<String>(
                        value: freguesia,
                        child: Text(freguesia),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectFreguesia = newValue!;
                      });
                      // Update the selected parish in the controller
                      _freguesiaController.text = newValue!;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ruaController,
                    decoration: InputDecoration(
                      labelText: 'Rua',
                      prefixIcon: const Icon(Icons.location_city),
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
                      prefixIcon: const Icon(Icons.markunread_mailbox),
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
                    child: const Text('Criar'),
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

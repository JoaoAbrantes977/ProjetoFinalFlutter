import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewDronePage extends StatefulWidget {
  @override
  _NewDronePageState createState() => _NewDronePageState();
}

class _NewDronePageState extends State<NewDronePage> {
  final _formKey = GlobalKey<FormState>();

  // Form field values
  String gama = '';
  String propulsao = '';
  int numRotores = 0;
  double peso = 0.0;
  double alcanceMax = 0.0;
  double altitudeMax = 0.0;
  String tempoVooMax = '';
  String tempoBateria = '';
  String velocidadeMax = '';
  String velocidadeSubida = '';
  String velocidadeDescida = '';
  String resistenciaVento = '';
  int temperatura = 0;
  String sistemaLocalizacao = '';
  String tipoCamera = '';
  int comprimentoImg = 0;
  int larguraImg = 0;
  int fov = 0;
  String resolucaoCam = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Drone'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Gama
              TextFormField(
                initialValue: gama,
                decoration: InputDecoration(labelText: 'Gama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a gama do drone';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    gama = value;
                  });
                },
              ),
              // Propulsão
              TextFormField(
                initialValue: propulsao,
                decoration: InputDecoration(labelText: 'Propulsão'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo de propulsão';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    propulsao = value;
                  });
                },
              ),
              // Número de Rotores
              TextFormField(
                initialValue: numRotores.toString(),
                decoration: InputDecoration(labelText: 'Número de Rotores'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de rotores';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    numRotores = int.tryParse(value) ?? 0;
                  });
                },
              ),
              // Peso
              TextFormField(
                initialValue: peso.toString(),
                decoration: InputDecoration(labelText: 'Peso (gramas)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o peso do drone';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    peso = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              // Alcance Máximo
              TextFormField(
                initialValue: alcanceMax.toString(),
                decoration: InputDecoration(labelText: 'Alcance Máximo (km)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o alcance máximo';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    alcanceMax = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              // Altitude Máxima
              TextFormField(
                initialValue: altitudeMax.toString(),
                decoration: InputDecoration(labelText: 'Altitude Máxima (metros)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a altitude máxima';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    altitudeMax = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              // Tempo de Voo Máximo
              TextFormField(
                initialValue: tempoVooMax,
                decoration: InputDecoration(labelText: 'Tempo de Voo Máximo (minutos)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tempo de voo máximo';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    tempoVooMax = value;
                  });
                },
              ),
              // Tempo de Bateria
              TextFormField(
                initialValue: tempoBateria,
                decoration: InputDecoration(labelText: 'Tempo de Bateria (minutos)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tempo de bateria';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    tempoBateria = value;
                  });
                },
              ),
              // Velocidade Máxima
              TextFormField(
                initialValue: velocidadeMax,
                decoration: InputDecoration(labelText: 'Velocidade Máxima'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a velocidade máxima';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    velocidadeMax = value;
                  });
                },
              ),
              // Velocidade de Subida
              TextFormField(
                initialValue: velocidadeSubida,
                decoration: InputDecoration(labelText: 'Velocidade de Subida (metros/s)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a velocidade de subida';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    velocidadeSubida = value;
                  });
                },
              ),
              // Velocidade de Descida
              TextFormField(
                initialValue: velocidadeDescida,
                decoration: InputDecoration(labelText: 'Velocidade de Descida (metros/s)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a velocidade de descida';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    velocidadeDescida = value;
                  });
                },
              ),
              // Resistência ao Vento
              TextFormField(
                initialValue: resistenciaVento,
                decoration: InputDecoration(labelText: 'Resistência ao Vento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a resistência ao vento';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    resistenciaVento = value;
                  });
                },
              ),
              // Temperatura
              TextFormField(
                initialValue: temperatura.toString(),
                decoration: InputDecoration(labelText: 'Temperatura (graus)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a temperatura';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    temperatura = int.tryParse(value) ?? 0;
                  });
                },
              ),
              // Sistema de Localização
              TextFormField(
                initialValue: sistemaLocalizacao,
                decoration: InputDecoration(labelText: 'Sistema de Localização'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o sistema de localização';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    sistemaLocalizacao = value;
                  });
                },
              ),
              // Tipo de Câmera
              TextFormField(
                initialValue: tipoCamera,
                decoration: InputDecoration(labelText: 'Tipo de Câmera'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo de câmera';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    tipoCamera = value;
                  });
                },
              ),
              // Comprimento da Imagem
              TextFormField(
                initialValue: comprimentoImg.toString(),
                decoration: InputDecoration(labelText: 'Comprimento da Imagem'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o comprimento da imagem';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    comprimentoImg = int.tryParse(value) ?? 0;
                  });
                },
              ),
              // Largura da Imagem
              TextFormField(
                initialValue: larguraImg.toString(),
                decoration: InputDecoration(labelText: 'Largura da Imagem'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a largura da imagem';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    larguraImg = int.tryParse(value) ?? 0;
                  });
                },
              ),
              // FOV
              TextFormField(
                initialValue: fov.toString(),
                decoration: InputDecoration(labelText: 'FOV'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o FOV';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    fov = int.tryParse(value) ?? 0;
                  });
                },
              ),
              // Resolução da Câmera
              TextFormField(
                initialValue: resolucaoCam,
                decoration: InputDecoration(labelText: 'Resolução da Câmera'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a resolução da câmera';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    resolucaoCam = value;
                  });
                },
              ),

              SizedBox(height: 20.0),

              // Botão para guardar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveDrone();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveDrone() async {
    final url = Uri.parse('http://10.0.2.2:3000/drone/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'gama': gama,
          'propulsao': propulsao,
          'num_rotores': numRotores,
          'peso': peso,
          'alcance_max': alcanceMax,
          'altitude_max': altitudeMax,
          'tempo_voo_max': tempoVooMax,
          'tempo_bateria': tempoBateria,
          'velocidade_max': velocidadeMax,
          'velocidade_ascente': velocidadeSubida,
          'velocidade_descendente': velocidadeDescida,
          'resistencia_vento': resistenciaVento,
          'temperatura': temperatura,
          'sistema_localizacao': sistemaLocalizacao,
          'tipo_camera': tipoCamera,
          'comprimento_img': comprimentoImg,
          'largura_img': larguraImg,
          'fov': fov,
          'resolucao_cam': resolucaoCam,
          'id_fabricante':1
        }),
      );

      // Verificar o status da resposta
      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sucesso'),
              content: Text('Drone salvo com sucesso!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Falha ao salvar o drone. Por favor, tente novamente.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Erro inesperado ao salvar o drone. Por favor, tente novamente mais tarde.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

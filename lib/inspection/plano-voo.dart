import 'package:flutter/material.dart';

class PlanoDeVooPage extends StatefulWidget {
  final String inspectionId;

  PlanoDeVooPage({required this.inspectionId});

  @override
  _PlanoDeVooPageState createState() => _PlanoDeVooPageState();
}

class _PlanoDeVooPageState extends State<PlanoDeVooPage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? distanciaObjecto;
  String? osd;
  String? areaMapeamento;
  String? taxaSobrepos;
  String? intervaloFoto;
  String? tipoVoo;
  String? linhaVoo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plano de Voo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Distância do objeto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatorio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        distanciaObjecto = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'OSD',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatorio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        osd = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Área de Mapeamento',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatorio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        areaMapeamento = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Taxa de sobreposição',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatorio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        taxaSobrepos = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Intervalo de foto',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatorio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        intervaloFoto = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tipo de voo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: tipoVoo,
                      items: ['VLOS', 'BVLOS', 'EVLOS'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          tipoVoo = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o tipo de voo';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        tipoVoo = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Linha de voo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe a linha de voo';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        linhaVoo = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continuar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projeto_final_flutter/inspection/pre-voo.dart';

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
  File? linhaVooImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          linhaVooImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      const url = 'http://10.0.2.2:3000/flightPlan/create';

      // Conversão dos valores
      double distanciaObjectoValue = double.parse(distanciaObjecto!);
      double osdValue = double.parse(osd!);
      double areaMapeamentoValue = double.parse(areaMapeamento!);
      double taxaSobreposValue = double.parse(taxaSobrepos!);
      double intervaloFotoValue = double.parse(intervaloFoto!);
      int idInspecaoValue = int.parse(widget.inspectionId);
      String linhaVooValue = linhaVooImage != null ? linhaVooImage!.path : '';

      try {
        var response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'distancia_objecto': distanciaObjectoValue,
            'osd': osdValue,
            'area_mapeamento': areaMapeamentoValue,
            'taxa_sobrepos': taxaSobreposValue,
            'intervalo_foto': intervaloFotoValue,
            'tipo_voo': tipoVoo!,
            'linha_voo': linhaVooValue,
            'id_inspecao': idInspecaoValue,
            'id_drone': 1,
          }),
        );
        if (response.statusCode == 200) {
          // Parse the response JSON
          Map<String, dynamic> responseData = json.decode(response.body);
          int newFlightPlanId = responseData['id'];

          print('Form data submitted successfully with ID: $newFlightPlanId');

          // Passa o id do recem criado plano de voo para a proxima page (pre-voo.dart)
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PreVooPage(flightPlanId: newFlightPlanId)),
          );
        } else {
          print('Failed to submit form data');
        }
      } catch (e) {
        print('Error submitting form data: $e');
        // Handle error
      }
    }
  }

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Linha de voo',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        linhaVooImage == null
                            ? const Text('Nenhuma imagem selecionada.')
                            : Image.file(linhaVooImage!),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text('Selecionar Imagem'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continuar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
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

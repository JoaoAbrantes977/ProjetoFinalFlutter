import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'process-info.dart';

class PosVooPage extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final Duration inspectionDuration;
  final int flightPlanId;

  PosVooPage({
    required this.startTime,
    required this.endTime,
    required this.inspectionDuration,
    required this.flightPlanId,
  });

  final TextEditingController numVoosController = TextEditingController();
  final TextEditingController numFotosController = TextEditingController();
  final TextEditingController numVideosController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pós Voo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(
                  controller: numVoosController,
                  labelText: 'Número de Voos',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o número de voos';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: numFotosController,
                  labelText: 'Número de Fotos',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o número de fotos';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: numVideosController,
                  labelText: 'Número de Vídeos',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o número de vídeos';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                _buildInfoText('Hora Início: ${startTime.toLocal()}'),
                SizedBox(height: 10),
                _buildInfoText('Hora Fim: ${endTime.toLocal()}'),
                SizedBox(height: 10),
                _buildInfoText('Tempo Total: ${_formatDuration(inspectionDuration)}'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm(context);
                    }
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
              ],
            ),
          ),
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
      keyboardType: TextInputType.number,
      validator: validator,
    );
  }

  Widget _buildInfoText(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _submitForm(BuildContext context) async {
    final numVoos = int.tryParse(numVoosController.text) ?? 0;
    final numFotos = int.tryParse(numFotosController.text) ?? 0;
    final numVideos = int.tryParse(numVideosController.text) ?? 0;
    final horaInicio = startTime.toLocal().toIso8601String().substring(11, 19);
    final horaFim = endTime.toLocal().toIso8601String().substring(11, 19);
    final tempoTotal = _formatDuration(inspectionDuration);

    final url = Uri.parse('http://10.0.2.2:3000/afterFlight/create');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'num_voos': numVoos,
        'hora_inicio': horaInicio,
        'hora_fim': horaFim,
        'tempo_total': tempoTotal,
        'num_fotos': numFotos,
        'num_videos': numVideos,
        'id_plano': flightPlanId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final insertedId = responseData['insertedId'];

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProcessInfoPage(afterFlightId: insertedId)),
      );
    } else {
      print('Failed to submit form');
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'voo.dart'; // Import your PosVooPage file here

class PreVooPage extends StatefulWidget {
  final int flightPlanId; // Receive flightPlanId from PlanoDeVooPage

  PreVooPage({required this.flightPlanId});

  @override
  _PreVooPageState createState() => _PreVooPageState();
}

class _PreVooPageState extends State<PreVooPage> {
  TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  String _weatherInfo = '';
  List<String> checklistItems = [
    'Velocidade do vento',
    'Direção do vento',
    'Temperatura',
    'Visibilidade',
    'Percentagem de bateria',
    'Sistema do aparelho atualizado',
    'Conexão aos sistemas de localização',
    'Sensores do aparelho operacionais',
    'Câmaras operacionais',
    'Aparelho calibrado',
  ];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize isCheckedList with false values
    isCheckedList = List<bool>.generate(checklistItems.length, (index) => false);
  }

  Future<void> _fetchWeather(String city) async {
    const apiKey = '360e7d2f369f0ef961e098ea03f5f790';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=pt&exclude=minutely,hourly,daily';

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final windDegree = data['wind']['deg'];
      String windDirection = _getWindDirection(windDegree);

      setState(() {
        _weatherInfo = 'Temperatura: ${data['main']['temp']}°C\n'
            'Condição: ${data['weather'][0]['description']}\n'
            'Velocidade do Vento: ${data['wind']['speed']} m/s\n'
            'Direção do Vento: $windDirection\n'
            'Visibilidade: ${data['visibility'] / 1000} km\n'
            'Probabilidade de Precipitação: ${data['clouds']['all']}%';
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherInfo = 'Falha ao carregar condições meteorológicas';
        _isLoading = false;
      });
    }
  }

  String _getWindDirection(int degree) {
    const List<String> directions = [
      'N', 'NNE', 'NE', 'ENE',
      'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW',
      'W', 'WNW', 'NW', 'NNW'
    ];

    int index = ((degree + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  bool allChecked() {
    return isCheckedList.every((isChecked) => isChecked);
  }

  void _navigateToPosVooPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VooPage(
          flightPlanId: widget.flightPlanId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificação Pré Voo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Pesquise por cidade',
                suffixIcon: IconButton(
                  onPressed: () {
                    _fetchWeather(_cityController.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Condições Meteorológicas:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _weatherInfo.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _weatherInfo,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
                    : const Text(
                  'Nenhuma informação meteorológica disponível.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: checklistItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(checklistItems[index]),
                    value: isCheckedList[index],
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedList[index] = value!;
                      });
                    },
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: allChecked() ? _navigateToPosVooPage : null,
                child: const Text('Avançar para a inspeção'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationsPage extends StatefulWidget {
  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Regulamentação'),
            Tab(text: 'Metereologia'),
            Tab(text: 'Drones'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RegulamentacaoPage(),
          CondicoesMeteorologicasPage(),
          TiposDeDronePage(),
        ],
      ),
    );
  }
}

class RegulamentacaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Regulamentação Page Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class CondicoesMeteorologicasPage extends StatefulWidget {
  @override
  _CondicoesMeteorologicasPageState createState() => _CondicoesMeteorologicasPageState();
}

class _CondicoesMeteorologicasPageState extends State<CondicoesMeteorologicasPage> {
  final TextEditingController _controller = TextEditingController();
  String _weatherInfo = '';
  bool _isLoading = false;

  Future<void> _fetchWeather(String city) async {
    final apiKey = 'your_api_key_here'; // Replace with your OpenWeatherMap API key
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=pt';

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherInfo = 'Temperatura: ${data['main']['temp']}°C\n'
            'Condição: ${data['weather'][0]['description']}';
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherInfo = 'Falha ao carregar condições meteorológicas';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Digite o nome da localidade',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _fetchWeather(_controller.text);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : Text(
            _weatherInfo,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class TiposDeDronePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Tipos de Drone Page Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Class Recommendations Page

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

  // tabview widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Regulamentos'),
              Tab(text: 'Meteorologia'),
              Tab(text: 'Drones'),
            ],
            indicatorColor: Colors.purple,
          ),
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

// Regulamentacao tab
class RegulamentacaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
Principais aspectos regulamentares para inspeções com drones

Regulamento n° 1093/2016 - Condições de operação aplicáveis e utilização do espaço aéreo pelos sistemas de aeronaves civis pilotadas remotamente (“Drones”)
- Os voos devem apenas:
  - Os operadores não podem exercer funções caso se encontrem em qualquer situação de incapacidade da sua aptidão física ou mental
  - O operador deve sempre verificar que se encontra em segurança e sem interferências condições
  - Não pode ser pilotagem uss aeronaves ao mesmo

Decreto-Lei n° 58/2018
- Carência de registo perante a ANAC dos os operadores de aparelhos de voo remotamente controlados com massa máxima operacional superior a 25 kg
  - Caso o aparelho tenha massa máxima operacional superior a 0.9 kg, o operador necessita de um seguro de responsabilidade civil

Voo sujeito à autorização da ANAC
- Não carecem de registo perante a ANAC os operadores de aparelhos de voo remotamente controlados com massa máxima operacional inferior a 1 kg desde que:
  - A altura do voo seja inferior a 5 metros acima da superfície
  - O voo seja efetuado no interior do FMV
  - O voo não seja efetuado com fins lucrativos nem no controle remoto
  - O voo se efetue com distanciamento seguro de bens e pessoas
  - A aeronave não esteja dotada de meio de propulsão não tripulado
  - As aeronaves dispõem de um peso inferior a 25 kg
  - O voo seja feito com a massa máxima operacional superior a 25 kg

Voo sujeito à autorização da ICNF
- Caso de voos sobre áreas protegidas e reservas naturais
- Realização de voos sobre áreas protegidas / reservas naturais na região autónoma da Madeira
- Realização de voos sobre áreas protegidas / reservas naturais na região autónoma dos Açores

Para inspeção de construções
- Inspeções dos pontos de intervenção devem ter a devida autorização por parte da entidade detentora do patrimônio a inspecionar

Links Úteis
- Regulamento para Operação de RPAS/Drones no Espaço Aéreo Civil Português: https://www.voanaboa.pt/formularios
- Download do formulário de drones ICNF: https://www.voanaboa.pt/Files/downloads/Formulario_utilizacao_drones_ICNF.pdf
- Global Drone Regulations Database: https://droneregulations.info/index.html

Contato
ANAC: +351 212 842 226 / Email: drones@anac.pt
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Condicoes Meteorologicas tab
class CondicoesMeteorologicasPage extends StatefulWidget {
  @override
  _CondicoesMeteorologicasPageState createState() => _CondicoesMeteorologicasPageState();
}

class _CondicoesMeteorologicasPageState extends State<CondicoesMeteorologicasPage> {
  final TextEditingController _controller = TextEditingController();
  String _weatherInfo = '';
  String _weatherIcon = '';
  bool _isLoading = false;

  Future<void> _fetchWeather(String city) async {
    final apiKey = '360e7d2f369f0ef961e098ea03f5f790'; // chave da api OpenWeather
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=pt';

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherInfo = 'Temperatura: ${data['main']['temp']}°C\n'
            'Condição: ${data['weather'][0]['description']}\n'
            'Velocidade do Vento: ${data['wind']['speed']} m/s\n'
            'Visibilidade: ${data['visibility'] / 1000} km\n'
            'Probabilidade de Precipitação: ${data['clouds']['all']}%';
        _weatherIcon = 'http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png';
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherInfo = 'Falha ao carregar condições meteorológicas';
        _isLoading = false;
      });
    }
  }

  // widget metereologia
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
              : Column(
            children: [
              if (_weatherIcon.isNotEmpty)
                Image.network(_weatherIcon),
              Text(
                _weatherInfo,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// drones tab
class TiposDeDronePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Principais aspetos a ter em conta para a seleção do aparelho\n\n'
                'Tipo de sistema de voo\n'
                '- Para inspeções da envolvente de construções aconselha-se o uso de aparelhos multirotor\n'
                '- Para inspeção de estradas com grande extensão, aconselha-se o uso de aparelhos de asa fixa ou híbridos\n\n'
                'Alcance\n'
                '- O alcance máximo do aparelho deve ser superior a, pelo menos, metade da distância máxima entre o operador e o aparelho a quando da inspeção\n\n'
                'Sensores\n'
                '- Para inspeções onde seja necessário aproximar o aparelho à envolvente da construção, aconselha-se que o mesmo esteja equipado, no mínimo, com sensores frontais e laterais, por forma a evitar colisões\n'
                '- Para inspeções em zonas com obstáculos acima do aparelho (ex: zona inferior do tabuleiro de uma ponte), aconselha-se que o mesmo esteja equipado com sensores verticais superiores por forma a evitar colisões\n\n'
                'Câmera\n'
                '- Para inspeções nas quais seja necessário observar zonas acima do aparelho, aconselha-se o uso de câmeras acopladas (Gimbal) com ângulo de rotação que permita a visualização desses locais\n'
                '- A resolução das fotos deve ser suficiente para poder detectar anomalias de pequena dimensão (ex: fissuras), sendo recomendada uma resolução superior a 12 Megapixels\n'
                '- Aconselha-se uma resolução de vídeo de pelo menos 1080p por forma a obter detalhe suficiente para detectar anomalias de pequena dimensão\n\n'
                'Velocidade máxima de vento suportada\n'
                '- Caso a velocidade do vento registada no local a quando do levantamento for superior à velocidade máxima suportada pelo drone, o voo deve ser interrompido até que a velocidade do vento permita o voo em segurança\n\n'
                'Sistema de localização\n'
                '- Para inspeções correntes (boas condições atmosféricas e bom sinal de GPS), recomenda-se o uso de drones equipados com, pelo menos, sistema de GPS/ GLONASS\n'
                '- Para inspeções com condições atmosféricas adversas e sinal de GPS fraco, recomenda-se o uso de sistemas de localização RTK\n',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

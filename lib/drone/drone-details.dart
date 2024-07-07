import 'package:flutter/material.dart';

class DroneDetailsPage extends StatelessWidget {
  final Map<String, dynamic> drone;

  DroneDetailsPage({required this.drone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do Drone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gama: ${drone['gama']}', style: const TextStyle(fontSize: 18)),
            Text('Propulsão: ${drone['propulsao']}', style: const TextStyle(fontSize: 18)),
            Text('Numero de Rotores: ${drone['num_rotores']}', style: const TextStyle(fontSize: 18)),
            Text('Peso: ${drone['peso']} kg', style: const TextStyle(fontSize: 18)),
            Text('Alcance Máximo: ${drone['alcance_max']} km', style: const TextStyle(fontSize: 18)),
            Text('Altitude Máxima: ${drone['altitude_max']} m', style: const TextStyle(fontSize: 18)),
            Text('Tempo de voo máximo: ${drone['tempo_voo_max']}', style: const TextStyle(fontSize: 18)),
            Text('Tempo de Bateria: ${drone['tempo_bateria']}', style: const TextStyle(fontSize: 18)),
            Text('Velocidade Máxima: ${drone['velocidade_max']}', style: const TextStyle(fontSize: 18)),
            Text('Velocidade Ascendete: ${drone['velocidade_ascente']}', style: const TextStyle(fontSize: 18)),
            Text('Velocidade Descendente: ${drone['velocidade_descendente']}', style: TextStyle(fontSize: 18)),
            Text('Resistência ao Vento: ${drone['resistencia_vento']}', style: const TextStyle(fontSize: 18)),
            Text('Temperatura: ${drone['temperatura']} °C', style: const TextStyle(fontSize: 18)),
            Text('Sistema de Localização: ${drone['sistema_localizacao']}', style: const TextStyle(fontSize: 18)),
            Text('Tipo de Câmara: ${drone['tipo_camera']}', style: const TextStyle(fontSize: 18)),
            Text('Comprimento de Imagem: ${drone['comprimento_img']} px', style: const TextStyle(fontSize: 18)),
            Text('Largura de Imagem: ${drone['largura_img']} px', style: const TextStyle(fontSize: 18)),
            Text('FOV: ${drone['fov']} °', style: const TextStyle(fontSize: 18)),
            Text('Resolução de Câmara: ${drone['resolucao_cam']}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

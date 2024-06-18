import 'package:flutter/material.dart';

class DroneDetailsPage extends StatelessWidget {
  final Map<String, dynamic> drone;

  DroneDetailsPage({required this.drone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drone Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gama: ${drone['gama']}', style: const TextStyle(fontSize: 18)),
            Text('Propulsion: ${drone['propulsao']}', style: const TextStyle(fontSize: 18)),
            Text('Number of Rotors: ${drone['num_rotores']}', style: const TextStyle(fontSize: 18)),
            Text('Weight: ${drone['peso']} kg', style: const TextStyle(fontSize: 18)),
            Text('Max Range: ${drone['alcance_max']} km', style: const TextStyle(fontSize: 18)),
            Text('Max Altitude: ${drone['altitude_max']} m', style: const TextStyle(fontSize: 18)),
            Text('Max Flight Time: ${drone['tempo_voo_max']}', style: const TextStyle(fontSize: 18)),
            Text('Battery Time: ${drone['tempo_bateria']}', style: const TextStyle(fontSize: 18)),
            Text('Max Speed: ${drone['velocidade_max']}', style: const TextStyle(fontSize: 18)),
            Text('Ascent Speed: ${drone['velocidade_ascente']}', style: const TextStyle(fontSize: 18)),
            Text('Descent Speed: ${drone['velocidade_descendente']}', style: TextStyle(fontSize: 18)),
            Text('Wind Resistance: ${drone['resistencia_vento']}', style: const TextStyle(fontSize: 18)),
            Text('Operating Temperature: ${drone['temperatura']} °C', style: const TextStyle(fontSize: 18)),
            Text('Location System: ${drone['sistema_localizacao']}', style: const TextStyle(fontSize: 18)),
            Text('Camera Type: ${drone['tipo_camera']}', style: const TextStyle(fontSize: 18)),
            Text('Image Length: ${drone['comprimento_img']} px', style: const TextStyle(fontSize: 18)),
            Text('Image Width: ${drone['largura_img']} px', style: const TextStyle(fontSize: 18)),
            Text('Field of View: ${drone['fov']} °', style: const TextStyle(fontSize: 18)),
            Text('Camera Resolution: ${drone['resolucao_cam']}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

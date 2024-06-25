import 'dart:io';
import 'package:flutter/material.dart';

class PosVooPage extends StatefulWidget {
  final int flightPlanId;

  PosVooPage({required this.flightPlanId});

  @override
  _PosVooPageState createState() => _PosVooPageState();
}

class _PosVooPageState extends State<PosVooPage> {
  String imagePath =
      '/data/user/0/com.example.projeto_final_flutter/cache/13ff016c-140d-4634-830f-6c9d53939e43/1000000035.png';

  bool isInspectionStarted = false;
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pós Voo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.file(
              File(imagePath),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (!isInspectionStarted) {
                  // Start inspection
                  startTime = DateTime.now();
                  isInspectionStarted = true;
                } else {
                  // End inspection
                  endTime = DateTime.now();
                  isInspectionStarted = false;
                  // Calculate duration
                  Duration inspectionDuration = endTime!.difference(startTime!);
                  print('Inspection started at: ${startTime!.toLocal()}');
                  print('Inspection finished at: ${endTime!.toLocal()}');
                  print('Inspection duration: ${_formatDuration(inspectionDuration)}');
                }
              });
            },
            child: Text(isInspectionStarted ? 'Terminar Inspeção' : 'Iniciar Inspeção'),
          ),
        ],
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
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'pos-voo.dart';

class VooPage extends StatefulWidget {
  final int flightPlanId;

  VooPage({required this.flightPlanId});

  @override
  _VooPageState createState() => _VooPageState();
}

class _VooPageState extends State<VooPage> {
  String imagePath =
      '/data/user/0/com.example.projeto_final_flutter/cache/13ff016c-140d-4634-830f-6c9d53939e43/1000000035.png';

  bool isInspectionStarted = false;
  DateTime? startTime;
  DateTime? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voo de Inspeção'),
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
          const SizedBox(height: 20),
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

                  // Navigate to PosVooPage and pass values
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PosVooPage(
                        startTime: startTime!,
                        endTime: endTime!,
                        inspectionDuration: inspectionDuration,
                        flightPlanId: widget.flightPlanId,
                      ),
                    ),
                  );
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


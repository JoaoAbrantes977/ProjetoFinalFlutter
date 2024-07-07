import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pos-voo.dart';

// class
class VooPage extends StatefulWidget {
  final int flightPlanId;

  VooPage({required this.flightPlanId});

  @override
  _VooPageState createState() => _VooPageState();
}

class _VooPageState extends State<VooPage> {
  String imagePath = '';
  bool isInspectionStarted = false;
  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    super.initState();
    _fetchImagePath();
  }
  Future<void> _fetchImagePath() async {
    final url = 'http://10.0.2.2:3000/flightPlan/${widget.flightPlanId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final flightPlan = jsonDecode(response.body);
        setState(() {
          imagePath = flightPlan['linha_voo'];
        });
      } else {
        throw Exception('Failed to load flight plan');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voo de Inspeção'),
      ),
      body: imagePath.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
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

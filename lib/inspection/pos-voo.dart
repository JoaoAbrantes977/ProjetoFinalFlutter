import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pós Voo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Start Time: ${startTime.toLocal()}'),
            Text('End Time: ${endTime.toLocal()}'),
            Text('Inspection Duration: ${_formatDuration(inspectionDuration)}'),
            Text('Flight Plan ID: $flightPlanId'),
          ],
        ),
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

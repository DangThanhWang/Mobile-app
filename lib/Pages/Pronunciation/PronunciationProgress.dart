import 'package:flutter/material.dart';

class PronunciationProgress extends StatelessWidget {
  final int completedSentences;
  final int totalSentences;

  PronunciationProgress({
    required this.completedSentences,
    required this.totalSentences,
  });

  @override
  Widget build(BuildContext context) {
    double progress = completedSentences / totalSentences;

    return Column(
      children: [
        Text(
          'Tiến độ: $completedSentences / $totalSentences',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          minHeight: 12,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

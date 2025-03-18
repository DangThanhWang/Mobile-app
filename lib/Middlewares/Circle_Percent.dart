import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CirclePercent extends StatelessWidget {
  final String text;
  final double radius;
  final double lineWidth;
  final double percent;
  final double fontSize;
  final bool check;
  CirclePercent({
    required this.text,
    required this.radius,
    required this.lineWidth,
    required this.percent,
    required this.fontSize,
    required this.check,
  });

  @override
  Widget build(BuildContext context) {
    const String subtitle = "/50";

    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      animation: true,
      percent: percent, // 65%
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              if (check)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 116, 116, 120),
                  ),
                ),
            ],
          ),
          if (check)
            Text(
              "quiz played",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 116, 116, 120),
              ),
            ),
        ],
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.pinkAccent,
      backgroundColor: Colors.pink.shade100,
    );
  }
}

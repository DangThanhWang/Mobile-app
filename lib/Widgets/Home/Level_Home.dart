import 'package:flutter/material.dart';
import 'package:app/Definitons/Color.dart';
import 'package:app/helpers/DotsIndicator.dart';

import '../Dictionary/Dictionary.dart';
import '../Dictionary/FloatingDictionaryButton.dart';

class LevelHome extends StatelessWidget {
  final int currentLevel;
  final Function(int) onDotTap;

  const LevelHome({required this.currentLevel, required this.onDotTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/home/goal.png",
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                "Level",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade300,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text(
                  "${currentLevel + 1}", // Display current level (1-based index)
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
              // FloatingDictionaryButton(
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => const Dictionary()),
              //     );
              //   },
              // ),
            ],

          ),
          const SizedBox(height: 10),
          DotsIndicator(
            currentIndex: currentLevel,
            totalDots: 6,
            onDotTap: onDotTap, // Call back when a dot is tapped
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FloatingDictionaryButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingDictionaryButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF7C72E5), Color(0xFF4CAF50)], // Gradient for theme
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(4, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular inner glow effect
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          // Custom Dictionary Icon
          Image.asset(
            'assets/images/dictionary.png', // Path to your custom icon
            width: 30,
            height: 30,
            color: Colors.white, // Tint color to match the theme
          ),
          // Accent Circle for Interaction
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search,
                size: 12,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
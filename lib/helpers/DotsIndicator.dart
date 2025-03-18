import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  final Function(int)? onDotTap; // Optional callback for dot tap interaction
  final double activeDotSize;
  final double inactiveDotSize;
  final double dotSpacing;
  final Color activeDotColor;
  final Color inactiveDotColor;

  const DotsIndicator({
    Key? key,
    required this.currentIndex,
    required this.totalDots,
    this.onDotTap, // Allow `null`
    this.activeDotSize = 16,
    this.inactiveDotSize = 10,
    this.dotSpacing = 8,
    this.activeDotColor = const Color(0xFF8D6E63),
    this.inactiveDotColor = const Color(0xFFCCCCCC),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: onDotTap != null ? () => onDotTap!(index) : null, // Handle `null`
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: dotSpacing / 2),
            width: isActive ? activeDotSize : inactiveDotSize,
            height: isActive ? activeDotSize : inactiveDotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeDotColor : inactiveDotColor,
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: activeDotColor.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
                  : [],
            ),
          ),
        );
      }),
    );
  }
}



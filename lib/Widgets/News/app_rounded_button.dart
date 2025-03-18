import 'package:flutter/material.dart';

class AppRoundedButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;

  const AppRoundedButton({
    Key? key,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.brown.shade400, Colors.orange.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            iconData,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

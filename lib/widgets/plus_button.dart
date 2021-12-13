import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;
  const PlusButton({required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 75,
        width: 75,
        child: Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[400],
          boxShadow: [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}

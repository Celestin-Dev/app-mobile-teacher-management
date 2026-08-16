import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Rectangle extérieur : toute la surface
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Ancienne forme de la vague
    final wave = Path();

    wave.moveTo(0, size.height * 0.30);

    wave.cubicTo(
      size.width * 0.25,
      size.height * 0.85,
      size.width * 0.35,
      size.height * 0.85,
      size.width * 0.55,
      size.height * 0.80,
    );

    wave.cubicTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width * 0.85,
      size.height * 0.95,
      size.width,
      size.height,
    );

    wave.lineTo(size.width, 0);
    wave.lineTo(0, 0);
    wave.close();

    // Soustraction de la vague
    path.addPath(wave, Offset.zero);

    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

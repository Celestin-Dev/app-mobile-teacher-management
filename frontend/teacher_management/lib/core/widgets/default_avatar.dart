import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DefaultAvatar extends StatelessWidget {
  final double size;
  final String? photoUrl;
  final bool? isAppBar;

  const DefaultAvatar({
    super.key,
    this.size = 96,
    this.photoUrl,
    this.isAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isAppBar == true ? AppColors.avatarBg : Colors.white,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: (photoUrl != null && photoUrl!.isNotEmpty)
          ? Image.network(photoUrl!, fit: BoxFit.cover)
          : CustomPaint(
              size: Size(size, size),
              painter: _PersonSilhouettePainter(color: AppColors.inkSoft),
            ),
    );
  }
}

class _PersonSilhouettePainter extends CustomPainter {
  final Color color;
  _PersonSilhouettePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Tête : cercle centré, légèrement au-dessus du centre vertical
    final headRadius = w * 0.185;
    final headCenter = Offset(w / 2, h * 0.36);
    canvas.drawCircle(headCenter, headRadius, paint);

    // Épaules : ellipse large, légèrement coupée en bas par le cercle du conteneur
    final bodyRect = Rect.fromCenter(
      center: Offset(w / 2, h * 0.775),
      width: w * 0.62,
      height: h * 0.42,
    );
    canvas.drawOval(bodyRect, paint);
  }

  @override
  bool shouldRepaint(covariant _PersonSilhouettePainter oldDelegate) =>
      oldDelegate.color != color;
}

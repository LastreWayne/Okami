import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:okami/theme/app_theme.dart';

/// A short, tapered ink brush stroke filled with the accent gradient.
class BrushStroke extends StatelessWidget {
  final double width;
  final double height;
  const BrushStroke({super.key, this.width = 64, this.height = 6});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(width, height), painter: _BrushPainter());
}

class _BrushPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = AppGradients.accent.createShader(rect)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.6, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.7, size.width, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.85, size.height, size.width * 0.55, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.55, 0, size.height * 0.5)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A mincho screen title with a gradient brush underline and optional subtitle.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: t.headlineLarge),
        const SizedBox(height: 8),
        const BrushStroke(),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(subtitle!, style: t.bodyMedium),
        ],
      ],
    );
  }
}

/// A faint 狼 (ōkami / wolf) watermark for backgrounds and empty states.
class KanjiWatermark extends StatelessWidget {
  final double size;
  const KanjiWatermark({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Text(
      '狼',
      style: GoogleFonts.shipporiMincho(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: AppColors.ink.withValues(alpha: 0.05),
      ),
    );
  }
}

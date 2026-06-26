import 'package:flutter/material.dart';
import 'package:okami/models/task_model.dart';
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
      style: TextStyle(
        fontFamily: AppFonts.mincho,
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 150, 155, 226).withValues(alpha: 0.5),
      ),
    );
  }
}

/// Flat, hairline-bordered surface card (replaces stock Material Card).
class InkCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  const InkCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap, child: content),
            ),
    );
  }
}

/// A square-ish tappable tile with an outline icon over a label.
class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.ink),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

/// Full-width primary button filled with the accent gradient.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const GradientButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppGradients.accent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            height: 52,
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: AppFonts.inter,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single task as a tappable ink card with a gradient priority bar.
class TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskRow({super.key, required this.task, required this.onTap});

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.a:
        return AppColors.priorityA;
      case TaskPriority.b:
        return AppColors.priorityB;
      case TaskPriority.c:
        return AppColors.priorityC;
    }
  }

  String get _categoryLabel {
    switch (task.category) {
      case TaskCategory.body:
        return 'Body';
      case TaskCategory.neuroplasticity:
        return 'Neuroplasticity';
      case TaskCategory.motion:
        return 'Motion';
    }
  }

  String get _meta {
    final h = task.dateTime.hour.toString().padLeft(2, '0');
    final m = task.dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m  ·  ${task.durationMinutes.asDuration}  ·  $_categoryLabel';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkCard(
        onTap: onTap,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 42,
              decoration: BoxDecoration(
                color: _priorityColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: t.titleMedium),
                  const SizedBox(height: 4),
                  Text(_meta, style: t.labelMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkFaint, size: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, this.tone = BadgeTone.neutral, super.key});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      BadgeTone.success => const Color(0xFF4CD884),
      BadgeTone.warning => const Color(0xFFF6B44B),
      BadgeTone.danger => const Color(0xFFFF6B6B),
      BadgeTone.info => Theme.of(context).colorScheme.primary,
      BadgeTone.neutral => Theme.of(context).colorScheme.outline,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        border: Border.all(color: color.withOpacity(.5)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    );
  }
}

enum BadgeTone { neutral, success, warning, danger, info }

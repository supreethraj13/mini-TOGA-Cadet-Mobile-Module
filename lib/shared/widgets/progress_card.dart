import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.title,
    required this.value,
    required this.subtitle,
    super.key,
  });

  final String title;
  final int value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 100);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: clamped / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 10),
            Text('$clamped% · $subtitle'),
          ],
        ),
      ),
    );
  }
}

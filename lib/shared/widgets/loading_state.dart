import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({this.lines = 4, super.key});

  final int lines;

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(.35);
    final highlight = Theme.of(context).colorScheme.primary.withOpacity(.18);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: List.generate(widget.lines, (index) {
              return Container(
                height: index == 0 ? 96 : 72,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment(-1 + _controller.value * 2, 0),
                    end: Alignment(1 + _controller.value * 2, 0),
                    colors: [base, highlight, base],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

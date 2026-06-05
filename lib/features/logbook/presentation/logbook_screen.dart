import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_state.dart';
import 'logbook_cubit.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LogbookCubit>().loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookCubit, LogbookState>(
      builder: (context, state) {
        if (state.status == LogbookStatus.loading ||
            state.status == LogbookStatus.initial) {
          return const ShimmerSkeleton(lines: 4);
        }
        if (state.status == LogbookStatus.failure) {
          return ErrorState(
            message: state.error ?? 'Logbook failed.',
            onRetry: () => context.read<LogbookCubit>().loadSummary(),
          );
        }
        final summary = state.summary!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: MediaQuery.sizeOf(context).width > 600
                  ? 1.55
                  : 1.25,
              children: [
                _MetricCard(
                  label: 'Total Flight Hours',
                  value: '${summary.totalHours.toStringAsFixed(1)} h',
                ),
                _MetricCard(
                  label: 'Solo Hours',
                  value: '${summary.soloHours.toStringAsFixed(1)} h',
                ),
                _MetricCard(
                  label: 'Dual Hours',
                  value: '${summary.dualHours.toStringAsFixed(1)} h',
                ),
                _MetricCard(
                  label: 'Last Flight Date',
                  value: summary.lastFlight,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.verified_user_rounded),
                title: const Text('Currency Status'),
                subtitle: const Text(
                  'Placeholder: meets recent navigation training recency.',
                ),
                trailing: OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add logbook entry placeholder.'),
                    ),
                  ),
                  child: const Text('Add Entry'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Recent Entries',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (summary.recentEntries.isEmpty)
              const EmptyState(
                title: 'No logbook entries',
                message: 'Recent flight records will appear here.',
              )
            else
              for (final entry in summary.recentEntries)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.flight_rounded),
                    title: Text('${entry.aircraft} · ${entry.lesson}'),
                    subtitle: Text('${entry.date} · ${entry.route}'),
                    trailing: Text(
                      '${entry.duration.toStringAsFixed(1)} h',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

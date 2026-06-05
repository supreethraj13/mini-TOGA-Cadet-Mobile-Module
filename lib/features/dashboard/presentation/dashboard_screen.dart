import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_state.dart';
import '../../../shared/widgets/progress_card.dart';
import 'dashboard_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.onContinueStudy, super.key});

  final VoidCallback onContinueStudy;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading ||
            state.status == DashboardStatus.initial) {
          return const ShimmerSkeleton(lines: 5);
        }
        if (state.status == DashboardStatus.failure) {
          return ErrorState(
            message: state.error ?? 'Dashboard failed to load.',
            onRetry: () => context.read<DashboardCubit>().loadDashboard(),
          );
        }
        final dashboard = state.dashboard!;
        return RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 720;
              final cards = [
                ProgressCard(
                  title: 'Overall Study Progress',
                  value: dashboard.overallStudyProgress,
                  subtitle: 'Navigation phase readiness',
                ),
                _InfoCard(
                  title: 'Upcoming Flight',
                  icon: Icons.flight_takeoff_rounded,
                  lines: [
                    '${dashboard.upcomingFlight.aircraft} · ${dashboard.upcomingFlight.lesson}',
                    '${dashboard.upcomingFlight.date} at ${dashboard.upcomingFlight.time}',
                  ],
                ),
                _InfoCard(
                  title: 'Logbook Metrics',
                  icon: Icons.speed_rounded,
                  lines: [
                    '${dashboard.logbook.totalHours.toStringAsFixed(1)} total hours',
                    '${dashboard.logbook.soloHours.toStringAsFixed(1)} solo hours · Last ${dashboard.logbook.lastFlight}',
                  ],
                ),
                _InfoCard(
                  title: 'Notifications',
                  icon: Icons.notifications_active_rounded,
                  lines: const [
                    'Unread training updates waiting',
                    'Sync and feedback cards are interactive',
                  ],
                ),
              ];
              return ListView(
                padding: EdgeInsets.all(wide ? 24 : 16),
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(wide ? 24 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cadet ${dashboard.cadetName}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${dashboard.course} · ${dashboard.trainingStage}',
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 18,
                            runSpacing: 6,
                            children: [
                              Text('FTO ${dashboard.assignedFto}'),
                              Text(
                                'Instructor ${dashboard.assignedInstructor}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (wide)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.55,
                      children: cards,
                    )
                  else
                    ...cards.expand(
                      (card) => [card, const SizedBox(height: 12)],
                    ),
                  const SizedBox(height: 8),
                  AppButton(
                    label: 'Continue Study',
                    icon: Icons.menu_book_rounded,
                    onPressed: widget.onContinueStudy,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.lines,
  });

  final String title;
  final IconData icon;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  for (final line in lines) Text(line),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

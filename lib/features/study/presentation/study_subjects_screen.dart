import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_state.dart';
import '../../../shared/widgets/status_badge.dart';
import '../models/study_subject.dart';
import 'study_cubit.dart';
import 'subject_detail_screen.dart';

class StudySubjectsScreen extends StatefulWidget {
  const StudySubjectsScreen({super.key});

  @override
  State<StudySubjectsScreen> createState() => _StudySubjectsScreenState();
}

class _StudySubjectsScreenState extends State<StudySubjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudyCubit>().loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyCubit, StudyState>(
      builder: (context, state) {
        if (state.status == StudyStatus.loading ||
            state.status == StudyStatus.initial) {
          return const ShimmerSkeleton(lines: 6);
        }
        if (state.status == StudyStatus.failure) {
          return ErrorState(
            message: state.error ?? 'Study subjects failed to load.',
            onRetry: () => context.read<StudyCubit>().loadSubjects(),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Search aviation subjects',
                    ),
                    onChanged: context.read<StudyCubit>().setQuery,
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          selected: state.filter == null,
                          onTap: () =>
                              context.read<StudyCubit>().setFilter(null),
                        ),
                        for (final status in SubjectStatus.values)
                          _FilterChip(
                            label: status.label,
                            selected: state.filter == status,
                            onTap: () =>
                                context.read<StudyCubit>().setFilter(status),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.filteredSubjects.isEmpty
                  ? const EmptyState(
                      title: 'No subjects found',
                      message: 'Adjust the search or status filter.',
                    )
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) =>
                              _SubjectCard(subject: state.filteredSubjects[index]),
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemCount: state.filteredSubjects.length,
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject});

  final StudySubject subject;

  @override
  Widget build(BuildContext context) {
    final tone = switch (subject.status) {
      SubjectStatus.completed => BadgeTone.success,
      SubjectStatus.inProgress => BadgeTone.info,
      SubjectStatus.notStarted => BadgeTone.neutral,
    };
    return Card(
      child: ListTile(
        onTap: () async {
          await context.read<StudyCubit>().selectSubject(subject.id);
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const SubjectDetailScreen(),
            ),
          );
        },
        title: Text(
          subject.subject,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: subject.progress / 100,
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Text(
              '${subject.lessonsCompleted}/${subject.totalLessons} lessons · Quiz ${subject.quizScore}%',
            ),
          ],
        ),
        trailing: StatusBadge(label: subject.status.label, tone: tone),
      ),
    );
  }
}

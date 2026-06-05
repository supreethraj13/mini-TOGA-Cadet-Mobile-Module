import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/loading_state.dart';
import '../../../shared/widgets/progress_card.dart';
import 'study_cubit.dart';

class SubjectDetailScreen extends StatelessWidget {
  const SubjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject Detail')),
      body: BlocConsumer<StudyCubit, StudyState>(
        listenWhen: (previous, current) =>
            previous.error != current.error && current.error != null,
        listener: (context, state) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        },
        builder: (context, state) {
          if (state.detailStatus == StudyStatus.loading) {
            return const ShimmerSkeleton(lines: 5);
          }
          final subject = state.selectedSubject;
          if (subject == null) {
            return const Center(child: Text('No subject selected.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                subject.subject,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ProgressCard(
                title: 'Subject Progress',
                value: subject.progress,
                subtitle: subject.status.label,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ActionButton(label: 'Quiz', icon: Icons.quiz_rounded),
                  _ActionButton(label: 'Flashcards', icon: Icons.style_rounded),
                  _ActionButton(
                    label: 'Practice Test',
                    icon: Icons.fact_check_rounded,
                  ),
                  _ActionButton(
                    label: 'Ask AIRMAN AI',
                    icon: Icons.auto_awesome_rounded,
                    ai: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Chapters', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final chapter in subject.chapters)
                Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CheckboxListTile(
                    value: chapter.completed,
                    onChanged: (_) =>
                        context.read<StudyCubit>().toggleChapter(chapter),
                    title: Text(chapter.title),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    this.ai = false,
  });

  final String label;
  final IconData icon;
  final bool ai;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      child: AppButton(
        label: label,
        icon: icon,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ai
                    ? 'AIRMAN AI will help you clarify aviation concepts here.'
                    : '$label workflow placeholder for the selected subject.',
              ),
            ),
          );
        },
      ),
    );
  }
}

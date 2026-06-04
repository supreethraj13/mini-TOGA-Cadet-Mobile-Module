import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_state.dart';
import '../../../shared/widgets/status_badge.dart';
import '../models/study_note.dart';
import 'notes_cubit.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _controller = TextEditingController();
  final _subjects = const {
    'met': 'Meteorology',
    'air-reg': 'Air Regulations',
    'nav': 'Navigation',
    'tech-gen': 'Technical General',
    'tech-spec': 'Technical Specific',
    'air-nav': 'Air Navigation',
    'rtr': 'RTR / Communication',
  };
  String _selected = 'met';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesState>(
      listener: (context, state) {
        if (state.actionStatus == NotesStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note queue updated.')));
        }
        if (state.actionStatus == NotesStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error ?? 'Note action failed.')));
        }
      },
      builder: (context, state) {
        if (state.status == NotesStatus.loading || state.status == NotesStatus.initial) {
          return const ShimmerSkeleton(lines: 4);
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offline Study Note', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selected,
                      items: _subjects.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
                      onChanged: (value) => setState(() => _selected = value ?? _selected),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      minLines: 4,
                      maxLines: 8,
                      decoration: const InputDecoration(hintText: 'Write a study observation or flight lesson note'),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Save Locally',
                      icon: Icons.save_rounded,
                      loading: state.actionStatus == NotesStatus.loading,
                      onPressed: () {
                        final body = _controller.text;
                        context.read<NotesCubit>().saveNote(
                              subjectId: _selected,
                              subject: _subjects[_selected]!,
                              body: body,
                            );
                        if (body.trim().isNotEmpty) _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (state.notes.isEmpty)
              const EmptyState(title: 'No local notes', message: 'Saved notes persist locally and wait for sync.')
            else
              ...state.notes.map((note) => _NoteCard(note: note)),
          ],
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final StudyNote note;

  @override
  Widget build(BuildContext context) {
    final tone = switch (note.syncStatus) {
      SyncStatus.synced => BadgeTone.success,
      SyncStatus.failed => BadgeTone.danger,
      SyncStatus.syncing => BadgeTone.warning,
      SyncStatus.pending => BadgeTone.info,
    };
    final canSync = note.syncStatus != SyncStatus.syncing && note.syncStatus != SyncStatus.synced;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(note.subject, style: const TextStyle(fontWeight: FontWeight.w800))),
                StatusBadge(label: note.syncStatus.label, tone: tone),
              ],
            ),
            const SizedBox(height: 8),
            Text(note.body),
            if (note.failureMessage != null) ...[
              const SizedBox(height: 8),
              Text(note.failureMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: canSync ? () => context.read<NotesCubit>().syncNote(note) : null,
              icon: const Icon(Icons.sync_rounded),
              label: Text(note.syncStatus == SyncStatus.failed ? 'Retry Sync' : 'Sync Now'),
            ),
          ],
        ),
      ),
    );
  }
}

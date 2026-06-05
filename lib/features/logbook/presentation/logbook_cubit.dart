import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/logbook_repository.dart';
import '../models/logbook_summary.dart';

part 'logbook_state.dart';

class LogbookCubit extends Cubit<LogbookState> {
  LogbookCubit(this._repository) : super(const LogbookState());

  final LogbookRepository _repository;

  Future<void> loadSummary() async {
    emit(state.copyWith(status: LogbookStatus.loading));
    try {
      final summary = await _repository.fetchSummary();
      emit(state.copyWith(status: LogbookStatus.success, summary: summary));
    } catch (error) {
      emit(
        state.copyWith(status: LogbookStatus.failure, error: error.toString()),
      );
    }
  }
}

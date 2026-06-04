part of 'logbook_cubit.dart';

enum LogbookStatus { initial, loading, success, failure }

class LogbookState extends Equatable {
  const LogbookState({this.status = LogbookStatus.initial, this.summary, this.error});

  final LogbookStatus status;
  final LogbookSummary? summary;
  final String? error;

  LogbookState copyWith({LogbookStatus? status, LogbookSummary? summary, String? error}) {
    return LogbookState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, summary, error];
}

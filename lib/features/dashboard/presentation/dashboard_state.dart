part of 'dashboard_cubit.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({this.status = DashboardStatus.initial, this.dashboard, this.error});

  final DashboardStatus status;
  final DashboardModel? dashboard;
  final String? error;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardModel? dashboard,
    String? error,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, dashboard, error];
}

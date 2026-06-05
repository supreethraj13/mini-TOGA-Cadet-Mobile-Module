import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/dashboard_repository.dart';
import '../models/dashboard_model.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  final DashboardRepository _repository;

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final dashboard = await _repository.fetchDashboard();
      emit(
        state.copyWith(status: DashboardStatus.success, dashboard: dashboard),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }
}

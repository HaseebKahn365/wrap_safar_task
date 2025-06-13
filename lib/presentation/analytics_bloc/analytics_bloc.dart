import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wrap_safar_task/domain/repositories/analytics_enitity_repo.dart';
import 'package:wrap_safar_task/presentation/analytics_bloc/analytics_event.dart';
import 'package:wrap_safar_task/presentation/analytics_bloc/analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsEnitityRepo analyticsRepository;

  AnalyticsBloc({required this.analyticsRepository})
    : super(const AnalyticsInitial()) {
    on<LoadAnalyticsLogsEvent>(_onLoadLogs);
    on<SaveAnalyticsLogEvent>(_onSaveLog);
    on<DeleteAllAnalyticsLogsEvent>(_onDeleteAllLogs);
  }

  Future<void> _onLoadLogs(
    LoadAnalyticsLogsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    final result = await analyticsRepository.getAllLogsFromSharedPrefs();
    result.fold((failure) => emit(AnalyticsError(failure.message)), (logs) {
      //empty logs should emit intial state
      if (logs.isEmpty) {
        emit(const AnalyticsInitial());
        return;
      }
      emit(AnalyticsLoaded(logs));
    });
  }

  Future<void> _onSaveLog(
    SaveAnalyticsLogEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    final result = await analyticsRepository.saveLogToSharedPrefs(
      event.analyticsEntity,
    );
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (_) => emit(const AnalyticsLogSaved()),
    );
  }

  Future<void> _onDeleteAllLogs(
    DeleteAllAnalyticsLogsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    final result = await analyticsRepository.deleteAllLogsFromSharedPrefs();
    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (_) => emit(const AnalyticsLogsDeleted()),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';
import 'package:wrap_safar_task/domain/repositories/analytics_enitity_repo.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_event.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_state.dart';
import 'package:wrap_safar_task/services/analytics_service.dart';

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

    final entity = event.analyticsEntity;

    try {
      // Log event to Firebase
      switch (entity.analyticsType) {
        case EventType.themeChange:
          await AnalyticsService.logThemeChange(
            entity.params['theme_mode'] == 'dark',
          );
          break;
        case EventType.buttonClick:
          await AnalyticsService.logButtonClick(
            entity.params['button_name']?.toString() ?? 'unknown',
            additionalParams: entity.params,
          );
          break;
        case EventType.adEvent:
          await AnalyticsService.logAdEvent(
            entity.params['ad_event_type']?.toString() ?? 'unknown',
            additionalParams: entity.params,
          );
          break;
      }
    } catch (e) {
      emit(AnalyticsError('Failed to log event: ${e.toString()}'));
      return;
    }

    final result = await analyticsRepository.saveLogToSharedPrefs(entity);
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

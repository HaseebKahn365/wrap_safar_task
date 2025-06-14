import 'dart:developer';

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

    var entity = event.analyticsEntity;
    entity = entity.copyWith(isSuccess: true); // Initialize isSuccess to false

    // Log event to Firebase
    switch (entity.analyticsType) {
      case EventType.themeChange:
        try {
          await AnalyticsService.logThemeChange(
            entity.params['theme_mode'] == 'dark',
          );
        } catch (e) {
          log('❌ Firebase Analytics: Failed to log theme change - $e');
          entity = entity.copyWith(isSuccess: false);
        }
        break;
      case EventType.buttonClick:
        try {
          await AnalyticsService.logButtonClick(
            entity.params['button_name']?.toString() ?? 'unknown',
            additionalParams: entity.params,
          );
        } catch (e) {
          log('❌ Firebase Analytics: Failed to log button click - $e');
          entity = entity.copyWith(isSuccess: false);
        }
        break;
      case EventType.adEvent:
        try {
          await AnalyticsService.logAdEvent(
            entity.params['ad_event_type']?.toString() ?? 'unknown',
            additionalParams: entity.params,
          );
        } catch (e) {
          log('❌ Firebase Analytics: Failed to log ad event - $e');
          entity = entity.copyWith(isSuccess: false);
        }
        break;
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

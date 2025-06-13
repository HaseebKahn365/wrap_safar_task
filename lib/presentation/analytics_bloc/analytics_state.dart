import 'package:equatable/equatable.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  final List<AnaylticsEntity> logs;
  const AnalyticsLoaded(this.logs);

  @override
  List<Object?> get props => [logs];
}

class AnalyticsError extends AnalyticsState {
  final String message;
  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalyticsLogSaved extends AnalyticsState {
  const AnalyticsLogSaved();
}

class AnalyticsLogsDeleted extends AnalyticsState {
  const AnalyticsLogsDeleted();
}

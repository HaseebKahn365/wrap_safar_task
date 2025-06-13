import 'package:equatable/equatable.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsLogsEvent extends AnalyticsEvent {
  const LoadAnalyticsLogsEvent();
}

class SaveAnalyticsLogEvent extends AnalyticsEvent {
  final AnalyticsEntity analyticsEntity;
  const SaveAnalyticsLogEvent(this.analyticsEntity);

  @override
  List<Object?> get props => [analyticsEntity];
}

class DeleteAllAnalyticsLogsEvent extends AnalyticsEvent {
  const DeleteAllAnalyticsLogsEvent();
}

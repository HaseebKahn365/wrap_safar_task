/*

Purpose of the wrap_safar_task app:
store username, number of ads viewed and score in the user entity
store the type of event, success/fail status, additional infromation in the AnalyticsEntity */

import 'package:equatable/equatable.dart';

enum EventType { themeChange, buttonClick, adEvent }

class AnalyticsEntity extends Equatable {
  final EventType analyticsType;
  final Map<String, Object> params;
  final bool? isSuccess;

  const AnalyticsEntity({
    required this.analyticsType,
    required this.params,
    this.isSuccess = false,
  });

  //copy with
  AnalyticsEntity copyWith({
    EventType? analyticsType,
    Map<String, Object>? params,
    bool? isSuccess,
  }) {
    return AnalyticsEntity(
      analyticsType: analyticsType ?? this.analyticsType,
      params: params ?? this.params,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [analyticsType, params, isSuccess];
}

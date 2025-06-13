/*
/*

Purpose of the wrap_safar_task app:
store username, number of ads viewed and score in the user entity
store the type of event, success/fail status, additional infromation in the AnalyticsEntity */

import 'package:equatable/equatable.dart';

enum EventType { themeChange, buttonClick, adEvent }

/*


 */

class AnaylticsEntity extends Equatable {
  final EventType analyticsType;
  final Map<String, Object> params;
  final bool isSuccess;

  const AnaylticsEntity({
    required this.analyticsType,
    required this.params,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [analyticsType, params, isSuccess];
}

 */

//we should store the analytics enitity in the following manner:

/*
each analytics enitity will have a unique id assigned to it using uuid v4 
the keys will be stored separately in the shared preferences under List<String> keys called analyticsKeys
each analytics entity will be stored in the shared preferences as a json string with the key being the unique id

while retrieving the analytics entities, we will first retrieve the keys from the shared preferences and then retrieve each entity using the key

 */

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';

class AnalyticsModel extends Equatable {
  final String id;
  final EventType analyticsType;
  final Map<String, Object> params;
  final bool isSuccess;

  AnalyticsModel({
    required this.analyticsType,
    required this.params,
    required this.isSuccess,
    String? id,
  }) : id = id ?? const Uuid().v4();

  @override
  List<Object?> get props => [id, analyticsType, params, isSuccess];

  Map<String, dynamic> toJson() => {
    'id': id,
    'analyticsType': analyticsType.toString(),
    'params': params,
    'isSuccess': isSuccess,
  };

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      id: json['id'] as String,
      analyticsType: EventType.values.firstWhere(
        (e) => e.toString() == json['analyticsType'],
      ),
      params: Map<String, Object>.from(json['params'] as Map),
      isSuccess: json['isSuccess'] as bool,
    );
  }
}

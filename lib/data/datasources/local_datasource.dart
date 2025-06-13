/*


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

*/

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrap_safar_task/data/models/analytics_model.dart';
import 'package:wrap_safar_task/data/models/user_model.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';

// Local DataSource Implementation
abstract class LocalDataSource {
  // User Model Operations
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser();

  // Analytics Model Operations
  Future<void> saveAnalytics(AnalyticsModel analytics);
  Future<List<AnalyticsModel>> getAllAnalytics();
  Future<AnalyticsModel?> getAnalyticsById(String id);
  Future<void> deleteAnalytics(String id);
  Future<void> deleteAllAnalytics();
  Future<List<AnalyticsModel>> getAnalyticsByType(EventType eventType);
}

class LocalDataSourceImpl implements LocalDataSource {
  static const String _userKey = 'user_data';
  static const String _analyticsKeysKey = 'analytics_keys';

  final SharedPreferences _prefs;

  LocalDataSourceImpl(this._prefs);

  // User Model Operations
  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  @override
  Future<void> deleteUser() async {
    await _prefs.remove(_userKey);
  }

  // Analytics Model Operations
  @override
  Future<void> saveAnalytics(AnalyticsModel analytics) async {
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    keys.add(analytics.id);

    await _prefs.setString(analytics.id, jsonEncode(analytics.toJson()));
    await _prefs.setStringList(_analyticsKeysKey, keys);
  }

  @override
  Future<List<AnalyticsModel>> getAllAnalytics() async {
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    List<AnalyticsModel> analytics = [];

    for (String key in keys) {
      String? analyticsJson = _prefs.getString(key);
      if (analyticsJson != null) {
        try {
          analytics.add(AnalyticsModel.fromJson(jsonDecode(analyticsJson)));
        } catch (e) {
          continue;
        }
      }
    }
    return analytics;
  }

  @override
  Future<AnalyticsModel?> getAnalyticsById(String id) async {
    final analyticsJson = _prefs.getString(id);
    if (analyticsJson == null) return null;

    try {
      return AnalyticsModel.fromJson(jsonDecode(analyticsJson));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteAnalytics(String id) async {
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    keys.remove(id);

    await _prefs.remove(id);
    await _prefs.setStringList(_analyticsKeysKey, keys);
  }

  @override
  Future<void> deleteAllAnalytics() async {
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    for (String key in keys) {
      await _prefs.remove(key);
    }
    await _prefs.remove(_analyticsKeysKey);
  }

  @override
  Future<List<AnalyticsModel>> getAnalyticsByType(EventType eventType) async {
    final allAnalytics = await getAllAnalytics();
    return allAnalytics
        .where((analytics) => analytics.analyticsType == eventType)
        .toList();
  }
}

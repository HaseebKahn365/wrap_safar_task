import 'dart:convert';
import 'dart:developer';

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

  @override
  Future<void> saveUser(UserModel user) async {
    log('Saving user to local storage: ${user.toString()}');
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
    log('User saved successfully');
  }

  @override
  Future<UserModel?> getUser() async {
    log('Fetching user from local storage');
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) {
      log('No user found in local storage');
      return null;
    }

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);
      log('User retrieved successfully: ${user.toString()}');
      return user;
    } catch (e) {
      log('Error retrieving user: $e');
      return null;
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    log('Updating user in local storage: ${user.toString()}');
    await saveUser(user);
    log('User updated successfully');
  }

  @override
  Future<void> deleteUser() async {
    log('Deleting user from local storage');
    await _prefs.remove(_userKey);
    log('User deleted successfully');
  }

  @override
  Future<void> saveAnalytics(AnalyticsModel analytics) async {
    log('Saving analytics: ${analytics.toString()}');
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    keys.add(analytics.id);

    await _prefs.setString(analytics.id, jsonEncode(analytics.toJson()));
    await _prefs.setStringList(_analyticsKeysKey, keys);
    log('Analytics saved successfully');
  }

  @override
  Future<List<AnalyticsModel>> getAllAnalytics() async {
    log('Fetching all analytics');
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    List<AnalyticsModel> analytics = [];

    for (String key in keys) {
      String? analyticsJson = _prefs.getString(key);
      if (analyticsJson != null) {
        try {
          analytics.add(AnalyticsModel.fromJson(jsonDecode(analyticsJson)));
        } catch (e) {
          log('Error parsing analytics with key $key: $e');
          continue;
        }
      }
    }
    log('Retrieved ${analytics.length} analytics records');
    return analytics;
  }

  @override
  Future<AnalyticsModel?> getAnalyticsById(String id) async {
    log('Fetching analytics with id: $id');
    final analyticsJson = _prefs.getString(id);
    if (analyticsJson == null) {
      log('No analytics found with id: $id');
      return null;
    }

    try {
      final analytics = AnalyticsModel.fromJson(jsonDecode(analyticsJson));
      log('Analytics retrieved successfully: ${analytics.toString()}');
      return analytics;
    } catch (e) {
      log('Error retrieving analytics: $e');
      return null;
    }
  }

  @override
  Future<void> deleteAnalytics(String id) async {
    log('Deleting analytics with id: $id');
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    keys.remove(id);

    await _prefs.remove(id);
    await _prefs.setStringList(_analyticsKeysKey, keys);
    log('Analytics deleted successfully');
  }

  @override
  Future<void> deleteAllAnalytics() async {
    log('Deleting all analytics');
    List<String> keys = _prefs.getStringList(_analyticsKeysKey) ?? [];
    for (String key in keys) {
      await _prefs.remove(key);
    }
    await _prefs.remove(_analyticsKeysKey);
    log('All analytics deleted successfully');
  }

  @override
  Future<List<AnalyticsModel>> getAnalyticsByType(EventType eventType) async {
    log('Fetching analytics by type: $eventType');
    final allAnalytics = await getAllAnalytics();
    final filteredAnalytics =
        allAnalytics
            .where((analytics) => analytics.analyticsType == eventType)
            .toList();
    log(
      'Found ${filteredAnalytics.length} analytics records for type $eventType',
    );
    return filteredAnalytics;
  }
}

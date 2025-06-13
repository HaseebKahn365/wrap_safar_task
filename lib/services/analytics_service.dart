import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  static Future<void> logThemeChange(bool isDarkMode) async {
    try {
      await _analytics.logEvent(
        name: 'theme_change',
        parameters: <String, Object>{
          'theme_mode': isDarkMode ? 'dark' : 'light',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      log(
        '✅ Firebase Analytics: Theme change logged successfully - ${isDarkMode ? 'Dark' : 'Light'} mode',
      );
    } catch (e) {
      log('❌ Firebase Analytics: Failed to log theme change - $e');
    }
  }

  static Future<void> logButtonClick(
    String buttonName, {
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      Map<String, Object> params = <String, Object>{
        'button_name': buttonName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      if (additionalParams != null) {
        additionalParams.forEach((key, value) {
          params[key] = value;
        });
      }

      await _analytics.logEvent(name: 'button_click', parameters: params);
      log(
        '✅ Firebase Analytics: Button click logged successfully - $buttonName',
      );
    } catch (e) {
      log('❌ Firebase Analytics: Failed to log button click - $e');
    }
  }

  static Future<void> logAdEvent(
    String eventType, {
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      Map<String, Object> params = <String, Object>{
        'ad_event_type': eventType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      if (additionalParams != null) {
        additionalParams.forEach((key, value) {
          params[key] = value;
        });
      }

      await _analytics.logEvent(name: 'ad_interaction', parameters: params);
      log('✅ Firebase Analytics: Ad event logged successfully - $eventType');
    } catch (e) {
      log('❌ Firebase Analytics: Failed to log ad event - $e');
    }
  }

  // Enable debug mode to view events in real-time (development only)
  static Future<void> enableDebugMode() async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(true);
      log(
        '✅ Firebase Analytics: Debug mode enabled - check logcat for real-time events',
      );
    } catch (e) {
      log('❌ Firebase Analytics: Failed to enable debug mode - $e');
    }
  }

  // Log a custom debug event to test if analytics is working
  static Future<void> logDebugEvent() async {
    try {
      await _analytics.logEvent(
        name: 'debug_test_event',
        parameters: <String, Object>{
          'test_parameter': 'debug_value',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      log('✅ Firebase Analytics: Debug test event logged successfully');
    } catch (e) {
      log('❌ Firebase Analytics: Failed to log debug event - $e');
    }
  }

  // Reset analytics data (for testing purposes)
  static Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
      log('✅ Firebase Analytics: Analytics data reset successfully');
    } catch (e) {
      log('❌ Firebase Analytics: Failed to reset analytics data - $e');
    }
  }
}

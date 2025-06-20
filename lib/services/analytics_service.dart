import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  static Future<void> logThemeChange(bool isDarkMode) async {
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
  }

  static Future<void> logButtonClick(
    String buttonName, {
    Map<String, dynamic>? additionalParams,
  }) async {
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
    log('✅ Firebase Analytics: Button click logged successfully - $buttonName');
  }

  static Future<void> logAdEvent(
    String eventType, {
    Map<String, dynamic>? additionalParams,
  }) async {
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
  }

  // Enable debug mode to view events in real-time (development only)
  static Future<void> enableDebugMode() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    log(
      '✅ Firebase Analytics: Debug mode enabled - check logcat for real-time events',
    );
  }

  // Log a custom debug event to test if analytics is working
  static Future<void> logDebugEvent() async {
    await _analytics.logEvent(
      name: 'debug_test_event',
      parameters: <String, Object>{
        'test_parameter': 'debug_value',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    log('✅ Firebase Analytics: Debug test event logged successfully');
  }
}

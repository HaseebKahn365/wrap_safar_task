class SharedPreferenceAnalyticsSavingException implements Exception {
  final String message;

  SharedPreferenceAnalyticsSavingException(this.message);

  @override
  String toString() => 'SharedPreferenceAnalyticsSavingException: $message';
}

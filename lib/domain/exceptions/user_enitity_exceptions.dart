class SharedPreferenceUserSavingException implements Exception {
  final String message;

  SharedPreferenceUserSavingException(this.message);

  @override
  String toString() => 'SharedPreferenceUserSavingException: $message';
}

// store the type of event, success/fail status, additional infromation in the AnalyticsEntity

import 'package:equatable/equatable.dart';

abstract class AnalyticsEntityLoggingFailure extends Equatable {
  final String message;

  const AnalyticsEntityLoggingFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AnalyticsEntityThemeChangeLoggingFailure
    extends AnalyticsEntityLoggingFailure {
  const AnalyticsEntityThemeChangeLoggingFailure(super.message);

  @override
  String toString() => 'AnalyticsEntityLoggingThemeChangeFailure: $message';
}

class AnalyticsEntityLoggingButtonClickFailure
    extends AnalyticsEntityLoggingFailure {
  const AnalyticsEntityLoggingButtonClickFailure(super.message);

  @override
  String toString() => 'AnalyticsEntityLoggingButtonClickFailure: $message';
}

class AnalyticsEntityAdEventLoggingFailure
    extends AnalyticsEntityLoggingFailure {
  const AnalyticsEntityAdEventLoggingFailure(super.message);

  @override
  String toString() => 'AnalyticsEntityAdEventLoggingFailure: $message';
}

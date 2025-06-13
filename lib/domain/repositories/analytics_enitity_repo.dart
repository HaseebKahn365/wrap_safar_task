import 'package:dartz/dartz.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';
import 'package:wrap_safar_task/domain/failures/analytics_entity_failures.dart';

abstract class AnalyticsEnitityRepo {
  Future<Either<AnalyticsEntityLoggingFailure, List<AnalyticsEntity>>>
  getAllLogsFromSharedPrefs();
  Future<Either<AnalyticsEntityLoggingFailure, void>> saveLogToSharedPrefs(
    AnalyticsEntity anaylticsEntity,
  );
  Future<Either<AnalyticsEntityLoggingFailure, void>>
  deleteAllLogsFromSharedPrefs();
}

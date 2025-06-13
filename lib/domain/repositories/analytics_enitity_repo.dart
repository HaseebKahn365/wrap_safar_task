import 'package:dartz/dartz.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';
import 'package:wrap_safar_task/domain/failures/analytics_entity_failures.dart';

abstract class AnalyticsEnitityRepo {
  Future<Either<AnalyticsEntityLoggingFailure, List<AnaylticsEntity>>>
  getAllLogsFromSharedPrefs();
  Future<Either<AnalyticsEntityLoggingFailure, void>> saveLogToSharedPrefs(
    AnaylticsEntity anaylticsEntity,
  );
  Future<Either<AnalyticsEntityLoggingFailure, void>>
  deleteAllLogsFromSharedPrefs();
}

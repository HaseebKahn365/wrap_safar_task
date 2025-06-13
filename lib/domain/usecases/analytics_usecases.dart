/*
abstract class AnalyticsEnitityRepo {
  Future<Either<AnalyticsEntityLoggingFailure, List<AnaylticsEntity>>>
  getAllLogsFromSharedPrefs();
  Future<Either<AnalyticsEntityLoggingFailure, void>> saveLogToSharedPrefs(
    AnaylticsEntity anaylticsEntity,
  );
  Future<Either<AnalyticsEntityLoggingFailure, void>>
  deleteAllLogsFromSharedPrefs();
}

 */

import 'package:dartz/dartz.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';
import 'package:wrap_safar_task/domain/failures/analytics_entity_failures.dart';
import 'package:wrap_safar_task/domain/repositories/analytics_enitity_repo.dart';

class GetAllLogsUseCase {
  final AnalyticsEnitityRepo repository;

  GetAllLogsUseCase(this.repository);

  Future<Either<AnalyticsEntityLoggingFailure, List<AnaylticsEntity>>>
  execute() {
    return repository.getAllLogsFromSharedPrefs();
  }
}

class SaveLogUseCase {
  final AnalyticsEnitityRepo repository;

  SaveLogUseCase(this.repository);

  Future<Either<AnalyticsEntityLoggingFailure, void>> execute(
    AnaylticsEntity anaylticsEntity,
  ) {
    return repository.saveLogToSharedPrefs(anaylticsEntity);
  }
}

class DeleteAllLogsUseCase {
  final AnalyticsEnitityRepo repository;

  DeleteAllLogsUseCase(this.repository);

  Future<Either<AnalyticsEntityLoggingFailure, void>> execute() {
    return repository.deleteAllLogsFromSharedPrefs();
  }
}

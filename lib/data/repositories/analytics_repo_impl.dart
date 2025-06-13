import 'package:dartz/dartz.dart';
import 'package:wrap_safar_task/data/datasources/local_datasource.dart';
import 'package:wrap_safar_task/data/models/analytics_model.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';
import 'package:wrap_safar_task/domain/failures/analytics_entity_failures.dart';
import 'package:wrap_safar_task/domain/repositories/analytics_enitity_repo.dart';

class AnalyticsRepoImpl implements AnalyticsEnitityRepo {
  final LocalDataSource localDataSource;

  AnalyticsRepoImpl({required this.localDataSource});

  @override
  Future<Either<AnalyticsEntityLoggingFailure, List<AnaylticsEntity>>>
  getAllLogsFromSharedPrefs() async {
    try {
      final analyticsModels = await localDataSource.getAllAnalytics();

      final analyticsEntities =
          analyticsModels
              .map(
                (model) => AnaylticsEntity(
                  analyticsType: model.analyticsType,
                  params: model.params,
                  isSuccess: model.isSuccess,
                ),
              )
              .toList();

      return Right(analyticsEntities);
    } catch (e) {
      return Left(
        AnalyticsEntityThemeChangeLoggingFailure(
          'Failed to retrieve analytics logs: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<AnalyticsEntityLoggingFailure, void>> saveLogToSharedPrefs(
    AnaylticsEntity anaylticsEntity,
  ) async {
    try {
      final analyticsModel = AnalyticsModel(
        analyticsType: anaylticsEntity.analyticsType,
        params: anaylticsEntity.params,
        isSuccess: anaylticsEntity.isSuccess,
      );

      await localDataSource.saveAnalytics(analyticsModel);
      return const Right(null);
    } catch (e) {
      // Return appropriate failure type based on event type
      switch (anaylticsEntity.analyticsType) {
        case EventType.themeChange:
          return Left(
            AnalyticsEntityThemeChangeLoggingFailure(
              'Failed to save theme change log: ${e.toString()}',
            ),
          );
        case EventType.buttonClick:
          return Left(
            AnalyticsEntityLoggingButtonClickFailure(
              'Failed to save button click log: ${e.toString()}',
            ),
          );
        case EventType.adEvent:
          return Left(
            AnalyticsEntityAdEventLoggingFailure(
              'Failed to save ad event log: ${e.toString()}',
            ),
          );
      }
    }
  }

  @override
  Future<Either<AnalyticsEntityLoggingFailure, void>>
  deleteAllLogsFromSharedPrefs() async {
    try {
      await localDataSource.deleteAllAnalytics();
      return const Right(null);
    } catch (e) {
      return Left(
        AnalyticsEntityThemeChangeLoggingFailure(
          'Failed to delete all analytics logs: ${e.toString()}',
        ),
      );
    }
  }
}

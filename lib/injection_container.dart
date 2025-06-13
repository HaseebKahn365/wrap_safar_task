import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrap_safar_task/data/datasources/local_datasource.dart';
import 'package:wrap_safar_task/data/repositories/analytics_repo_impl.dart';
import 'package:wrap_safar_task/data/repositories/user_repo_impl.dart';
import 'package:wrap_safar_task/domain/repositories/analytics_enitity_repo.dart';
import 'package:wrap_safar_task/domain/repositories/user_entity_repo.dart';
import 'package:wrap_safar_task/domain/usecases/user_usecases.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:wrap_safar_task/presentation/blocs/user_bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<UserEnitityRepo>(
    () => UserRepoImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<AnalyticsEnitityRepo>(
    () => AnalyticsRepoImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserInfoFromSharedPrefsUseCase(sl()));
  sl.registerLazySingleton(() => SaveUserInfoToSharedPrefsUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => UserBloc(getUserInfoUseCase: sl(), saveUserInfoUseCase: sl()),
  );
  sl.registerFactory(() => AnalyticsBloc(analyticsRepository: sl()));
}

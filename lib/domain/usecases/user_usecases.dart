/*
abstract class UserEnitityRepo {
  Future<Either<UserEntityFailure, void>> saveUserInfoToSharedPrefs(
    String userName,
    int adsViewed,
    int score,
  );
  Future<Either<UserEntityFailure, Map<String, dynamic>>>
  getUserInfoFromSharedPrefs();
  
}


 */

import 'package:dartz/dartz.dart';
import 'package:wrap_safar_task/domain/failures/user_entity_failures.dart';
import 'package:wrap_safar_task/domain/repositories/user_entity_repo.dart';

class SaveUserInfoToSharedPrefsUseCase {
  final UserEnitityRepo repository;

  SaveUserInfoToSharedPrefsUseCase(this.repository);

  Future<Either<UserEntityFailure, void>> call(
    String userName,
    int adsViewed,
    int score,
  ) async {
    return await repository.saveUserInfoToSharedPrefs(
      userName,
      adsViewed,
      score,
    );
  }
}

class GetUserInfoFromSharedPrefsUseCase {
  final UserEnitityRepo repository;

  GetUserInfoFromSharedPrefsUseCase(this.repository);

  Future<Either<UserEntityFailure, Map<String, dynamic>>> call() async {
    return await repository.getUserInfoFromSharedPrefs();
  }
}

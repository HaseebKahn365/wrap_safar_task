/*
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
import 'package:wrap_safar_task/domain/entities/user_entitiy.dart';
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

  Future<Either<UserEntityFailure, UserEntitiy>> call() async {
    return await repository.getUserInfoFromSharedPrefs();
  }
}

 */

import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserInfoRequestedEvent extends UserEvent {
  const UserInfoRequestedEvent();

  @override
  List<Object?> get props => [];
}

class UserInfoSaveEvent extends UserEvent {
  final String userName;
  final int adsViewed;
  final int score;

  const UserInfoSaveEvent({
    required this.userName,
    required this.adsViewed,
    required this.score,
  });

  @override
  List<Object?> get props => [userName, adsViewed, score];
}

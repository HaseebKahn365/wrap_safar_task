import 'package:dartz/dartz.dart';
import 'package:wrap_safar_task/domain/entities/user_entitiy.dart';
import 'package:wrap_safar_task/domain/failures/user_entity_failures.dart';

/*
abstract class UserEntityFailure extends Equatable {
  final String message;
  const UserEntityFailure(this.message);

  @override
  List<Object> get props => [message];
}

class UserInfoSaveFailure extends UserEntityFailure {
  const UserInfoSaveFailure(super.message);
}

class UserInfoFetchFailure extends UserEntityFailure {
  const UserInfoFetchFailure(super.message);
}

 */

abstract class UserEnitityRepo {
  Future<Either<UserEntityFailure, void>> saveUserInfoToSharedPrefs(
    String userName,
    int adsViewed,
    int score,
  );
  Future<Either<UserEntityFailure, UserEntitiy>> getUserInfoFromSharedPrefs();
}

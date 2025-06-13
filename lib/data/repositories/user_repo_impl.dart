import 'package:dartz/dartz.dart';
import 'package:wrap_safar_task/data/datasources/local_datasource.dart';
import 'package:wrap_safar_task/data/models/user_model.dart';
import 'package:wrap_safar_task/domain/entities/user_entitiy.dart';
import 'package:wrap_safar_task/domain/failures/user_entity_failures.dart';
import 'package:wrap_safar_task/domain/repositories/user_entity_repo.dart';

class UserRepoImpl implements UserEnitityRepo {
  final LocalDataSource localDataSource;

  UserRepoImpl({required this.localDataSource});

  @override
  Future<Either<UserEntityFailure, void>> saveUserInfoToSharedPrefs(
    String userName,
    int adsViewed,
    int score,
  ) async {
    try {
      final userModel = UserModel(
        userName: userName,
        adsViewed: adsViewed,
        score: score,
      );

      await localDataSource.saveUser(userModel);
      return const Right(null);
    } catch (e) {
      return Left(
        UserInfoSaveFailure('Failed to save user info: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<UserEntityFailure, UserEntitiy>>
  getUserInfoFromSharedPrefs() async {
    try {
      final userModel = await localDataSource.getUser();

      if (userModel == null) {
        return const Left(UserInfoFetchFailure('No user data found'));
      }

      return Right(userModel.toEntity());
    } catch (e) {
      return Left(
        UserInfoFetchFailure('Failed to fetch user info: ${e.toString()}'),
      );
    }
  }

  // Additional helper methods for better functionality
  Future<Either<UserEntityFailure, void>> updateUserInfo(
    String userName,
    int adsViewed,
    int score,
  ) async {
    try {
      final userModel = UserModel(
        userName: userName,
        adsViewed: adsViewed,
        score: score,
      );

      await localDataSource.updateUser(userModel);
      return const Right(null);
    } catch (e) {
      return Left(
        UserInfoSaveFailure('Failed to update user info: ${e.toString()}'),
      );
    }
  }

  Future<Either<UserEntityFailure, void>> deleteUserInfo() async {
    try {
      await localDataSource.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left(
        UserInfoSaveFailure('Failed to delete user info: ${e.toString()}'),
      );
    }
  }

  Future<Either<UserEntityFailure, void>> incrementAdsViewed() async {
    try {
      final userModel = await localDataSource.getUser();

      if (userModel == null) {
        return const Left(UserInfoFetchFailure('No user data found to update'));
      }

      final updatedUser = UserModel(
        userName: userModel.userName,
        adsViewed: userModel.adsViewed + 1,
        score: userModel.score,
      );

      await localDataSource.updateUser(updatedUser);
      return const Right(null);
    } catch (e) {
      return Left(
        UserInfoSaveFailure('Failed to increment ads viewed: ${e.toString()}'),
      );
    }
  }

  Future<Either<UserEntityFailure, void>> updateScore(int newScore) async {
    try {
      final userModel = await localDataSource.getUser();

      if (userModel == null) {
        return const Left(UserInfoFetchFailure('No user data found to update'));
      }

      final updatedUser = UserModel(
        userName: userModel.userName,
        adsViewed: userModel.adsViewed,
        score: newScore,
      );

      await localDataSource.updateUser(updatedUser);
      return const Right(null);
    } catch (e) {
      return Left(
        UserInfoSaveFailure('Failed to update score: ${e.toString()}'),
      );
    }
  }

  Future<Either<UserEntityFailure, UserModel>> getUserModel() async {
    try {
      final userModel = await localDataSource.getUser();

      if (userModel == null) {
        return const Left(UserInfoFetchFailure('No user data found'));
      }

      return Right(userModel);
    } catch (e) {
      return Left(
        UserInfoFetchFailure('Failed to fetch user model: ${e.toString()}'),
      );
    }
  }
}

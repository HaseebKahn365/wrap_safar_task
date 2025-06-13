/*//only three states ie user loading, user loaded and user error

import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final String userName;
  final int adsViewed;
  final int score;

  const UserLoaded({
    required this.userName,
    required this.adsViewed,
    required this.score,
  });

  @override
  List<Object?> get props => [userName, adsViewed, score];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}


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

 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wrap_safar_task/domain/usecases/user_usecases.dart';
import 'package:wrap_safar_task/presentation/user_bloc/user_event.dart';
import 'package:wrap_safar_task/presentation/user_bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserInfoFromSharedPrefsUseCase getUserInfoUseCase;
  final SaveUserInfoToSharedPrefsUseCase saveUserInfoUseCase;

  UserBloc({
    required this.getUserInfoUseCase,
    required this.saveUserInfoUseCase,
  }) : super(const UserLoading()) {
    on<UserInfoRequestedEvent>(_onUserInfoRequested);
    on<UserInfoSaveEvent>(_onUserInfoSave);
  }

  void _onUserInfoRequested(
    UserInfoRequestedEvent event,
    Emitter<UserState> emit,
  ) async {
    final userResult = await getUserInfoUseCase();
    emit(
      userResult.fold(
        (failure) => UserError(message: failure.message),
        (user) => UserLoaded(
          userName: user.userName,
          adsViewed: user.adsViewed,
          score: user.score,
        ),
      ),
    );
  }

  void _onUserInfoSave(UserInfoSaveEvent event, Emitter<UserState> emit) async {
    final saveResult = await saveUserInfoUseCase(
      event.userName,
      event.adsViewed,
      event.score,
    );
    emit(
      saveResult.fold(
        (failure) => UserError(message: failure.message),
        (_) => const UserLoading(),
      ),
    );
  }
}

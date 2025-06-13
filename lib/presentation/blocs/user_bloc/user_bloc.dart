import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wrap_safar_task/domain/usecases/user_usecases.dart';
import 'package:wrap_safar_task/presentation/blocs/user_bloc/user_event.dart';
import 'package:wrap_safar_task/presentation/blocs/user_bloc/user_state.dart';

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
    log('Requesting save for user infromation');
    final userResult = await getUserInfoUseCase();
    emit(
      userResult.fold(
        (failure) => UserError(message: failure.message),
        (user) => UserLoaded(user: user),
      ),
    );
  }

  void _onUserInfoSave(UserInfoSaveEvent event, Emitter<UserState> emit) async {
    // Emit loading state before starting the save operation
    emit(const UserLoading());
    final saveResult = await saveUserInfoUseCase(
      event.userName,
      event.adsViewed,
      event.score,
    );

    await saveResult.fold(
      (failure) async => emit(UserError(message: failure.message)),
      (_) async {
        // After successful save, refetch the user info to get the updated state
        final userResult = await getUserInfoUseCase();
        emit(
          userResult.fold(
            (failure) => UserError(
              message: failure.message,
            ), // Handle error during refetch
            (user) =>
                UserLoaded(user: user), // Emit UserLoaded with updated info
          ),
        );
      },
    );
  }
}

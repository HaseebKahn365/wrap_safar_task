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
    final userResult = await getUserInfoUseCase();
    emit(
      userResult.fold(
        (failure) => UserError(message: failure.message),
        (user) => UserLoaded(user: user),
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

//only three states ie user loading, user loaded and user error

import 'package:equatable/equatable.dart';
import 'package:wrap_safar_task/domain/entities/user_entitiy.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final UserEntitiy user;

  const UserLoaded({required this.user});
  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}

//only three states ie user loading, user loaded and user error

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

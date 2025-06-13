//the data is gonna be save in the shared preferences so lets log the associated failure

import 'package:equatable/equatable.dart';

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

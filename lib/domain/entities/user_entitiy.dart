import 'package:equatable/equatable.dart';

/*

Purpose of the wrap_safar_task app:
store username, number of ads viewed and score in the user entity
store the type of event, success/fail status, additional infromation in the AnalyticsEntity */
class UserEntitiy extends Equatable {
  final String userName;
  final int adsViewed;
  final int score;

  const UserEntitiy({
    required this.userName,
    required this.adsViewed,
    required this.score,
  });

  @override
  List<Object?> get props => [userName, adsViewed, score];

  //copy with
  UserEntitiy copyWith({String? userName, int? adsViewed, int? score}) {
    return UserEntitiy(
      userName: userName ?? this.userName,
      adsViewed: adsViewed ?? this.adsViewed,
      score: score ?? this.score,
    );
  }
}

import 'package:equatable/equatable.dart';

/*

Purpose of the wrap_safar_task app:
store username, number of ads viewed and score in the user entity
store the type of event, success/fail status, additional infromation in the AnalyticsEntity */
// class UserEntitiy extends Equatable {
//   final String userName;
//   final int adsViewed;
//   final int score;

//   const UserEntitiy({
//     required this.userName,
//     required this.adsViewed,
//     required this.score,
//   });

//   @override
//   List<Object?> get props => [userName, adsViewed, score];
// }

//the above info should be properly stored and retrived from the shared preferences so we need to properly create a model class

class UserModel extends Equatable {
  final String userName;
  final int adsViewed;
  final int score;

  const UserModel({
    required this.userName,
    required this.adsViewed,
    required this.score,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'] as String,
      adsViewed: json['adsViewed'] as int,
      score: json['score'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userName': userName, 'adsViewed': adsViewed, 'score': score};
  }

  @override
  List<Object?> get props => [userName, adsViewed, score];
}

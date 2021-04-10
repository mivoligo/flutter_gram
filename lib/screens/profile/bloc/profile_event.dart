part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileLoadUser extends ProfileEvent {
  ProfileLoadUser({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

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

class ProfileToggleGridView extends ProfileEvent {
  ProfileToggleGridView({required this.isGridView});

  final bool isGridView;

  @override
  List<Object?> get props => [isGridView];
}

class ProfileUpdatePosts extends ProfileEvent {
  ProfileUpdatePosts({required this.posts});

  final List<Post?> posts;

  @override
  List<Object?> get props => [posts];
}

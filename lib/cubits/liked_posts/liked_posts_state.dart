part of 'liked_posts_cubit.dart';

class LikedPostsState extends Equatable {
  const LikedPostsState({
    required this.likedPostIds,
    required this.recentlyLikedPostIds,
  });

  factory LikedPostsState.initial() {
    return const LikedPostsState(likedPostIds: {}, recentlyLikedPostIds: {});
  }

  final Set<String> likedPostIds;
  final Set<String> recentlyLikedPostIds;

  LikedPostsState copyWith({
    Set<String>? likedPostIds,
    Set<String>? recentlyLikedPostIds,
  }) {
    return LikedPostsState(
      likedPostIds: likedPostIds ?? this.likedPostIds,
      recentlyLikedPostIds: recentlyLikedPostIds ?? this.recentlyLikedPostIds,
    );
  }

  @override
  List<Object> get props => [likedPostIds, recentlyLikedPostIds];
}

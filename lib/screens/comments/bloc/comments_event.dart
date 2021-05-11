part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();
}

class CommentsFetchComments extends CommentsEvent {
  const CommentsFetchComments({required this.post});

  final Post post;

  @override
  List<Object?> get props => [post];
}

class CommentsUpdateComments extends CommentsEvent {
  const CommentsUpdateComments({required this.comments});

  final List<Comment?> comments;

  @override
  List<Object?> get props => [comments];
}

class CommentsPostComment extends CommentsEvent {
  const CommentsPostComment({required this.content});

  final String content;

  @override
  List<Object?> get props => [content];
}

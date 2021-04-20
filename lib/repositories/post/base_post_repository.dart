import '../../models/models.dart';

abstract class BasePostRepository {
  Future<void> createPost({required Post post});

  Future<void> createComment({required Comment comment});

  Stream<List<Future<Post>>> getUserPosts({required String userId});

  Stream<List<Future<Comment>>> getUserComments({required String userId});
}

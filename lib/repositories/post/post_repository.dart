import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/paths.dart';
import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../repositories.dart';

class PostRepository extends BasePostRepository {
  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  @override
  void createLike({required Post post, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update({"likes": FieldValue.increment(1)});
    _firebaseFirestore
        .collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});
  }

  @override
  Future<void> createComment({required Comment comment}) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument());
  }

  @override
  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Post.fromDocument).toList());
  }

  @override
  Stream<List<Future<Comment?>>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Comment.fromDocument).toList());
  }

  @override
  Future<List<Post?>> getUserFeed({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
          .limit(10)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .doc(lastPostId)
          .get();
      if (!lastPostDoc.exists) {
        return [];
      }
      postsSnap = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(10)
          .get();
    }
    final posts = Future.wait(
      postsSnap.docs.map(Post.fromDocument).toList(),
    );
    return posts;
  }

  @override
  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post> posts,
  }) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();
      if (likeDoc.exists) {
        postIds.add(post.id!);
      }
    }
    return postIds;
  }

  @override
  void deleteLike({required String postId, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(postId)
        .update({"likes": FieldValue.increment(-1)});
    _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }
}

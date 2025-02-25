import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/posts/data/models/comments_model.dart';
import 'package:dr_fit/features/posts/domain/repo/comment_repo.dart';

class CommentRepoImp implements CommentRepo {
  final FirebaseFirestore fireBaseFireStore = FirebaseFirestore.instance;

  /// إضافة تعليق جديد إلى منشور معين.
  /// يرمي استثناء إذا فشلت العملية.
  @override
  Future<void> addComment(
      {required CommentModel comment, required String postId}) async {
    if (comment.postId.isEmpty || comment.commentId.isEmpty) {
      throw ArgumentError('Post ID and Comment ID cannot be empty');
    }
    try {
      await fireBaseFireStore
          .collection('posts')
          .doc(comment.postId)
          .collection('comments')
          .doc(comment.commentId)
          .set(comment.toJson());
    } catch (e) {
      print('Error Adding Comment: ${e.toString()}');
      throw Exception('Failed to add comment');
    }
  }

  /// حذف تعليق معين من منشور.
  /// يرمي استثناء إذا فشلت العملية.
  @override
  Future<void> deleteComment({
    required String commentId,
    required String postId,
    required String uid,
  }) async {
    if (commentId.isEmpty || postId.isEmpty) {
      throw ArgumentError('Comment ID and Post ID cannot be empty');
    }
    try {
      await fireBaseFireStore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print('Error Deleting Comment: ${e.toString()}');
      throw Exception('Failed to delete comment');
    }
  }

  /// جلب جميع التعليقات لمنشور معين، مرتبة تنازليًا حسب التاريخ.
  /// يرمي استثناء إذا فشلت العملية.
  @override
  Future<List<CommentModel>> fecthComments({required String postId}) async {
    if (postId.isEmpty) {
      throw ArgumentError('Post ID cannot be empty');
    }
    try {
      final QuerySnapshot snapshot = await fireBaseFireStore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('date',
              descending: true) // ترتيب التعليقات تنازليًا حسب التاريخ
          .get();

      return snapshot.docs.map((doc) {
        return CommentModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error Fetching Comments: ${e.toString()}');
      throw Exception('Failed to fetch comments');
    }
  }

  /// تحديث تعليق معين في منشور.
  /// يرمي استثناء إذا فشلت العملية.
  @override
  Future<void> updateComment({
    required String commentId,
    required Map<String, dynamic> updated,
    required String postId,
  }) async {
    if (commentId.isEmpty || postId.isEmpty || updated.isEmpty) {
      throw ArgumentError(
          'Comment ID, Post ID, and Updated data cannot be empty');
    }
    try {
      await fireBaseFireStore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update(updated);
    } catch (e) {
      print('Error Updating Comment: ${e.toString()}');
      throw Exception('Failed to update comment');
    }
  }
}

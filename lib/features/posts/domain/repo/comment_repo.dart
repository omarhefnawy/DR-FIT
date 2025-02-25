import 'package:dr_fit/features/posts/data/models/comments_model.dart';

abstract class CommentRepo {
  // add comment
  Future<void> addComment(
      {required String postId, required CommentModel comment});
  // deleteCommet with comment id
  Future<void> deleteComment(
      {required String commentId, required String uid, required String postId});
  // update Comment comment id and map
  Future<void> updateComment(
      {required String commentId,
      required Map<String, dynamic> updated,
      required String postId});
  //fetch comments
  Future<List<CommentModel>> fecthComments({required String postId});
}

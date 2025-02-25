import 'package:dr_fit/features/posts/data/models/comments_model.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';

abstract class PostsStates {}

// ✅ الحالة الابتدائية
class PostsInitialState extends PostsStates {}

// ✅ حالات تحميل البيانات
class PostsLoadingState extends PostsStates {}

class CommentsLoadingState extends PostsStates {}

// ✅ حالات النجاح
class PostsLoadedState extends PostsStates {
  final List<PostModel> posts;
  PostsLoadedState({required this.posts});
}

class CommentsLoadedState extends PostsStates {
  final List<CommentModel> comments;
  CommentsLoadedState({required this.comments});
}

// ✅ إضافة بوست أو تعليق بنجاح
class PostAddedState extends PostsStates {
  final PostModel post;
  PostAddedState({required this.post});
}

class CommentAddedState extends PostsStates {
  final CommentModel comment;
  CommentAddedState({required this.comment});
}

// ✅ حذف بوست أو تعليق بنجاح
class PostDeletedState extends PostsStates {
  final String postId;
  PostDeletedState({required this.postId});
}

class CommentDeletedState extends PostsStates {
  final String commentId;
  CommentDeletedState({required this.commentId});
}

// ✅ تحديث اللايكات
class PostLikeUpdatedState extends PostsStates {
  final String postId;
  final bool isLiked;
  PostLikeUpdatedState({required this.postId, required this.isLiked});
}

// ✅ حالات الفشل
class PostsFailState extends PostsStates {
  final String error;
  PostsFailState({required this.error});
}

class CommentsFailState extends PostsStates {
  final String error;
  CommentsFailState({required this.error});
}

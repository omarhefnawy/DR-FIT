import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/posts/data/models/comments_model.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/data/repo_imp/comment_repo_imp.dart';
import 'package:dr_fit/features/posts/data/repo_imp/posts_repo_imp.dart';
import 'package:dr_fit/features/posts/cubit/posts_state.dart';

class PostsCubit extends Cubit<PostsStates> {
  final PostsRepoImp postsRepoImp;
  final CommentRepoImp commentRepoImp;
  List<PostModel> posts = [];
  List<CommentModel> comments = [];

  PostsCubit({required this.commentRepoImp, required this.postsRepoImp}) : super(PostsInitialState());

  // ✅ إضافة بوست بدون إعادة تحميل البيانات كاملة
  Future<void> addPost({required PostModel post}) async {
    try {
      await postsRepoImp.addPost(model: post);
      posts.insert(0, post); // 🔥 تحديث القائمة محليًا
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ إضافة تعليق بدون تحميل جميع التعليقات
  Future<void> addComment({required CommentModel comment, required String postId}) async {
    try {
      await commentRepoImp.addComment(comment: comment, postId: postId);
      comments.insert(0, comment);
      emit(CommentsLoadedState(comments: List.from(comments)));
    } catch (e) {
      emit(CommentsFailState(error: e.toString()));
    }
  }

  // ✅ جلب كل البوستات مرة واحدة فقط
  Future<void> fetchAllPosts() async {
    emit(PostsLoadingState());
    try {
      posts = await postsRepoImp.fetchAllPosts();
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ جلب بوستات مستخدم معين فقط
  Future<void> fetchUserPosts({required String uid}) async {
    emit(PostsLoadingState());
    try {
      posts = await postsRepoImp.fetchUserPosts(uid: uid);
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ جلب التعليقات لبوست معين
  Future<void> fetchComments({required String postId}) async {
    emit(CommentsLoadingState());
    try {
      comments = await commentRepoImp.fecthComments(postId: postId);
      emit(CommentsLoadedState(comments: List.from(comments)));
    } catch (e) {
      emit(CommentsFailState(error: e.toString()));
    }
  }

  // ✅ حذف بوست بدون إعادة تحميل كل البيانات
  Future<void> deletePost({required String postId}) async {
    try {
      await postsRepoImp.deletePost(postId: postId);
      posts.removeWhere((post) => post.postId == postId);
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ تحديث بوست معين
 Future<void> updatePost({
  required String postId,
  String? newText,
  String? newImageUrl,
}) async {
  try {
    Map<String, dynamic> updatedData = {};
    if (newText != null) updatedData['post'] = newText;

    if (newImageUrl != null && newImageUrl.isNotEmpty) {
      updatedData['image'] = newImageUrl;
    } else {
      updatedData['image'] = FieldValue.delete(); // ✅ حذف الصورة من Firestore
    }

    updatedData['updatedAt'] = FieldValue.serverTimestamp();

    await postsRepoImp.updatePost(postId: postId, updatedData: updatedData);

    posts = posts.map((post) {
      if (post.postId == postId) {
        return post.copyWith(
          post: newText ?? post.post,
          image: newImageUrl, // ممكن تكون null عشان نحذفها من الواجهة كمان
        );
      }
      return post;
    }).toList();

    emit(PostsLoadedState(posts: List.from(posts)));
  } catch (e) {
    emit(PostsFailState(error: e.toString()));
  }
}


  // ✅ حذف تعليق بدون تحميل التعليقات كلها
  Future<void> deleteComment({required String uid, required String postId, required String commentId}) async {
    try {
      await commentRepoImp.deleteComment(commentId: commentId, postId: postId, uid: uid);
      comments.removeWhere((comment) => comment.commentId == commentId);
      emit(CommentsLoadedState(comments: List.from(comments)));
    } catch (e) {
      emit(CommentsFailState(error: e.toString()));
    }
  }

  // ✅ تحديث عدد اللايكات بدون تحميل البيانات
  Future<void> toggleLikes({required String postId, required String uid}) async {
    try {
      await postsRepoImp.toggleLikes(uid: uid, postId: postId);

      posts = posts.map((post) {
        if (post.postId == postId) {
          return post.copyWith(
            likes: post.likes.contains(uid)
                ? (List.from(post.likes)..remove(uid))
                : (List.from(post.likes)..add(uid)),
          );
        }
        return post;
      }).toList();

      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  Future<void> fetchPostById({required String postId}) async {
  try {
    final PostModel? updatedPost = await postsRepoImp.getPostById(postId: postId);

    if (updatedPost != null) {
      posts = posts.map((post) {
        if (post.postId == postId) {
          return updatedPost; // ✅ تحديث البوست في القائمة
        }
        return post;
      }).toList();

      emit(PostsLoadedState(posts: List.from(posts)));
    } else {
      emit(PostsFailState(error: 'المنشور غير موجود'));
    }
  } catch (e) {
    emit(PostsFailState(error: e.toString()));
  }
}





}


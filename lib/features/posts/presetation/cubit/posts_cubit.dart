import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/posts/data/models/comments_model.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/data/repo_imp/comment_repo_imp.dart';
import 'package:dr_fit/features/posts/data/repo_imp/posts_repo_imp.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_state.dart';

class PostsCubit extends Cubit<PostsStates> {
  final PostsRepoImp postsRepoImp;
  final CommentRepoImp commentRepoImp;
  List<PostModel> posts = [];
  List<CommentModel> comments = [];
  PostsCubit({required this.commentRepoImp, required this.postsRepoImp})
      : super(PostsInitialState());

  // ✅ إضافة بوست بدون تحميل البيانات من جديد
  Future<void> addPost({required PostModel post}) async {
    emit(PostsLoadingState());
    try {
      await postsRepoImp.addPost(model: post);
      posts.insert(0, post); // 🔥 تحديث القائمة محليًا
      emit(PostsLoadedState(posts: posts));
    } catch (e) {
      print('Error Adding the post: ${e.toString()}');
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ إضافة تعليق بدون تحميل كل الكومنتات من جديد
  Future<void> addComment(
      {required CommentModel comment, required String postId}) async {
    emit(CommentsLoadingState());
    try {
      await commentRepoImp.addComment(comment: comment, postId: postId);

      // تحديث التعليقات محليًا
      comments.insert(0, comment);
      //  emit(CommentsLoadedState(comments: comments));
      fetchComments(postId: postId);
      // ✅ بدلاً من إعادة تحميل جميع الـ posts، قم بتحديث الحالة فقط
      List<PostModel> updatedPosts = List.from(posts);
      emit(PostsLoadedState(posts: updatedPosts));
    } catch (e) {
      print('Error Adding comment to Post: ${e.toString()}');
      emit(CommentsFailState(error: e.toString()));
    }
  }

  // ✅ جلب كل البوستات مرة واحدة فقط
  Future<void> fetchAllPosts() async {
    emit(PostsLoadingState());
    try {
      posts = await postsRepoImp.fetchAllPosts();
      emit(PostsLoadedState(posts: posts));
    } catch (e) {
      print('Error Fetching Posts: ${e.toString()}');
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ جلب كل البوستات مرة واحدة فقط
  Future<void> fetchUserPosts({required String uid}) async {
    emit(PostsLoadingState());
    try {
      final posts = await postsRepoImp.fetchUserPosts(uid: uid);
      emit(PostsLoadedState(posts: posts));
    } catch (e) {
      print('Error Fetching user Posts: ${e.toString()}');
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ جلب كومنتات بوست معين
  Future<void> fetchComments({required String postId}) async {
    emit(CommentsLoadingState());
    try {
      comments = await commentRepoImp.fecthComments(postId: postId);
      emit(CommentsLoadedState(comments: comments));
    } catch (e) {
      print('Error Fetching post comments: ${e.toString()}');
      emit(CommentsFailState(error: e.toString())); // ✅ تصحيح الخطأ هنا
    }
  }

  // ✅ حذف بوست بدون تحميل كل البيانات مرة ثانية
  Future<void> deletePost({required String postId}) async {
    try {
      await postsRepoImp.deletePost(postId: postId);
      posts.removeWhere((post) => post.postId == postId);
      emit(PostsLoadedState(posts: posts));
    } catch (e) {
      print('Error Deleting the post: ${e.toString()}');
      emit(PostsFailState(error: e.toString()));
    }
  }
  
 Future<void> updatePost({
  required String postId,
  String? newText,
  String? newImageUrl,
}) async {
  try {
    // بناء البيانات الجديدة فقط إذا كانت موجودة
    Map<String, dynamic> updatedData = {};
    if (newText != null && newText.isNotEmpty) {
      updatedData['post'] = newText; // ✅ استخدام 'post' بدلاً من 'text'
    }
    if (newImageUrl != null && newImageUrl.isNotEmpty) {
      updatedData['image'] = newImageUrl; // ✅ استخدام 'image' بدلاً من 'imageUrl'
    }
    updatedData['updatedAt'] = FieldValue.serverTimestamp(); // 🔥 تحديث التاريخ

    if (updatedData.isEmpty) {
      print('No new data to update.');
      return;
    }

    await postsRepoImp.updatePost(postId: postId, updatedData: updatedData);

    // ✅ تحديث البوست محليًا باستخدام copyWith()
    for (int i = 0; i < posts.length; i++) {
      if (posts[i].postId == postId) {
        posts[i] = posts[i].copyWith(
          post: newText ?? posts[i].post,
          image: newImageUrl ?? posts[i].image,
        );
        break;
      }
    }

    emit(PostsLoadedState(posts: posts)); // 🔥 تحديث الواجهة مباشرة
    print('Post updated successfully.');
  } catch (e) {
    print('Error updating the post: ${e.toString()}');
    emit(PostsFailState(error: e.toString()));
  }
}



  // ✅ حذف تعليق بدون تحميل كل التعليقات
  Future<void> deleteComment(
      {required String uid,
      required String postId,
      required String commentId}) async {
    try {
      await commentRepoImp.deleteComment(
          commentId: commentId, postId: postId, uid: uid);
      comments.removeWhere((comment) => comment.commentId == commentId);
      emit(CommentsLoadedState(comments: comments)); // ✅ تحديث الـ UI لحظيًا
    } catch (e) {
      print('Error Deleting the Comment: ${e.toString()}');
      emit(CommentsFailState(error: e.toString())); // ✅ تصحيح الخطأ هنا
    }
  }

  // ✅ تحديث عدد اللايكات بدون تحميل البيانات
  Future<void> toggleLikes(
      {required String postId, required String uid}) async {
    try {
      await postsRepoImp.toggleLikes(uid: uid, postId: postId);
      // ✅ تحديث اللايكات محليًا عشان التغيير يظهر فورًا

      for (var post in posts) {
        if (post.postId == postId) {
          if (post.likes.contains(uid)) {
            post.likes.remove(uid);
          } else {
            post.likes.add(uid);
          }
          break;
        }
      }
      emit(PostsLoadedState(posts: posts));
    } catch (e) {
      print('Error Liking/Unliking the post: ${e.toString()}');
      emit(PostsFailState(error: e.toString()));
    }
  }


}

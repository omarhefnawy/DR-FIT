import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';

abstract class PostRepo {
  //  whwn implements this you need to do these methods
  // add post to fire base
  Future<void> addPost({required PostModel model});
  // delete post from firebase
  Future<void> deletePost({required String postId});
  // fethching all post from firebase
  Future<List<PostModel>> fetchAllPosts();
  // fetch posts for user
  Future<List<PostModel>> fetchUserPosts({required String uid});
  // get post by id
  Future<PostModel?> getPostById({required String postId});
  // toggle likes
  Future<void> toggleLikes({required String uid, required String postId});
  // get limit posts like 10 posts if there are tow many posts
  Future<List<PostModel>> fetchPostsPaginated(
      {required int limit, DocumentSnapshot? lastDoc});
  // to update post
  Future<void> updatePost(
      {required String postId, required Map<String, dynamic> updatedData});
}

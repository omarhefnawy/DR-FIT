import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/domain/repo/posts_repo.dart';

class PostsRepoImp implements PostRepo {
  final FirebaseFirestore fireBaseFireStore = FirebaseFirestore.instance;


   @override
  Stream<List<PostModel>> getPostsStream() {
    return fireBaseFireStore
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromJson(doc.data()..['postId'] = doc.id))
            .toList());
  }


  // إضافة منشور
  @override
  Future<void> addPost({required PostModel model}) async {
    try {
      await fireBaseFireStore
          .collection('posts')
          .doc(model.postId)
          .set(model.toJson());
    } catch (e) {
      print('Error Adding Post: ${e.toString()}');
    }
  }

  // حذف منشور
  @override
  Future<void> deletePost({required String postId}) async {
    try {
      await fireBaseFireStore.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Error Deleting Post: ${e.toString()}');
    }
  }

  // جلب جميع المنشورات
  @override
  Future<List<PostModel>> fetchAllPosts() async {
    try {
      final QuerySnapshot posts =
          await fireBaseFireStore.collection('posts').get();

      return posts.docs.map((data) {
        print(data.data());
        return PostModel.fromJson(data.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error Fetching Posts: ${e.toString()}');
      return [];
    }
  }

  // جلب منشورات مستخدم معين
  @override
  Future<List<PostModel>> fetchUserPosts({required String uid}) async {
    try {
      final QuerySnapshot userPosts = await fireBaseFireStore
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      return userPosts.docs.map((data) {
        return PostModel.fromJson(data.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error Fetching userPosts: ${e.toString()}');
      return [];
    }
  }

  // جلب منشور محدد بالـ postId
  @override
  Future<PostModel?> getPostById({required String postId}) async {
    try {
      final DocumentSnapshot post =
          await fireBaseFireStore.collection('posts').doc(postId).get();

      if (post.exists) {
        return PostModel.fromJson(post.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error Fetching Post: ${e.toString()}');
      return null;
    }
  }

  // تحديث منشور
  @override
  Future<void> updatePost({required String postId, required Map<String, dynamic> updatedData}) async {
    try {
      await fireBaseFireStore
          .collection('posts')
          .doc(postId)
          .update(updatedData);
    } catch (e) {
      print('Error Updating Post: ${e.toString()}');
    }
  }

  // جلب منشورات محدودة العدد (لتحميل المزيد)
  @override
  Future<List<PostModel>> fetchPostsPaginated(
      {required int limit, DocumentSnapshot? lastDoc}) async {
    try {
      Query query = fireBaseFireStore
          .collection('posts')
          .orderBy('date', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final QuerySnapshot snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error Fetching Paginated Posts: ${e.toString()}');
      return [];
    }
  }

  // تفعيل/إلغاء الإعجاب بمنشور
@override
Future<void> toggleLikes({
  required String uid, 
  required String postId
}) async {
  try {
    final postRef = fireBaseFireStore.collection('posts').doc(postId);
    final snapshot = await postRef.get();
    
    if (snapshot.exists) {
      final currentLikes = List<String>.from(snapshot['likes'] ?? []);
      
      if (currentLikes.contains(uid)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    }
  } catch (e) {
    throw Exception('فشل تحديث الإعجابات: ${e.toString()}');
  }
}
}

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/features/posts/data/models/comments_model.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/data/repo_imp/comment_repo_imp.dart';
import 'package:dr_fit/features/posts/data/repo_imp/posts_repo_imp.dart';
import 'package:dr_fit/features/posts/cubit/posts_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostsCubit extends Cubit<PostsStates> {
  final PostsRepoImp postsRepoImp;
  final CommentRepoImp commentRepoImp;
  StreamSubscription<List<PostModel>>? _postsSubscription;

  List<PostModel> posts = [];
  List<CommentModel> comments = [];

  PostsCubit({required this.commentRepoImp, required this.postsRepoImp})
      : super(PostsInitialState()) {
    _init();
  }

  void _init() {
    _postsSubscription = postsRepoImp.getPostsStream().listen((newPosts) {
      posts = newPosts;
      emit(PostsLoadedState(posts: List.from(posts)));
    }, onError: (e) {
      emit(PostsFailState(error: e.toString()));
    });
  }

  void listenToPosts() {
    _postsSubscription = postsRepoImp.getPostsStream().listen((posts) {
      this.posts = posts;
      emit(PostsLoadedState(posts: List.from(posts)));
    });
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }

  Future<void> addPost({required PostModel post}) async {
    try {
      if (!_isContentValid(post.post)) {
        emit(PostsFailState(error: 'المحتوى يحتوي على لغة غير لائقة'));
        return;
      }

      await postsRepoImp.addPost(model: post);
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  Future<void> addComment(
      {required CommentModel comment, required String postId}) async {
    try {
      if (!_isContentValid(comment.comment)) {
        emit(CommentsFailState(error: 'المحتوى يحتوي على لغة غير لائقة'));
        return;
      }

      await commentRepoImp.addComment(comment: comment, postId: postId);
      comments.insert(0, comment);
      emit(CommentsLoadedState(comments: List.from(comments)));
    } catch (e) {
      emit(CommentsFailState(error: e.toString()));
    }
  }

  Future<void> fetchAllPosts() async {
    emit(PostsLoadingState());
    try {
      posts = await postsRepoImp.fetchAllPosts();
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  Future<void> fetchUserPosts({required String uid}) async {
    emit(PostsLoadingState());
    try {
      posts = await postsRepoImp.fetchUserPosts(uid: uid);
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  Future<void> fetchComments({required String postId}) async {
    emit(CommentsLoadingState());
    try {
      comments = await commentRepoImp.fecthComments(postId: postId);
      emit(CommentsLoadedState(comments: List.from(comments)));
    } catch (e) {
      emit(CommentsFailState(error: e.toString()));
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      await postsRepoImp.deletePost(postId: postId);
      posts.removeWhere((post) => post.postId == postId);
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

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
        updatedData['image'] = FieldValue.delete();
      }

      updatedData['updatedAt'] = FieldValue.serverTimestamp();

      await postsRepoImp.updatePost(postId: postId, updatedData: updatedData);

      posts = posts.map((post) {
        if (post.postId == postId) {
          return post.copyWith(
            post: newText ?? post.post,
            image: newImageUrl,
          );
        }
        return post;
      }).toList();

      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  Future<void> deleteComment(
      {required String uid,
      required String postId,
      required String commentId}) async {
    try {
      await commentRepoImp.deleteComment(
          commentId: commentId, postId: postId, uid: uid);
      comments.removeWhere((comment) => comment.commentId == commentId);
      emit(CommentsLoadedState(comments: List.from(comments)));
    } catch (e) {
      emit(CommentsFailState(error: e.toString()));
    }
  }

  Future<void> toggleLikes(
      {required String postId, required String uid}) async {
    try {
      final newPosts = posts.map((post) {
        if (post.postId == postId) {
          final newLikes = List<String>.from(post.likes);
          if (newLikes.contains(uid)) {
            newLikes.remove(uid);
          } else {
            newLikes.add(uid);
          }
          return post.copyWith(likes: newLikes);
        }
        return post;
      }).toList();

      emit(PostsLoadedState(posts: newPosts));
      unawaited(postsRepoImp.toggleLikes(uid: uid, postId: postId));
    } catch (e) {
      print('Error in toggleLikes: $e');
      emit(PostsLoadedState(posts: posts));
      showToast(text: 'حدث خطأ في تحديث الإعجاب', state: ToastStates.ERROR);
    }
  }

  Future<void> fetchPostById({required String postId}) async {
    try {
      final PostModel? updatedPost =
          await postsRepoImp.getPostById(postId: postId);

      if (updatedPost != null) {
        posts = posts.map((post) {
          if (post.postId == postId) {
            return updatedPost;
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

  // القائمة الموسعة للكلمات الممنوعة مع إضافة الكلمات المذكورة
  static final List<String> _bannedWords = [
    // ألفاظ عنصرية وطائفية
    'عنصري', 'طائفي', 'منبوذ', 'دوني', 'متفوق عرقيًا', 'متعصب',

    // ألفاظ جنسية صريحة
    'عاهر', 'داعر', 'زاني', 'قواد', 'مومس', 'عارية', 'مخنث', 'معرص', 'خوول',
    'خول',

    // إهانات شخصية
    'كلب', 'حمار', 'بقرة', 'هبل', 'أحمق', 'غبي', 'أبله', 'فاشل', 'منيك',
    'متناك',

    // ألفاظ تحقير الجنس
    'متخلف', 'ساقط', 'بليد', 'هزيل', 'معفن', 'قذر',

    // ألفاظ دينية مسيئة
    'كفار', 'ملحدين', 'ديس', 'دعارة', 'خرافي', 'سخيف دينيًا',

    // تهديدات
    'سأقتلك', 'سأحرقك', 'سأفضحك', 'سأدمرك', 'سأدمر حياتك',

    // ألفاظ عنف
    'إرهابي', 'تفجير', 'ذبح', 'شنق', 'قتل', 'إبادة', 'مجزرة',

    // مصطلحات مخلة بالآداب
    'ممحونة', 'عير', 'كسي', 'فرج', 'مثير', 'شهواني', 'بذيء', 'كس', 'كس امك',
    'كس اختك',

    // إهانات عائلية
    'يا ابن الحرام', 'يا ولد الزنا', 'يا خنيث', 'ابن الزنا', 'يا ابن الكلب',
    'يا ابن القحبة',

    // ألفاظ تحريضية
    'اطردوا', 'اقتلوا', 'اشنقوا', 'اطردوهم', 'دعوة للعنف', 'ثوار',

    // مصطلحات عنصرية
    'عبد', 'خادم', 'نجس', 'أعجمي', 'عبيد', 'أفريقي', 'شحات', 'بلحة', 'صعايدي',

    // كلمات مسيئة أخرى
    'مريض نفسي', 'معتوه', 'متخلف عقليًا', 'أهبل', 'مهبول',
    'كاذب', 'نذل', 'جبان', 'منافق', 'غادر', 'وسخ', 'مهزء',

    // شتائم مصرية شائعة
    'كسم', 'كس أم', 'يلعن', 'ميتين', 'طظ', 'طز', 'فلاح', 'فشخ', 'مفشوخ',
    'هطل', 'متهور', 'مجرور', 'عك', 'معوك', 'ميت', 'هيص', 'عير', 'كداك',
    'مشخر', 'فهلوي', 'بلطجي', 'عكروت', 'منايك', 'إس إم', 'ك.س', 'ي.ل', 'ف.ش',
    'كسمك', 'كسامك', 'كسمكم', 'كسمين', 'قلة أدب', 'ولد وسخة', 'خايب', 'داشر',
    'متهيأ', 'مش نضيف', 'يا خول', 'يا معرص', 'يا ابن العاهرة', 'يا ابن الكلب'
  ];

  // التحقق الأساسي من صحة المحتوى (نظام محلي فقط)
  bool _isContentValid(String text) {
    final normalizedText = _normalizeText(text);
    final words = normalizedText.split(RegExp(r'\s+')); // نقسم النص لكلمات

    for (final word in words) {
      if (_bannedWords.contains(word)) {
        debugPrint('🚫 كلمة ممنوعة: $word');
        return false;
      }
    }

    return true;
  }

  // تطبيع النص للتحقق
  String _normalizeText(String text) {
    final withoutDiacritics =
        text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    final withoutPunctuation =
        withoutDiacritics.replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '');
    final normalizedRepeats = withoutPunctuation.replaceAllMapped(
      RegExp(r'(.)\1+'),
      (m) => m.group(1) ?? '',
    );
    return normalizedRepeats.toLowerCase();
  }

  bool checkContent(String text) {
    return _isContentValid(text);
  }
}

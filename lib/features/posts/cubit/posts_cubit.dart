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
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  final String _apiToken = dotenv.env['_apiToken'] ?? '';
  bool _isAnalyzing = false;
  StreamSubscription<List<PostModel>>? _postsSubscription;

  List<PostModel> posts = [];
  List<CommentModel> comments = [];

  PostsCubit({required this.commentRepoImp, required this.postsRepoImp})
      : super(PostsInitialState()){_init();
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

  // ✅ إضافة بوست بدون إعادة تحميل البيانات كاملة
  Future<void> addPost({required PostModel post}) async {
    try {
      // التحقق من المحتوى باستخدام الدالة الداخلية
      if (!(await _isContentValid(post.post))) {
        emit(PostsFailState(error: 'المحتوى يحتوي على لغة غير لائقة'));
        return;
      }

      await postsRepoImp.addPost(model: post);
      emit(PostsLoadedState(posts: List.from(posts)));
    } catch (e) {
      emit(PostsFailState(error: e.toString()));
    }
  }

  // ✅ إضافة تعليق بدون تحميل جميع التعليقات
  Future<void> addComment(
      {required CommentModel comment, required String postId}) async {
    try {
      // التحقق من محتوى التعليق
      if (!(await _isContentValid(comment.comment))) {
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

  // ✅ تحديث عدد اللايكات بدون تحميل البيانات
Future<void> toggleLikes({required String postId, required String uid}) async {
  try {
    // إنشاء نسخة جديدة من القائمة مع التحديث
    final newPosts = posts.map((post) {
      if (post.postId == postId) {
        final newLikes = List<String>.from(post.likes);
        if (newLikes.contains(uid)) {
          newLikes.remove(uid);
        } else {
          newLikes.add(uid);
        }
        return post.copyWith(likes: newLikes); // تحديث النسخة
      }
      return post;
    }).toList();

    // تحديث الحالة فوراً
    emit(PostsLoadedState(posts: newPosts));

    // تحديث Firestore (الخلفية)
    unawaited(postsRepoImp.toggleLikes(uid: uid, postId: postId));

  } catch (e) {
    print('Error in toggleLikes: $e');
    // التراجع عن التغييرات في حالة الخطأ
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

  static final List<String> _bannedWords = [
    // ألفاظ عنصرية وطائفية
    'عنصري', 'طائفي', 'منبوذ', 'دوني', 'متفوق عرقيًا', 'متعصب',

    // ألفاظ جنسية صريحة
    'عاهر', 'داعر', 'زاني', 'قواد', 'مومس', 'عارية', 'مخنث',

    // إهانات شخصية
    'كلب', 'حمار', 'بقرة', 'هبل', 'خول', 'أحمق', 'غبي', 'أبله', 'فاشل',

    // ألفاظ تحقير الجنس
    'متخلف', 'أبله', 'غبي', 'ساقط', 'بليد', 'هزيل',

    // ألفاظ دينية مسيئة
    'كفار', 'ملحدين', 'ديس', 'دعارة', 'خرافي', 'سخيف دينيًا',

    // تهديدات
    'سأقتلك', 'سأحرقك', 'سأفضحك', 'سأدمرك', 'سأدمر حياتك',

    // ألفاظ عنف
    'إرهابي', 'تفجير', 'ذبح', 'شنق', 'قتل', 'إبادة', 'مجزرة',

    // مصطلحات مخلة بالآداب
    'ممحونة', 'عير', 'كسي', 'فرج', 'مثير', 'شهواني', 'بذيء',

    // إهانات عائلية
    'يا ابن الحرام', 'يا ولد الزنا', 'يا خنيث', 'ابن الزنا',

    // ألفاظ تحريضية
    'اطردوا', 'اقتلوا', 'اشنقوا', 'اطردوهم', 'دعوة للعنف', 'ثوار',

    // مصطلحات عنصرية
    'عبد', 'خادم', 'نجس', 'أعجمي', 'عبيد', 'أفريقي', 'شحات',

    // كلمات مسيئة أخرى
    'مريض نفسي', 'معتوه', 'أحمق', 'متخلف عقليًا', 'أهبل',
    'كاذب', 'نذل', 'جبان', 'منافق', 'غادر',

    // شتائم مصرية شائعة (مكتوبة بطريقة مخففة)
    'كسم', 'كس أم', 'يلعن', 'ميتين',
    'خول', 'خنيث', 'متناك', 'منيك',
    'يابن الـ', 'ياخو الـ', 'طظ', 'طز',
    'فلاح', 'صعايدي', 'بلحة', 'معفن',
    'فشخ', 'مفشوخ', 'وسخ', 'قذر',
    'هطل', 'مهبول', 'متهور', 'مجرور',
    'عك', 'معوك', 'ميت', 'هيص',
    'عير', 'كداك', 'مشخر', 'مهزء',
    'فهلوي', 'بلطجي', 'عكروت', 'منايك',

    // كلمات مختصرة ورموز
    'إس إم', 'ك.س', 'ي.ل', 'ف.ش',
    'كسمك', 'كسامك', 'كسمكم', 'كسمين',

    // كلمات ذات دلالة مزدوجة
    'قلة أدب', 'ولد وسخة', 'خايب',
    'داشر', 'متهيأ', 'مش نضيف'
  ];

  Future<bool> _isContentValid(String text) async {
    try {
      final lowerText = text.toLowerCase();

      // 1. التحقق السريع من الكلمات الممنوعة
      if (_bannedWords.any((word) => lowerText.contains(word))) {
        return false;
      }

      // 2. التحقق المتقدم باستخدام النموذج
      final sentiment = await _analyzeSentiment(text);
      return sentiment == 'POSITIVE' || sentiment == 'NEUTRAL';
    } catch (e) {
      debugPrint('Content validation error: $e');
      return true; // السماح في حالة الخطأ لمنع الحظر الخاطئ
    }
  }

  Future<String> _analyzeSentiment(String text) async {
    if (text.isEmpty) return 'NEUTRAL';
    if (_isAnalyzing) return 'PENDING';

    _isAnalyzing = true;
    const apiUrl =
        'https://api-inference.huggingface.co/models/CAMeL-Lab/bert-base-arabic-camelbert-mix-sentiment';

    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $_apiToken'},
        ),
        data: jsonEncode({'inputs': text}),
        queryParameters: {'wait_for_model': 'true'},
      );

      // معالجة الاستجابة بشكل أكثر دقة
      final responseData = response.data;
      if (responseData is List) {
        final firstResult = responseData.firstOrNull;
        if (firstResult is List) {
          final bestMatch = firstResult.firstOrNull;
          if (bestMatch is Map) {
            return _parseSentiment(bestMatch);
          }
        } else if (firstResult is Map) {
          return _parseSentiment(firstResult);
        }
      }
      return 'NEUTRAL';
    } on DioException catch (e) {
      debugPrint('API Error: ${e.message}');
      if (e.response?.statusCode == 503) return 'MODEL_LOADING';
      return 'ERROR';
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return 'ERROR';
    } finally {
      _isAnalyzing = false;
    }
  }

  String _parseSentiment(Map<dynamic, dynamic> data) {
    try {
      final label = (data['label'] as String?)?.toUpperCase() ?? 'NEUTRAL';
      final score = (data['score'] as num?)?.toDouble() ?? 0.0;

      if (label == 'NEGATIVE' && score > 0.85) return 'NEGATIVE';
      if (label == 'POSITIVE' && score > 0.75) return 'POSITIVE';
      return 'NEUTRAL';
    } catch (e) {
      return 'NEUTRAL';
    }
  }

  Future<bool> checkContent(String text) async {
    return _isContentValid(text);
  }
}

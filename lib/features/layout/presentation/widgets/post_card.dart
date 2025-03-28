import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/cubit/posts_state.dart';
import 'package:dr_fit/features/posts/presetation/screens/addComment.dart';
import 'package:dr_fit/features/posts/presetation/screens/edit_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final String name;
  final bool isOwner;
  final String userId; // معرف المستخدم الحالي

  const PostCard({
    super.key,
    required this.post,
    required this.name,
    required this.isOwner,
    required this.userId,
  });

  // 🔹 دالة تجلب عدد التعليقات لحظيًا من Firestore
  Stream<int> getCommentCount(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    bool my = FirebaseAuth.instance.currentUser?.uid == post.uid;

    return BlocBuilder<PostsCubit, PostsStates>(
      builder: (context, state) {
        bool isLiked = post.likes.contains(userId);

        return InkWell(
          onLongPress: () {
            if (my) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.question,
                title: 'خيارات المنشور',
                desc: 'ماذا تريد أن تفعل؟',
                btnOkText: 'حذف',
                btnOkColor: Colors.red,
                btnOkOnPress: () {
                  context.read<PostsCubit>().deletePost(postId: post.postId);
                },
                btnCancelText: 'تعديل',
                btnCancelColor: Colors.blue,
                btnCancelOnPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPostScreen(
                        postId: post.postId,
                        value: post.post,
                      ),
                    ),
                  );
                },
              ).show();
            }
          },

          child: Card(
            elevation: my ? 8 : 3, // ارتفاع الظل مختلف لمنشورك فقط
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: my ? const BorderSide(color: Colors.blueAccent, width: 2) : BorderSide.none, // إطار حول منشورك فقط
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        my ? "$name ⭐" : post.userName, // نجمة بجانب اسمك فقط
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: my ? Colors.blueAccent : bottomNavigationBar, // لون مختلف لاسمك فقط
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.post,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    post.date != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(post.date!.toDate())
                      : 'تاريخ غير متاح',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  if ((post.image ?? '').isNotEmpty)
                    SizedBox(
                      height: 260,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          post.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // عدد الإعجابات مع الأيقونة
                      Row(
                        children: [
                          Text(
                            '${post.likes.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<PostsCubit>().toggleLikes(
                                  postId: post.postId, uid: userId);
                            },
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.blue,
                              size: 28,
                            ),
                          ),
                        ],
                      ),

                      // عدد التعليقات مع الأيقونة
                      Row(
                        children: [
                          StreamBuilder<int>(
                            stream: getCommentCount(post.postId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text(
                                  '...',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text(
                                  'خطأ',
                                  style: TextStyle(fontSize: 18, color: Colors.red),
                                );
                              }
                              return Text(
                                '${snapshot.data ?? 0}', // عرض عدد التعليقات الفعلي
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              navigateTo(
                                context,
                                AddCommentScreen(
                                  userName:name ,
                                  postId: post.postId,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.comment,
                              color: buttonPrimaryColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

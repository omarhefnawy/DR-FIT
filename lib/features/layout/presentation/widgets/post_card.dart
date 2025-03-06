import 'package:awesome_dialog/awesome_dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    bool my = FirebaseAuth.instance.currentUser!.uid == post.uid;
    return BlocBuilder<PostsCubit, PostsStates>(
      builder: (context, state) {
        bool isLiked = post.likes.contains(userId);

        return InkWell(
          // onTap: () {my?
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => EditPostScreen(postId: post.postId, value: post.post,),)):null;
          // },
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
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المستخدم مع لون أزرق
                  Text(
                    my ? name : post.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: bottomNavigationBar,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // نص البوست
                  Text(
                    post.post,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // تاريخ النشر باللون الرمادي
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(post.date.toDate()),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  // صورة البوست (إن وجدت)
                  if (post.image != null && post.image!.isNotEmpty)
                    SizedBox(
                      height: 260, // حجز مساحة للصورة فقط إذا كانت موجودة
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
                  // صف التفاعلات (إعجاب - تعليق - حذف إن كان المالك)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // زر الإعجاب باللون الأزرق
                      Row(
                        children: [
                          Text(
                            '${post.likes.length}',
                            style: TextStyle(
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
                      // زر التعليق
                      IconButton(
                        onPressed: () {
                          navigateTo(
                              context,
                              AddCommentScreen(
                                name: name,
                                postId: post.postId,
                              ));
                        },
                        icon: const Icon(
                          Icons.comment,
                          color: buttonPrimaryColor,
                          size: 28,
                        ),
                      ),
                      // زر الحذف (يظهر فقط إن كان المستخدم هو صاحب البوست)
                      if (isOwner)
                        IconButton(
                          onPressed: () {
                            context
                                .read<PostsCubit>()
                                .deletePost(postId: post.postId);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 28,
                          ),
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

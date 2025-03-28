import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/posts/data/models/comments_model.dart';
import 'package:dr_fit/features/posts/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/cubit/posts_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddCommentScreen extends StatefulWidget {
  final String postId;
  final String userName;

  const AddCommentScreen({
    super.key,
    required this.postId,
    required this.userName,
  });

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    context.read<PostsCubit>().fetchComments(postId: widget.postId);
  }

  Future<void> _saveComment() async {
    if (_commentController.text.isNotEmpty) {
      await context.read<PostsCubit>().addComment(
            postId: widget.postId,
            comment: CommentModel(
              postId: widget.postId,
              uid: uid,
              userName: widget.userName, // ✅ استخدام اسم المستخدم مباشرة
              comment: _commentController.text,
              time: Timestamp.now(),
              commentId: DateTime.now().millisecondsSinceEpoch.toString(),
            ),
          );
      _commentController.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("التعليقات"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<PostsCubit>().fetchAllPosts();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<PostsCubit, PostsStates>(
              builder: (context, state) {
                if (state is CommentsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CommentsFailState) {
                  return Center(
                    child: Text("Error: ${state.error}",
                        style: const TextStyle(color: Colors.red)),
                  );
                } else if (state is CommentsLoadedState) {
                  return state.comments.isEmpty
                      ? const Center(child: Text("لا توجد تعليقات حتى الآن."))
                      : ListView.builder(
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            final comment = state.comments[index];
                            bool isMyComment = comment.uid == uid;

                            return GestureDetector(
                              onLongPress: () {
                                if (isMyComment) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.question,
                                    title: 'هل تريد حذف هذا التعليق؟',
                                    btnOkText: 'نعم، احذف',
                                    btnOkOnPress: () {
                                      context
                                          .read<PostsCubit>()
                                          .deleteComment(
                                            uid: uid,
                                            postId: widget.postId,
                                            commentId: comment.commentId,
                                          );
                                    },
                                  ).show();
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: isMyComment
                                          ? Colors.blueAccent
                                          : Colors.grey.shade300),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      child: Icon(
                                        Icons.person,
                                        color: isMyComment
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            comment.userName, // ✅ استخدام الاسم المخزن مباشرة
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: isMyComment
                                                  ? Colors.blueAccent
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            comment.comment,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat('hh:mm a')
                                          .format(comment.time.toDate()),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                }
                return const Center(child: Text("لا توجد تعليقات حتى الآن."));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "اكتب تعليق...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: buttonPrimaryColor),
                  onPressed: _saveComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

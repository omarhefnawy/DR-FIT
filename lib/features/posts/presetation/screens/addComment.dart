import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/utils/component.dart';
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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    context.read<PostsCubit>().fetchComments(postId: widget.postId);
  }

  Future<void> _saveComment() async {
    if (_isSaving || _commentController.text.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final comment = CommentModel(
        postId: widget.postId,
        uid: uid,
        userName: widget.userName,
        comment: _commentController.text.trim(),
        time: Timestamp.now(),
        commentId: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // التحقق من المحتوى قبل الإرسال
      final isValid =
          await context.read<PostsCubit>().checkContent(comment.comment);
      if (!isValid) {
        showToast(
          text: 'المحتوى يحتوي على كلمات غير لائقة',
          state: ToastStates.ERROR,
        );
        return;
      }

      await context.read<PostsCubit>().addComment(
            comment: comment,
            postId: widget.postId,
          );

      _commentController.clear();
      showToast(text: 'تم إضافة التعليق بنجاح', state: ToastStates.SUCCESS);
    } catch (e) {
      showToast(
        text: 'فشل إضافة التعليق: ${e.toString()}',
        state: ToastStates.ERROR,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التعليقات"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // احذف استدعاء fetchAllPosts
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<PostsCubit, PostsStates>(
              listener: (context, state) {
                if (state is CommentsFailState) {
                  showToast(
                    text: 'خطأ في تحميل التعليقات: ${state.error}',
                    state: ToastStates.ERROR,
                  );
                }
              },
              builder: (context, state) {
                if (state is CommentsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = context.watch<PostsCubit>().comments;

                return comments.isEmpty
                    ? const Center(child: Text("لا توجد تعليقات حتى الآن."))
                    : ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final isMyComment = comment.uid == uid;

                          return _buildCommentItem(comment, isMyComment);
                        },
                      );
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment, bool isMyComment) {
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(comment),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isMyComment ? Colors.blueAccent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: Icon(
                Icons.person,
                color: isMyComment ? Colors.blueAccent : Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    comment.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isMyComment ? Colors.blueAccent : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    comment.comment,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              DateFormat('hh:mm a').format(comment.time.toDate()),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Padding(
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
              enabled: !_isSaving,
            ),
          ),
          IconButton(
            icon: _isSaving
                ? const CircularProgressIndicator()
                : const Icon(Icons.send, color: buttonPrimaryColor),
            onPressed: _isSaving ? null : _saveComment,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(CommentModel comment) {
    if (comment.uid != uid) return;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      title: 'هل تريد حذف هذا التعليق؟',
      btnOkText: 'نعم، احذف',
      btnCancelText: 'إلغاء',
      btnOkOnPress: () => context.read<PostsCubit>().deleteComment(
            uid: uid,
            postId: widget.postId,
            commentId: comment.commentId,
          ),
    ).show();
  }
}

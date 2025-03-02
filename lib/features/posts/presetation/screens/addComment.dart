import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/features/posts/data/models/comments_model.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/presetation/cubit/posts_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddCommentScreen extends StatefulWidget {
  final String postId;
  final String name;
  const AddCommentScreen({super.key, required this.postId, required this.name});

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final _uuid = Uuid();
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
              comment: _commentController.text,
              time: Timestamp.now(),
              commentId: _uuid.v4(),
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
        title: const Text("Comments"),
        actions: [
          IconButton(
              onPressed: () {
                context.read<PostsCubit>().fetchAllPosts();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
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
                      ? const Center(child: Text("No comments yet."))
                      : ListView.builder(
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            final comment = state.comments[index];
                            return InkWell(
                              onLongPress: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  title: 'تأكيد',
                                  btnOkText: 'حذف',
                                  btnOkOnPress: () {
                                    context.read<PostsCubit>().deleteComment(uid: uid, postId: widget.postId, commentId: comment.commentId);
                                  },
                                ).show();
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(widget.name[0].toUpperCase()),
                                ),
                                title: Text(comment.comment),
                                subtitle: Text(
                                  comment.time.toDate().toLocal().toString(),
                                ),
                              ),
                            );
                          },
                        );
                }
                return const Center(child: Text("No comments yet."));
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
                      hintText: "Write a comment...",
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

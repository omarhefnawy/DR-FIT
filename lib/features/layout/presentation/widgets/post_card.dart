import 'dart:async';

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
  final String userId;

  const PostCard({
    super.key,
    required this.post,
    required this.name,
    required this.isOwner,
    required this.userId,
  });

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
                        imageUrl: post.image ?? '',
                      ),
                    ),
                  );
                },
              ).show();
            }
          },
          child: Card(
            elevation: my ? 8 : 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: my
                  ? const BorderSide(color: Colors.blueAccent, width: 2)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        my ? "$name ⭐" : post.userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: my ? Colors.blueAccent : bottomNavigationBar,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(post.date.toDate()),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (post.post.trim().isNotEmpty)
                    _ExpandableTextAnimated(
                      text: post.post,
                      trimLength: 120,
                    ),
                  const SizedBox(height: 5),
                  if ((post.image ?? '').isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.black,
                            insetPadding: EdgeInsets.all(10),
                            child: InteractiveViewer(
                              panEnabled: true,
                              minScale: 0.5,
                              maxScale: 3.0,
                              child: Image.network(
                                post.image!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildNetworkImageWithOriginalAspectRatio(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          context
                              .read<PostsCubit>()
                              .toggleLikes(postId: post.postId, uid: userId);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: isLiked ? Colors.red : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              isLiked ? Colors.red[50] : Colors.grey[100],
                        ),
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                        ),
                        label: Text(
                          '${post.likes.length}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          navigateTo(
                            context,
                            AddCommentScreen(
                              userName: name,
                              postId: post.postId,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.blue[50],
                        ),
                        icon: const Icon(Icons.comment, size: 20),
                        label: StreamBuilder<int>(
                          stream: getCommentCount(post.postId),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Text(
                              '$count',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            );
                          },
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

  Widget _buildNetworkImageWithOriginalAspectRatio() {
    return FutureBuilder<Size>(
      future: _getImageSize(post.image!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final size = snapshot.data!;
          return AspectRatio(
            aspectRatio: size.width / size.height,
            child: Image.network(
              post.image!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
          );
        } else {
          return Container(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<Size> _getImageSize(String imageUrl) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }
}

class _ExpandableTextAnimated extends StatefulWidget {
  final String text;
  final int trimLength;
  final int expandThreshold;

  const _ExpandableTextAnimated({
    Key? key,
    required this.text,
    this.trimLength = 150,
    this.expandThreshold = 300,
  }) : super(key: key);

  @override
  State<_ExpandableTextAnimated> createState() =>
      _ExpandableTextAnimatedState();
}

class _ExpandableTextAnimatedState extends State<_ExpandableTextAnimated>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final int textLength = widget.text.length;
    final bool isTrimmed = textLength > widget.trimLength;
    final bool canCollapse = textLength > widget.expandThreshold;

    final String displayText = _expanded || !isTrimmed
        ? widget.text
        : widget.text.substring(0, widget.trimLength).trim() + '...';

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(text: displayText),
                if (isTrimmed && !_expanded)
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _expanded = !_expanded);
                      },
                      child: Text(
                        ' إظهار المزيد',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_expanded && canCollapse)
            GestureDetector(
              onTap: () {
                setState(() => _expanded = !_expanded);
              },
              child: Text(
                'إخفاء',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
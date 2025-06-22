import 'dart:ui' as ui;

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

class PostCard extends StatefulWidget {
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

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return BlocBuilder<PostsCubit, PostsStates>(
      buildWhen: (prev, curr) => curr is PostsLoadedState,
      builder: (context, state) {
        final currentPost = context.read<PostsCubit>().posts.firstWhere(
              (p) => p.postId == widget.post.postId,
              orElse: () => widget.post,
            );
        final isMyPost = currentUserId == widget.post.uid;

        final isLiked = currentPost.likes.contains(currentUserId);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: textColor(context).withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: secondaryColor(context),
            child: InkWell(
              onLongPress: isMyPost ? _showPostOptions : null,
              borderRadius: BorderRadius.circular(20),
              splashColor: buttonPrimaryColor(context).withOpacity(0.1),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPostHeader(currentPost, isMyPost),
                    const SizedBox(height: 12),
                    if (currentPost.post.trim().isNotEmpty)
                      _ExpandableTextEnhanced(
                        text: currentPost.post,
                        trimLength: 120,
                      ),
                    if (currentPost.image?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildPostImage(currentPost),
                      ),
                    const SizedBox(height: 12),
                    _buildInteractionButtons(currentPost, isLiked),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostHeader(PostModel post, bool isMyPost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isMyPost
                      ? buttonPrimaryColor(context).withOpacity(0.1)
                      : buttonSecondaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isMyPost ? "${widget.name} ⭐" : post.userName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isMyPost
                        ? buttonPrimaryColor(context)
                        : textColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          DateFormat('dd/MM/yyyy • HH:mm').format(post.date.toDate()),
          style: TextStyle(
            fontSize: 12,
            color: textColor(context).withOpacity(0.5),
            fontFeatures: const [ui.FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildPostImage(PostModel post) {
    return Hero(
      tag: post.image!,
      child: GestureDetector(
        onTap: () => _showFullImage(post.image!),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildUniformImage(post.image!),
        ),
      ),
    );
  }

  Widget _buildInteractionButtons(PostModel post, bool isLiked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInteractionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: '${post.likes.length}',
          color: isLiked ? Colors.red : textColor(context),
          onPressed: () => _handleLike(post),
        ),
        _buildCommentButton(post),
      ],
    );
  }

  Widget _buildCommentButton(PostModel post) {
    return StreamBuilder<int>(
      stream: getCommentCount(post.postId),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return _buildInteractionButton(
          icon: Icons.comment,
          label: count > 0 ? '$count تعليق' : 'تعليق',
          color: buttonPrimaryColor(context),
          onPressed: () => _navigateToComments(post),
        );
      },
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: Icon(icon, size: 20, color: color),
      label: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }

  Widget _buildUniformImage(String imageUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: buttonPrimaryColor(context),
            ),
          );
        },
        errorBuilder: (context, _, __) => _buildImageErrorPlaceholder(),
      ),
    );
  }

  void _showFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageScreen(imageUrl: imageUrl),
      ),
    );
  }

  void _showPostOptions() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      title: 'خيارات المنشور',
      desc: 'ماذا تريد أن تفعل؟',
      btnOkText: 'حذف',
      btnOkColor: Colors.red,
      btnOkOnPress: () => _deletePost(),
      btnCancelText: 'تعديل',
      btnCancelColor: buttonPrimaryColor(context),
      btnCancelOnPress: () => _editPost(),
    ).show();
  }

  void _deletePost() {
    context.read<PostsCubit>().deletePost(postId: widget.post.postId);
  }

  void _editPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(
          postId: widget.post.postId,
          value: widget.post.post,
          imageUrl: widget.post.image ?? '',
        ),
      ),
    );
  }

  void _handleLike(PostModel post) {
    context.read<PostsCubit>().toggleLikes(
      postId: post.postId,
      uid: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void _navigateToComments(PostModel post) {
    navigateTo(
      context,
      AddCommentScreen(
        userName: widget.name,
        postId: post.postId,
      ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.1,
              maxScale: 4.0,
              child: Center(
                child: Hero(
                  tag: imageUrl,
                  child: Image.network(imageUrl),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: textColor(context), size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableTextEnhanced extends StatefulWidget {
  final String text;
  final int trimLength;

  const _ExpandableTextEnhanced({
    Key? key,
    required this.text,
    this.trimLength = 150,
  }) : super(key: key);

  @override
  State<_ExpandableTextEnhanced> createState() => _ExpandableTextEnhancedState();
}

class _ExpandableTextEnhancedState extends State<_ExpandableTextEnhanced> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final textLength = widget.text.length;
    final isTrimmed = textLength > widget.trimLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topLeft,
          child: Text(
            widget.text,
            overflow: TextOverflow.clip,
            maxLines: _expanded ? null : 3,
            style: TextStyle(fontSize: 15, height: 1.5, color: textColor(context)),
          ),
        ),
        if (isTrimmed)
          TextButton(
            onPressed: _toggleExpansion,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _expanded ? 'إظهار أقل' : 'إظهار المزيد',
                  style: TextStyle(
                    color: buttonPrimaryColor(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AnimatedIcon(
                  icon: AnimatedIcons.arrow_menu,
                  progress: _controller,
                  color: buttonPrimaryColor(context),
                  size: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _toggleExpansion() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Widget _buildImageErrorPlaceholder() {
  return Container(
    color: Colors.grey[100],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_rounded, color: Colors.grey[400], size: 40),
          const SizedBox(height: 8),
          Text(
            'تعذر تحميل الصورة',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

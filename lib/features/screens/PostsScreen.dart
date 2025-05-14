import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/core/utils/constants.dart';
import 'package:dr_fit/core/utils/context_extension.dart';
import 'package:dr_fit/features/layout/presentation/widgets/post_card.dart';
import 'package:dr_fit/features/posts/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/cubit/posts_state.dart';
import 'package:dr_fit/features/posts/data/models/posts_model.dart';
import 'package:dr_fit/features/posts/presetation/screens/add_post.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageStorageKey _postsPageKey = const PageStorageKey('posts_list');
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    context.read<PostsCubit>().listenToPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنشورات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddPost(context),
          ),
        ],
      ),
      body: BlocConsumer<PostsCubit, PostsStates>(
        listener: (context, state) {
          if (state is PostsFailState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is PostsLoadedState && _isFirstLoad) {
            _isFirstLoad = false;
          }
        },
        builder: (context, state) {
          if (state is PostsLoadingState && _isFirstLoad) {
            return _buildLoadingIndicator();
          }

          if (state is PostsFailState) {
            return _buildErrorWidget(state.error);
          }

          return _buildPostsList(context);
        },
      ),
    );
  }

  Widget _buildPostsList(BuildContext context) {
    final posts = context.watch<PostsCubit>().posts;

    if (posts.isEmpty) {
      return const Center(child: Text('لا يوجد منشورات حتى الآن'));
    }

    return CustomScrollView(
      key: _postsPageKey,
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildPostItem(context, posts[index]),
            childCount: posts.length,
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem(BuildContext context, PostModel post) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, profileState) {
        String userName = '';
        String uid = '';
        bool isOwner = false;

        if (profileState is ProfileLoaded) {
          userName = profileState.profileData.name;
          uid = profileState.profileData.uid;
          isOwner = uid == post.uid;
        }

        return PostCard(
          key: ValueKey(post.postId),
          userId: uid,
          name: userName,
          post: post,
          isOwner: isOwner,
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'جاري التحميل..',
            style: TextStyle(
              color: buttonPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.height * 0.1),
          LoadingAnimationWidget.flickr(
            leftDotColor: buttonPrimaryColor,
            rightDotColor: bottomNavigationBar,
            size: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(
            'حدث خطأ: $error',
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<PostsCubit>().listenToPosts(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddPost(BuildContext context) {
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      navigateTo(
        context,
        AddPostScreen(userName: profileState.profileData.name),
      );
    }
  }
}
import 'package:dr_fit/core/utils/component.dart';
import 'package:dr_fit/features/layout/presentation/widgets/post_card.dart';
import 'package:dr_fit/features/posts/cubit/posts_cubit.dart';
import 'package:dr_fit/features/posts/cubit/posts_state.dart';
import 'package:dr_fit/features/posts/presetation/screens/add_post.dart';
import 'package:dr_fit/features/profile/controller/profile_cubit.dart';
import 'package:dr_fit/features/profile/controller/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  Widget build(BuildContext context) {
    // جلب البوستات عند فتح الصفحة
    context.read<PostsCubit>().fetchAllPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('المنشورات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final state = context.read<ProfileCubit>().state;
              if (state is ProfileLoaded) {
                navigateTo(
                  context,
                  AddPostScreen(
                    userName: state.profileData.name,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<PostsCubit, PostsStates>(
        builder: (context, state) {
          if (state is PostsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsLoadedState) {
            final posts = state.posts;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final post = posts[index];
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
                      userId: uid,
                      name: userName,
                      post: post,
                      isOwner: isOwner,
                    );
                  },
                );
              },
            );
          } else if (state is PostsFailState) {
            return Center(
              child: Text(
                'حدث خطأ: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text('لا يوجد بوستات حتى الآن.'));
        },
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_locater.dart';
import '../../config/app_router.dart';
import '../../data/post_repo.dart';
import '../cubits/feed/feed_cubit.dart';
import 'post_list.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeFeedCubit(locator<PostRepo>())..getPosts(),
      child: const _HomeFeedView(),
    );
  }
}

class _HomeFeedView extends StatelessWidget {
  const _HomeFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeFeedCubit, HomeFeedState>(
      listener: (context, state) {
        if (state is FeedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.posts?.isNotEmpty == true) {
          return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeFeedCubit>().getPosts();
              },
              child: PostList(
                itemList: state.posts!,
                onPostTap: (postId) {
                  context.router.push(ViewPostRoute(postId: postId));
                },
                onPostLikeTap: (postId) {
                  context.read<HomeFeedCubit>().likePost(postId);
                },
                onPollOptionTap: (postId, idx) {
                  context.read<HomeFeedCubit>().selectPollOption(postId, idx);
                },
              ));
        } else {
          return const Center(child: Text('No posts available'));
        }
      },
    );
  }
}

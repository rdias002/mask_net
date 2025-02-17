import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_locater.dart';
import '../../config/app_router.dart';
import '../../data/auth_repo.dart';
import '../../data/post_repo.dart';
import '../cubits/profile/profile_cubit.dart';
import '../widgets/post_list.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        locator<AuthRepo>(),
        locator<PostRepo>(),
      )..getUserProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogout) {
          context.router.pushAndPopUntil(
            const HomeRoute(),
            predicate: (_) => false,
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ProfileCubit>().getUserProfile();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: state.userProfile == null
                  ? const Center(child: CircularProgressIndicator())
                  : buildProfile(context, state),
            ),
          ),
        );
      },
    );
  }

  Stack buildProfile(BuildContext context, ProfileState state) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    state.userProfile!.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    state.userProfile!.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      context.read<ProfileCubit>().logout();
                    },
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
            Expanded(
                child: state.userPosts != null && state.userPosts!.isNotEmpty
                    ? PostList(
                        itemList: state.userPosts!,
                        onPostTap: (p0) {
                          context.router.push(ViewPostRoute(postId: p0));
                        },
                        onPostLikeTap: (p0) {
                          context.read<ProfileCubit>().likePost(p0);
                        },
                        onPollOptionTap: (p0, p1) {
                          context.read<ProfileCubit>().selectPollOption(p0, p1);
                        },
                      )
                    : Center(
                        child: Text(
                          'No posts yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ))
          ],
        ),
        if (state.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_locater.dart';
import '../../config/app_router.dart';
import '../../data/post_repo.dart';
import '../cubits/company_post/company_post_cubit.dart';
import '../widgets/post_list.dart';
import '../widgets/star.dart';

@RoutePage()
class CompanyPostScreen extends StatelessWidget {
  final String companyId;

  const CompanyPostScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyPostCubit(locator<PostRepo>())
        ..setCompanyId(companyId)
        ..getPosts(),
      child: const _CompanyPostView(),
    );
  }
}

class _CompanyPostView extends StatelessWidget {
  const _CompanyPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyPostCubit, CompanyPostState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.company?.name ?? ''),
            actions: [
              StarWidget(),
              IconButton(
                iconSize: 40.0,
                padding: const EdgeInsets.only(right: 16.0),
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  context.router.push(const ProfileRoute());
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (state.posts?.isNotEmpty == true)
                RefreshIndicator(
                    onRefresh: () async {
                      context.read<CompanyPostCubit>().getPosts();
                    },
                    child: PostList(
                      itemList: state.posts!,
                      onPostTap: (postId) {
                        context.router.push(ViewPostRoute(postId: postId));
                      },
                      onPostLikeTap: (postId) {
                        context.read<CompanyPostCubit>().likePost(postId);
                      },
                      onPollOptionTap: (postId, idx) {
                        context
                            .read<CompanyPostCubit>()
                            .selectPollOption(postId, idx);
                      },
                    ))
              else
                const Center(child: Text('No posts available')),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.router
                    .push(CreatePostRoute(companyId: state.companyId));
              },
              child: const Icon(Icons.add)),
        );
      },
    );
  }
}

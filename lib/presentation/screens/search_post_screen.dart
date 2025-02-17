import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/app_locater.dart';
import '../../config/app_router.dart';
import '../../data/post_repo.dart';
import '../cubits/search_post/search_post_cubit.dart';
import '../widgets/post_list.dart';

@RoutePage()
class SearchPostScreen extends StatelessWidget {
  final String companyId;

  const SearchPostScreen({super.key, this.companyId = 'general'});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchPostCubit(locator<PostRepo>(), companyId),
      child: _SearchPostView(),
    );
  }
}

class _SearchPostView extends StatelessWidget {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  _SearchPostView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchPostCubit, SearchPostState>(
      listener: (context, state) {
        if (state is SearchPostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search Posts'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (query) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      context
                          .read<SearchPostCubit>()
                          .searchPosts(_searchController.text);
                    });
                  },
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.posts?.isNotEmpty == true)
                    RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<SearchPostCubit>()
                              .searchPosts(_searchController.text);
                        },
                        child: PostList(
                          itemList: state.posts!,
                          onPostTap: (postId) {
                            context.router.push(ViewPostRoute(postId: postId));
                          },
                          onPostLikeTap: (postId) {
                            context.read<SearchPostCubit>().likePost(postId);
                          },
                          onPollOptionTap: (postId, idx) {
                            context
                                .read<SearchPostCubit>()
                                .selectPollOption(postId, idx);
                          },
                        ))
                  else
                    Center(child: Text('No posts available')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

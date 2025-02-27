import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../config/app_locater.dart';
import '../../config/app_router.dart';
import '../../data/model/post.dart';
import '../../data/model/post_comment.dart';
import '../../data/post_repo.dart';
import '../cubits/view_post/view_post_cubit.dart';

@RoutePage()
class ViewPostScreen extends StatelessWidget {
  final String postId;
  const ViewPostScreen(this.postId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewPostCubit(locator<PostRepo>())..getPost(postId),
      child: ViewPostView(),
    );
  }
}

class ViewPostView extends StatelessWidget {
  ViewPostView({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewPostCubit, ViewPostState>(
      listener: (context, state) {
        if (state is ViewPostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        var focusNode = FocusNode();

        return Scaffold(
            appBar: AppBar(),
            body: state.post == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Posted ${timeago.format(state.post!.dateOfCreation)} in General by ${state.post!.author}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              _buildPostViewer(context, state),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      context
                                          .read<ViewPostCubit>()
                                          .likePost(state.post!.postId);
                                    },
                                    label: Text(state.post!.claps.toString()),
                                    icon: const Icon(Icons.thumb_up),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      focusNode.requestFocus();
                                    },
                                    icon: const Icon(Icons.comment),
                                    label: Text(
                                        state.post!.comments.length.toString()),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Comments',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextField(
                              focusNode: focusNode,
                              controller: _controller,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Add a comment',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (value) {
                                if (value.isEmpty) return;
                                context
                                    .read<ViewPostCubit>()
                                    .addComment(state.post!.postId, value);
                                _controller.setText('');
                              },
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final comment = state.post!.comments[index];
                              return _buildComment(context, comment,
                                  state.post!.postId, focusNode);
                            },
                            childCount: state.post!.comments.length,
                          ),
                        ),
                      ],
                    ),
                  ));
      },
    );
  }

  Widget _buildComment(
    BuildContext context,
    PostComment comment,
    String postId,
    FocusNode focusNode,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Text(comment.author[0].toUpperCase()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${comment.author} • ${timeago.format(comment.date)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
                Text(comment.body),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context
                            .read<ViewPostCubit>()
                            .likeComment(postId, comment.id);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      label: Text('${comment.claps} Likes'),
                      icon: const Icon(
                        Icons.thumb_up_outlined,
                        size: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller.text = '@${comment.author} ';
                        focusNode.requestFocus();
                      },
                      icon: const Icon(Icons.comment_outlined),
                      iconSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostViewer(BuildContext context, ViewPostState state) {
    return state.post != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.post!.postTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              if (state.post is ImagePost)
                _buildImageViewer(context, state.post as ImagePost),
              if (state.post is TextPost)
                _buildTextViewer(context, state.post as TextPost),
              if (state.post is PollPost)
                _buildPollViewer(context, state.post as PollPost),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildImageViewer(BuildContext context, ImagePost post) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Center(
          child: Image.file(
            File(post.imageUrl),
            height: 200,
          ),
        ),
      ),
      onTap: () {
        context.router.push(
          ImageViewerRoute(image: post.imageUrl),
        );
      },
    );
  }

  Widget _buildTextViewer(BuildContext context, TextPost post) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        post.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildPollViewer(BuildContext context, PollPost post) {
    final totalVotes = post.votes.fold(0, (a, b) => a + b);
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            ...post.options.indexed.map((option) {
              final votePercentage = totalVotes > 0
                  ? (post.votes[option.$1] / totalVotes * 100)
                      .toStringAsFixed(0)
                  : '0';
              return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(option.$2),
                    trailing: Text('$votePercentage%'),
                    leadingAndTrailingTextStyle:
                        Theme.of(context).textTheme.bodyLarge,
                    onTap: () {
                      context
                          .read<ViewPostCubit>()
                          .selectPollOption(post.postId, option.$1);
                    },
                  ));
            }),
          ],
        ));
  }
}

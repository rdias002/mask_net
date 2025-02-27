import 'dart:io';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/model/post.dart';

class PostList extends StatelessWidget {
  final List<Post> itemList;
  final Function(String)? onPostTap;
  final Function(String)? onPostLikeTap;
  final Function(String, int)? onPollOptionTap;
  final Function(String)? onFilterSelected;
  final Function(String)? onSortSelected;
  const PostList({
    super.key,
    required this.itemList,
    this.onPostTap,
    this.onPostLikeTap,
    this.onPollOptionTap,
    this.onFilterSelected,
    this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    int delta = onSortSelected == null && onFilterSelected == null ? 0 : 1;
    return ListView.builder(
      itemCount: itemList.length + delta,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onFilterSelected != null)
                PopupMenuButton<String>(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(value: 'All', child: Text('All')),
                      const PopupMenuItem(value: 'Text', child: Text('Text')),
                      const PopupMenuItem(value: 'Image', child: Text('Image')),
                      const PopupMenuItem(value: 'Poll', child: Text('Poll')),
                    ];
                  },
                  onSelected: onFilterSelected,
                  child: TextButton.icon(
                    label: const Text('Filter'),
                    icon: const Icon(Icons.filter_list),
                    onPressed: null,
                    style: TextButton.styleFrom(
                      disabledForegroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              if (onSortSelected != null)
                PopupMenuButton<String>(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                          value: 'Newest', child: Text('Newest')),
                      const PopupMenuItem(
                          value: 'Oldest', child: Text('Oldest')),
                      const PopupMenuItem(
                          value: 'Most Likes', child: Text('Most Likes')),
                    ];
                  },
                  onSelected: onSortSelected,
                  child: TextButton.icon(
                    label: const Text('Sort'),
                    icon: const Icon(Icons.sort),
                    onPressed: null,
                    style: TextButton.styleFrom(
                      disabledForegroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          );
        }
        final post = itemList[index - delta];
        return InkWell(
          onTap: () {
            onPostTap?.call(post.postId);
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: _buildPostView(context, post),
          ),
        );
      },
    );
  }

  Widget _buildPostView(BuildContext context, Post post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${post.channelId} • ${timeago.format(post.dateOfCreation)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(post.postTitle, style: Theme.of(context).textTheme.titleMedium),
        if (post is ImagePost) _buildImageViewer(context, post),
        if (post is TextPost) _buildTextViewer(context, post),
        if (post is PollPost) _buildPollViewer(context, post),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                onPostLikeTap?.call(post.postId);
              },
              label: Text(post.claps.toString()),
              icon: const Icon(Icons.thumb_up),
            ),
            TextButton.icon(
              onPressed: () {
                onPostTap?.call(post.postId);
              },
              icon: const Icon(Icons.comment),
              label: Text(post.commentCount.toString()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageViewer(BuildContext context, ImagePost post) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(post.imageUrl),
        ),
      ),
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
              final votePercentage = totalVotes == 0
                  ? '0'
                  : (post.votes[option.$1] / totalVotes * 100)
                      .toStringAsFixed(0);
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
                      onPollOptionTap?.call(post.postId, option.$1);
                    },
                  ));
            }),
          ],
        ));
  }
}

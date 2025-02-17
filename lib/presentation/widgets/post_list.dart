import 'dart:io';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/model/post.dart';

class PostList extends StatelessWidget {
  final List<Post> itemList;
  final Function(String)? onPostTap;
  final Function(String)? onPostLikeTap;
  final Function(String, int)? onPollOptionTap;
  const PostList(
      {super.key,
      required this.itemList,
      this.onPostTap,
      this.onPostLikeTap,
      this.onPollOptionTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final post = itemList[index];
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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config/exception_wrapper.dart';
import '../config/logger.dart';
import '../config/result.dart';
import 'model/post.dart';
import 'model/post_comment.dart';

class PostRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseDb = FirebaseFirestore.instance;

  Future<Result<String>> createPost(
    String companyId,
    String type,
    String title,
    String body,
    File? image,
    List<String> polls,
  ) async {
    try {
      switch (type) {
        case textPostType:
          return _createTextPost(companyId, title, body);
        case imagePostType:
          return _createImagePost(companyId, title, image!);
        case pollPostType:
          return _createPollPost(companyId, title, polls);
        default:
          return ResultFailed(ExceptionWrapper(
            message: 'Invalid post type.',
          ));
      }
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<String>> _createTextPost(
    String companyId,
    String title,
    String body,
  ) async {
    final post = TextPost(
      postTitle: title,
      content: body,
      postId: '',
      author: firebaseAuth.currentUser!.displayName!,
      channelId: companyId,
      dateOfCreation: DateTime.now(),
      comments: [],
      commentCount: 0,
      claps: 0,
    );
    final result = await firebaseDb.collection('posts').add(post.toJson());
    result.update({'postId': result.id});
    logger.i('Post created with id: ${result.id}');
    return ResultSuccess(result.id);
  }

  Future<Result<String>> _createImagePost(
    String companyId,
    String title,
    File image,
  ) async {
    final post = ImagePost(
      postTitle: title,
      imageUrl: image.path,
      postId: '',
      author: firebaseAuth.currentUser!.displayName!,
      channelId: companyId,
      dateOfCreation: DateTime.now(),
      comments: [],
      commentCount: 0,
      claps: 0,
    );
    final result = await firebaseDb.collection('posts').add(post.toJson());
    result.update({'postId': result.id});
    logger.i('Post created with id: ${result.id}');
    return ResultSuccess(result.id);
  }

  Future<Result<String>> _createPollPost(
    String companyId,
    String title,
    List<String> polls,
  ) async {
    final post = PollPost(
      postTitle: title,
      options: polls,
      votes: List.filled(polls.length, 0),
      postId: '',
      author: firebaseAuth.currentUser!.displayName!,
      channelId: companyId,
      dateOfCreation: DateTime.now(),
      comments: [],
      commentCount: 0,
      claps: 0,
    );
    final result = await firebaseDb.collection('posts').add(post.toJson());
    result.update({'postId': result.id});
    logger.i('Post created with id: ${result.id}');
    return ResultSuccess(result.id);
  }

  Future<Result<void>> addPostClap(String postId) async {
    try {
      final post = await firebaseDb.collection('posts').doc(postId).get();
      await post.reference.update({'claps': (post.data()?['claps'] ?? 0) + 1});

      return const ResultSuccess(null);
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<List<int>>> selectPollOption(String postId, int index) async {
    try {
      final post = await firebaseDb.collection('posts').doc(postId).get();
      final selected = await post.reference
          .collection('votes')
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      final votes = (post.data()?['votes'] as List<dynamic>)
          .map((e) => e as int)
          .toList();

      if (selected.exists) {
        final option = selected.data()?['option'] as int;
        votes[option] = votes[option] - 1;
        votes[index] = votes[index] + 1;
        await post.reference.update({'votes': votes});
        await selected.reference.update({'option': index});
      } else {
        votes[index] = votes[index] + 1;
        await post.reference.update({'votes': votes});
        await post.reference
            .collection('votes')
            .doc(firebaseAuth.currentUser!.uid)
            .set({
          'option': index,
        });
      }

      return ResultSuccess(votes);
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<PostComment>> addPostComment(
      String postId, String comment) async {
    try {
      final postComment = PostComment(
          id: "",
          body: comment,
          author: firebaseAuth.currentUser!.displayName!,
          date: DateTime.now());
      final post = await firebaseDb.collection('posts').doc(postId).get();

      post.reference.update({
        'commentCount': (post.data()?['commentCount'] ?? 0) + 1,
      });

      final result =
          await post.reference.collection('comments').add(postComment.toJson());

      result.update({'id': result.id});
      logger.i('Comment added with id: ${result.id}');

      return ResultSuccess(postComment.copyWith(id: result.id));
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<List<Post>>> getPosts(
      {String userId = '', String companyId = ''}) async {
    try {
      var query = firebaseDb
          .collection('posts')
          .orderBy('dateOfCreation', descending: true);
      if (userId.isNotEmpty) {
        query = query.where('author', isEqualTo: userId);
      }
      if (companyId.isNotEmpty) {
        query = query.where('channelId', isEqualTo: companyId);
      }
      final result = await query.get();
      final comments = await Future.wait(result.docs
          .map((e) => e.reference.collection('comments').count().get())
          .toList());

      final posts = result.docs.asMap().entries.map((e) {
        final data = e.value.data();
        data['commentCount'] = comments[e.key].count;
        return Post.fromJson(data);
      }).toList();

      return ResultSuccess(posts);
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<List<Post>>> searchPosts(
      {required String searchQuery, String companyId = ''}) async {
    try {
      var query = firebaseDb
          .collection('posts')
          .where('postTitle', isGreaterThanOrEqualTo: searchQuery)
          .orderBy('dateOfCreation', descending: true);

      if (companyId.isNotEmpty) {
        query = query.where('channelId', isEqualTo: companyId);
      }

      final result = await query.get();
      final comments = await Future.wait(result.docs
          .map((e) => e.reference.collection('comments').count().get())
          .toList());

      final posts = result.docs.asMap().entries.map((e) {
        final data = e.value.data();
        data['commentCount'] = comments[e.key].count;
        return Post.fromJson(data);
      }).toList();

      return ResultSuccess(posts);
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<Result<Post>> getPost(String postId) async {
    try {
      final result = await firebaseDb.collection('posts').doc(postId).get();
      final comments = await result.reference
          .collection('comments')
          .orderBy('date', descending: true)
          .get();

      final data = result.data()!;
      data['comments'] = comments.docs.map((e) => e.data()).toList();

      final post = Post.fromJson(data);

      return ResultSuccess(post);
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return ResultFailed(ExceptionWrapper(
        message: 'Something went wrong. Please try again.',
      ));
    }
  }
}

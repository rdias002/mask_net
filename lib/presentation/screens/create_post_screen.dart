import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/app_locater.dart';
import '../../config/app_router.dart';
import '../../data/model/companies.dart';
import '../../data/model/post.dart';
import '../../data/post_repo.dart';
import '../cubits/create_post/create_post_cubit.dart';
import '../widgets/poll_creator.dart';

@RoutePage()
class CreatePostScreen extends StatelessWidget {
  final String companyId;
  const CreatePostScreen({super.key, this.companyId = channelGeneral});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostCubit(locator<PostRepo>(), companyId),
      child: _CreatePostView(),
    );
  }
}

class _CreatePostView extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is CreatePostSuccess) {
          context.router.replace(ViewPostRoute(postId: state.postId));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            actions: [
              TextButton(
                onPressed: () {
                  String title = _titleController.text;
                  String content = _contentController.text;
                  context.read<CreatePostCubit>().createPost(
                        title,
                        content,
                        state.imageUrl,
                        state.polls,
                      );
                },
                child: Icon(
                  Icons.save,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (state.postType == imagePostType)
                      buildImagePicker(context, state)
                    else if (state.postType == pollPostType)
                      buildPollCreator()
                    else
                      buildTextField(),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.text_fields,
                            color: state.postType == textPostType
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          onPressed: () {
                            context
                                .read<CreatePostCubit>()
                                .setPostType(textPostType);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.image,
                            color: state.postType == imagePostType
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          onPressed: () {
                            context
                                .read<CreatePostCubit>()
                                .setPostType(imagePostType);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.poll,
                            color: state.postType == pollPostType
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          onPressed: () {
                            context
                                .read<CreatePostCubit>()
                                .setPostType(pollPostType);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  Widget buildTextField() {
    return TextField(
      controller: _contentController,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      decoration: const InputDecoration(
          hintText: 'Content',
          border: OutlineInputBorder(),
          constraints: BoxConstraints(minHeight: 200, maxHeight: 200)),
      maxLines: 10,
    );
  }

  Widget buildImagePicker(BuildContext context, CreatePostState state) {
    return InkWell(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: state.imageUrl.isEmpty
              ? Text(
                  'Add Image',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 40),
                    Image.file(
                      File(state.imageUrl),
                      height: 200,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<CreatePostCubit>().setImage('');
                      },
                    )
                  ],
                ),
        ),
      ),
      onTap: () => _pickImage(context),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (context.mounted && pickedFile != null) {
      context.read<CreatePostCubit>().setImage(pickedFile.path);
    }
  }

  Widget buildPollCreator() {
    return const PollCreator();
  }
}

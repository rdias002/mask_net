import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/create_post/create_post_cubit.dart';

class PollCreator extends StatefulWidget {
  const PollCreator({super.key});

  @override
  State<PollCreator> createState() => _PollCreatorState();
}

class _PollCreatorState extends State<PollCreator> {
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final int _maxOptions = 5;

  @override
  void dispose() {
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    if (_optionControllers.length < _maxOptions) {
      setState(() {
        _optionControllers.add(TextEditingController());
        context.read<CreatePostCubit>().setPolls(
              _optionControllers.map((e) => e.text).toList(),
            );
      });
    }
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers.removeAt(index).dispose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minHeight: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            ..._optionControllers.asMap().entries.map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          context.read<CreatePostCubit>().setPolls(
                                _optionControllers.map((e) => e.text).toList(),
                              );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => _removeOption(index),
                    ),
                  ],
                ),
              );
            }),
            if (_optionControllers.length < _maxOptions)
              ElevatedButton(
                onPressed: _addOption,
                child: const Text('Add Option'),
              ),
          ],
        ));
  }
}

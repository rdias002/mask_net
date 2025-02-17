import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_net/config/app_locater.dart';
import 'package:mask_net/data/auth_repo.dart';

import '../cubits/username/choose_user_name_cubit.dart';

@RoutePage()
class ChooseUserNameScreen extends StatelessWidget {
  final Function(bool)? isSuccess;

  const ChooseUserNameScreen({super.key, this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ChooseUserNameCubit(locator<AuthRepo>()),
        child: _ChooseUserNameView(isSuccess));
  }
}

class _ChooseUserNameView extends StatelessWidget {
  final Function(bool)? isSuccess;
  _ChooseUserNameView(this.isSuccess);

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseUserNameCubit, ChooseUserNameState>(
        listener: (context, state) {
          if (state is ChooseUserNameError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is ChooseUserNameSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Username created successfully.'),
              ),
            );
            isSuccess?.call(true);
          }
        },
        builder: (context, state) => Material(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Choose Username'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'User account created successfully. Now create a unique anonymous username',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChooseUserNameCubit>().saveUserName(
                                    _controller.text,
                                  );
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                      if (state.isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

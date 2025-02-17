import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_locater.dart';
import '../../config/app_router.dart';
import '../../data/auth_repo.dart';
import '../cubits/sign_up/sign_up_cubit.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  final Function(bool)? isSuccess;

  const SignUpScreen({super.key, this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(locator<AuthRepo>()),
      child: _SignUpView(
        isSuccess: isSuccess,
      ),
    );
  }
}

class _SignUpView extends StatelessWidget {
  final Function(bool)? isSuccess;

  _SignUpView({super.key, this.isSuccess});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is SignUpSuccess) {
            context.router.replace(ChooseUserNameRoute(isSuccess: isSuccess));
          }
        },
        builder: (context, state) => Material(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Create an account'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              context.read<SignUpCubit>().signUp(
                                  _emailController.text,
                                  _passwordController.text,
                                  _confirmPasswordController.text);
                            },
                            child: const Text('Sign Up'),
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

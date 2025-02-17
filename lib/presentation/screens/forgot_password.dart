import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_locater.dart';
import '../../data/auth_repo.dart';
import '../cubits/forgot_password/forgot_password_cubit.dart';

@RoutePage()
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(locator<AuthRepo>()),
      child: _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  _ForgotPasswordView();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please check email for password reset link'),
              ),
            );
            context.router.back();
          }
        },
        builder: (context, state) => Material(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Reset Password'),
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
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ForgotPasswordCubit>()
                                  .sendResetPasswordLink(_emailController.text);
                            },
                            child: const Text('Send Password Reset Email'),
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

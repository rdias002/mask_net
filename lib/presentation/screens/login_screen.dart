import 'package:flutter/material.dart';
import '../../config/app_router.dart';
import '../../config/app_locater.dart';
import '../../data/auth_repo.dart';
import '../cubits/login/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  final Function(bool)? isSuccess;

  const LoginScreen({super.key, this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(locator<AuthRepo>()),
      child: _LoginView(isSuccess),
    );
  }
}

class _LoginView extends StatelessWidget {
  final Function(bool)? isSuccess;

  _LoginView(this.isSuccess);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is LoginSuccess) {
          isSuccess?.call(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mask Net'),
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
                    ElevatedButton(
                      onPressed: () {
                        context.read<LoginCubit>().login(
                              _emailController.text,
                              _passwordController.text,
                            );
                      },
                      child: const Text('Login'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.router.push(const ForgotPasswordRoute());
                          },
                          child: const Text('Forgot Password'),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            context.router
                                .push(SignUpRoute(isSuccess: isSuccess));
                          },
                          child: const Text('Create an account'),
                        ),
                      ],
                    )
                  ],
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

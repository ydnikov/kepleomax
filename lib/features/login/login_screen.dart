import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_button.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/core/presentation/validators.dart';

import 'package:kepleomax/features/login/bloc/login_bloc.dart';
import 'package:kepleomax/features/login/bloc/login_state.dart';

/// screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) =>
          LoginBloc(authController: Dependencies.of(context).authController),
      child: const _Body(key: Key('login_body')),
    );
  }
}

/// body
class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// callbacks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// listeners
  void _updateControllers(LoginData state) {
    _emailController.text = state.email;
    _passwordController.text = state.password;
    _confirmPasswordController.text = state.confirmPassword;
    setState(() {});
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      buildWhen: (oldState, newState) {
        if (newState is! LoginStateBase) return false;

        if (oldState is! LoginStateBase) return true;

        return oldState.data != newState.data;
      },
      listener: (context, state) {
        if (state is LoginStateError) {
          context.showSnackBar(text: state.message, color: KlmColors.errorRed);
        }

        if (state is LoginStateBase && state.updateControllers) {
          _updateControllers(state.data);
        }
      },
      builder: (context, state) {
        if (state is! LoginStateBase) return const SizedBox();

        final data = state.data;
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'KepLeoMax',
                    style: context.textTheme.bodyMedium?.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 52),
                  KlmTextField(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    validators: [loginEmailValidator],
                    onChanged: (text) {
                      context.read<LoginBloc>().add(
                        LoginEventEditEmail(email: text),
                      );
                    },
                    label: 'Email',
                    showErrors: data.isButtonPressed,
                    readOnly: data.isLoading,
                  ),
                  const SizedBox(height: 20),
                  KlmTextField(
                    controller: _passwordController,
                    validators: [loginPasswordValidator],
                    onChanged: (text) {
                      context.read<LoginBloc>().add(
                        LoginEventEditPassword(password: text),
                      );
                    },
                    label: 'Password',
                    isPassword: true,
                    showErrors: data.isButtonPressed,
                    readOnly: data.isLoading,
                  ),
                  const SizedBox(height: 20),
                  if (data.screenState is LoginScreenRegister)
                    KlmTextField(
                      controller: _confirmPasswordController,
                      validators: [
                        UiValidator.createConfirmPasswordValidator(
                          _passwordController,
                        ),
                      ],
                      onChanged: (text) {
                        context.read<LoginBloc>().add(
                          LoginEventEditConfirmPassword(confirmPassword: text),
                        );
                      },
                      label: 'Confirm password',
                      isPassword: true,
                      showErrors: data.isButtonPressed,
                      readOnly: data.isLoading,
                    ),
                  const SizedBox(height: 40),
                  KlmButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(
                        data.screenState.event(),
                      );
                    },
                    text: data.screenState.buttonText(),
                    width: 200,
                    isLoading: data.isLoading,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: data.isLoading
                        ? null
                        : () {
                            context.read<LoginBloc>().add(
                              LoginEventChangeScreenState(
                                data.screenState.subButtonNextState(),
                              ),
                            );
                          },
                    style: TextButton.styleFrom(
                      overlayColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      data.screenState.subButtonText(),
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: data.isLoading
                            ? Colors.grey.shade600
                            : Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

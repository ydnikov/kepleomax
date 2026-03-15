import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/presentation/klm_button.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/core/presentation/validators.dart';
import 'package:kepleomax/features/login/bloc/login_bloc.dart';
import 'package:kepleomax/features/login/bloc/login_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) =>
            LoginBloc(authController: Dependencies.of(context).authController),
        child: const _Body(key: Key('login_body')),
      ),
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

  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _showConfirmPasswordError = false;

  String? _version;

  /// callbacks
  @override
  void initState() {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = info.version;
      });
    });
    super.initState();
  }

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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 144),
                  const Text(
                    'KepLeoMax',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: data.stage.isSignIn
                              ? "Don't have an account? "
                              : 'Already have an account? ',
                        ),
                        TextSpan(
                          text: data.stage.isSignIn ? 'Sign up' : 'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue.shade800,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = data.isLoading
                                ? null
                                : () {
                                    context.read<LoginBloc>().add(
                                      LoginEventChangeScreenStage(
                                        data.stage.isSignIn
                                            ? LoginStage.signUp
                                            : LoginStage.signIn,
                                      ),
                                    );
                                  },
                        ),
                      ],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 52),
                  KlmTextField(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    validators: const [loginEmailValidator],
                    onChanged: (text) {
                      context.read<LoginBloc>().add(
                        LoginEventEditEmail(email: text),
                      );
                      if (_showEmailError && text.isNotEmpty) {
                        setState(() {
                          _showEmailError = false;
                        });
                      }
                    },
                    onFocusLost: () {
                      setState(() {
                        _showEmailError = true;
                      });
                    },
                    label: 'Email',
                    showErrors: _showEmailError,
                    readOnly: data.isLoading,
                  ),
                  const SizedBox(height: 20),
                  KlmTextField(
                    controller: _passwordController,
                    validators: const [loginPasswordValidator],
                    onChanged: (text) {
                      context.read<LoginBloc>().add(
                        LoginEventEditPassword(password: text),
                      );
                      if (!_showPasswordError) {
                        setState(() {
                          _showPasswordError = true;
                        });
                      }
                    },
                    label: 'Password',
                    isPassword: true,
                    showErrors: _showPasswordError,
                    readOnly: data.isLoading,
                  ),
                  const SizedBox(height: 20),
                  if (data.stage.isSignUp)
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
                        if (!_showConfirmPasswordError) {
                          setState(() {
                            _showConfirmPasswordError = true;
                          });
                        }
                      },
                      label: 'Confirm password',
                      isPassword: true,
                      showErrors: _showConfirmPasswordError,
                      readOnly: data.isLoading,
                    ),
                  const SizedBox(height: 60),
                  Center(
                    child: KlmButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          data.stage.isSignIn
                              ? const LoginEventSignIn()
                              : const LoginEventSignUp(),
                        );
                      },
                      text: data.stage.isSignIn ? 'Sign in' : 'Sign up',
                      width: 200,
                      isLoading: data.isLoading,
                    ),
                  ),
                  const Spacer(),
                  if (_version != null) Center(
                    child: Text(
                      'v.${_version!}',
                      style: context.textTheme.bodyMedium?.copyWith(fontSize: 14),
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/presentation/klm_text_button.dart';
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
      resizeToAvoidBottomInset: true,
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

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _passwordRequestedFocus = false;

  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _showConfirmPasswordError = false;

  /// callbacks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
                  //const SizedBox(height: 90),
                  // KeyboardVisibilityBuilder(
                  //   builder: (context, isVisible) => AnimatedContainer(
                  //     duration: const Duration(milliseconds: 100),
                  //     height: isVisible
                  //         ? (data.stage.isSignUp ? 6 : 50)
                  //         : context.screenSize.height * 0.15,
                  //     curve: Curves.easeInOut,
                  //     // child: isVisible
                  //     //     ? SizedBox(height: data.stage.isSignUp ? 6 : 50)
                  //     //     : const Spacer(),
                  //   ),
                  // ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      text: 'KepLeo',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Max',
                          style: TextStyle(
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Color(0xFF40cefe),
                                  Color(0xFF272fba),
                                  Color(0xFFa02be1),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment(1, 0.4),
                                stops: [0, 0.5, 1],
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const Text(
                  //   'KepLeoMax',
                  //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  // ),
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
                            color: KlmColors.link,
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
                  const SizedBox(height: 32),
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

                      if ((text.endsWith('.com') || text.endsWith('.ru')) &&
                          loginEmailValidator(text) == null) {
                        _requestFocusToPassword(data.stage);
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
                    focusNode: _passwordFocusNode,
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
                  if (data.stage.isSignUp) ...[
                    KlmTextField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
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
                    const SizedBox(height: 20),
                  ],
                  if (data.stage.isSignIn)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Fluttertoast.showToast(msg: 'Not working');
                        },
                        child: Text(
                          'Reset password',
                          style: TextStyle(
                            fontSize: 11,
                            color: KlmColors.link,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(flex: 2),
                  Center(
                    child: KlmTextButton(
                      onPressed: () {
                        setState(() {
                          _showEmailError = true;
                          _showPasswordError = true;
                          _showConfirmPasswordError = true;
                        });

                        context.read<LoginBloc>().add(
                          data.stage.isSignIn
                              ? const LoginEventSignIn()
                              : const LoginEventSignUp(),
                        );
                      },
                      text: data.stage.isSignIn ? 'Sign in' : 'Sign up',
                      isLoading: data.isLoading,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const _VersionWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _requestFocusToPassword(LoginStage stage) {
    if (_passwordRequestedFocus) return;

    _passwordRequestedFocus = true;
    if (loginPasswordValidator(_passwordController.text) != null) {
      _passwordFocusNode.requestFocus();
    } else if (stage.isSignUp &&
        (loginPasswordValidator(_confirmPasswordController.text) != null ||
            loginConfirmPasswordValidator(
                  confirmPassword: _confirmPasswordController.text,
                  password: _passwordController.text,
                ) !=
                null)) {
      _confirmPasswordFocusNode.requestFocus();
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

class _VersionWidget extends StatelessWidget {
  const _VersionWidget();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, sn) {
        if (!sn.hasData || sn.hasError) return const SizedBox();

        return KeyboardVisibilityBuilder(
          builder: (context, isVisible) => isVisible
              ? const SizedBox()
              : Center(
                  child: Text(
                    'v.${sn.data!.version}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

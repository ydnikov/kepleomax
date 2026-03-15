import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// states
abstract class LoginState {}

@freezed
abstract class LoginStateBase with _$LoginStateBase implements LoginState {
  const factory LoginStateBase({
    required LoginData data,
    @Default(false) bool updateControllers,
  }) = _LoginStateBase;

  factory LoginStateBase.initial() => LoginStateBase(data: LoginData.initial());
}

@freezed
abstract class LoginStateError with _$LoginStateError implements LoginState {
  const factory LoginStateError({required String message}) = _LoginStateError;
}

/// data
@freezed
abstract class LoginData with _$LoginData {
  const factory LoginData({
    required String email,
    required String password,
    required String confirmPassword,
    required bool isButtonPressed,
    required bool isLoading,
    required LoginStage stage,
  }) = _LoginData;

  factory LoginData.initial() => const LoginData(
    email: '',
    password: '',
    confirmPassword: '',
    isButtonPressed: false,
    isLoading: false,
    stage: LoginStage.signIn,
  );
}

/// state object
enum LoginStage {
  signIn,
  signUp;

  bool get isSignIn => this == LoginStage.signIn;

  bool get isSignUp => this == LoginStage.signUp;
}

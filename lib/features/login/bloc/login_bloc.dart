import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/auth/auth_controller.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/core/presentation/validators.dart';
import 'package:kepleomax/features/login/bloc/login_state.dart';

const UiValidator loginEmailValidator = UiValidators.emailValidator;
const UiValidator loginPasswordValidator = UiValidators.passwordValidator;
const String? Function({required String confirmPassword, required String password})
loginConfirmPasswordValidator = UiValidators.confirmPasswordValidator;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthController authController})
    : _authController = authController,
      super(LoginStateBase.initial()) {
    _loginData = LoginData.initial();

    on<LoginEvent>(
      (event, emit) => switch (event) {
        final LoginEventSignIn event => _onSignIn(event, emit),
        final LoginEventSignUp event => _onSignUp(event, emit),
        _ => () {},
      },
      transformer: sequential(),
    );
    on<LoginEventEditEmail>(_onEditEmail);
    on<LoginEventEditPassword>(_onEditPassword);
    on<LoginEventEditConfirmPassword>(_onEditConfirmPassword);
    on<LoginEventChangeScreenStage>(_onChangeScreenStage);
  }

  final AuthController _authController;

  late LoginData _loginData;

  bool _validateFields({required bool needConfirm}) {
    if (loginEmailValidator(_loginData.email) != null ||
        loginPasswordValidator(_loginData.password) != null) {
      return false;
    } else if (needConfirm &&
        loginConfirmPasswordValidator(
              password: _loginData.password,
              confirmPassword: _loginData.confirmPassword,
            ) !=
            null) {
      return false;
    }

    return true;
  }

  Future<void> _onSignIn(LoginEventSignIn event, Emitter<LoginState> emit) async {
    if (!_validateFields(needConfirm: false)) {
      logger.d('Validation fields error, _loginData: $_loginData');
      return;
    }

    try {
      _loginData = _loginData.copyWith(isLoading: true);
      emit(LoginStateBase(data: _loginData));

      await _authController.login(
        email: _loginData.email,
        password: _loginData.password,
      );
      _loginData = LoginData.initial();
      emit(LoginStateBase(data: _loginData));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(LoginStateError(message: e.userErrorMessage));
    } finally {
      _loginData = _loginData.copyWith(isLoading: false);
      emit(LoginStateBase(data: _loginData));
    }
  }

  Future<void> _onSignUp(LoginEventSignUp event, Emitter<LoginState> emit) async {
    _loginData = _loginData.copyWith();
    emit(LoginStateBase(data: _loginData));

    if (!_validateFields(needConfirm: true)) {
      logger.e('Validation fields error, _loginData: $_loginData');
      return;
    }

    try {
      _loginData = _loginData.copyWith(isLoading: true);
      emit(LoginStateBase(data: _loginData));

      await _authController.registerUser(
        email: _loginData.email,
        password: _loginData.password,
      );

      try {
        await _authController.login(
          email: _loginData.email,
          password: _loginData.password,
        );
      } catch (e, st) {
        logger.e(e, stackTrace: st);
        _loginData = _loginData.copyWith(
          stage: LoginStage.signIn,
          confirmPassword: '',
        );

        throw Exception(
          'The user is created, but an error occurred while login. Try to login again. Error: ${e}',
        );
      }

      _loginData = LoginData.initial();
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(LoginStateError(message: e.userErrorMessage));
    } finally {
      _loginData = _loginData.copyWith(isLoading: false);
      emit(
        LoginStateBase(
          data: _loginData,
          updateControllers: _loginData.confirmPassword.isEmpty,
        ),
      );
    }
  }

  void _onEditEmail(LoginEventEditEmail event, Emitter<LoginState> emit) {
    _loginData = _loginData.copyWith(email: event.email);
    emit(LoginStateBase(data: _loginData));
  }

  void _onEditPassword(LoginEventEditPassword event, Emitter<LoginState> emit) {
    _loginData = _loginData.copyWith(password: event.password);
    emit(LoginStateBase(data: _loginData));
  }

  void _onEditConfirmPassword(
    LoginEventEditConfirmPassword event,
    Emitter<LoginState> emit,
  ) {
    _loginData = _loginData.copyWith(confirmPassword: event.confirmPassword);
    emit(LoginStateBase(data: _loginData));
  }

  void _onChangeScreenStage(
    LoginEventChangeScreenStage event,
    Emitter<LoginState> emit,
  ) {
    _loginData = _loginData.copyWith(stage: event.stage);
    emit(LoginStateBase(data: _loginData));
  }
}

/// events
abstract class LoginEvent {}

class LoginEventSignIn implements LoginEvent {
  const LoginEventSignIn();
}

class LoginEventSignUp implements LoginEvent {
  const LoginEventSignUp();
}

class LoginEventChangeScreenStage implements LoginEvent {
  const LoginEventChangeScreenStage(this.stage);

  final LoginStage stage;
}

class LoginEventEditEmail implements LoginEvent {
  LoginEventEditEmail({required this.email});

  final String email;
}

class LoginEventEditPassword implements LoginEvent {
  LoginEventEditPassword({required this.password});

  final String password;
}

class LoginEventEditConfirmPassword implements LoginEvent {
  LoginEventEditConfirmPassword({required this.confirmPassword});

  final String confirmPassword;
}

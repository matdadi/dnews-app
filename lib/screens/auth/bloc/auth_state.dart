part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoggedIn,
    @Default(false) bool isObsecure,
    required LoginState loginState,
    required RegisterState registerState,
    required LogoutState logoutState,
  }) = _AuthState;
}

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _LoginInitial;
  const factory LoginState.loading() = _LoginLoading;
  const factory LoginState.success() = _LoginSuccess;
  const factory LoginState.error(String message) = _LoginError;
}

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _RegisterInitial;
  const factory RegisterState.loading() = _RegisterLoading;
  const factory RegisterState.success() = _RegisterSuccess;
  const factory RegisterState.error(String message) = _RegisterError;
}

@freezed
class LogoutState with _$LogoutState {
  const factory LogoutState.initial() = _LogoutInitial;
  const factory LogoutState.loading() = _LogoutLoading;
  const factory LogoutState.success() = _LogoutSuccess;
  const factory LogoutState.error(String message) = _LogoutError;
}

part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.getIsLoggedIn() = _GetIsLoggedIn;
  const factory AuthEvent.toggleObsecure() = _ToggleObsecure;
  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = _Login;

  const factory AuthEvent.register({
    required RegisterParam param,
  }) = _Register;

  const factory AuthEvent.logout() = _Logout;
}

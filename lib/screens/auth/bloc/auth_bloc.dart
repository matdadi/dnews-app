import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/local/preference.dart';
import 'package:deltanews/data/local/repository.dart';
import 'package:deltanews/data/models/register_param.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deltanews/utils/injector.dart' as di;

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _apiService = di.serviceLocator<ApiService>();
  final _repository = di.serviceLocator<Repository>();
  final _preferences = di.serviceLocator<Preferences>();

  AuthBloc()
      : super(const AuthState(
            loginState: _LoginInitial(),
            registerState: _RegisterInitial(),
            logoutState: _LogoutInitial())) {
    on<_ToggleObsecure>(_toggleObsecure);
    on<_GetIsLoggedIn>(_getIsLoggedIn);
    on<_Login>(_login);
    on<_Register>(_register);
    on<_Logout>(_logout);
  }

  Future _getIsLoggedIn(_GetIsLoggedIn event, Emitter<AuthState> emit) async {
    final isLoggedIn = await _preferences.getValue(PreferenceKey.isLoggedIn,
        defaultValue: false);
    emit(state.copyWith(isLoggedIn: isLoggedIn));
  }

  void _toggleObsecure(_ToggleObsecure event, Emitter<AuthState> emit) {
    emit(state.copyWith(isObsecure: !state.isObsecure));
  }

  Future _login(_Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginState: const _LoginLoading()));
    try {
      final response = await _apiService.login(event.email, event.password);
      final result = jsonDecode(response);
      if (result['code'] == 403) {
        if (result['body'] == null) {
          emit(state.copyWith(
              loginState: const _LoginError(
                  "Silahkan periksa kembali email dan password anda.")));
          return;
        } else {
          var body = jsonDecode(result['body']);
          emit(state.copyWith(loginState: _LoginError(body['message'])));
          return;
        }
      }
      if (result['code'] != 200) {
        emit(state.copyWith(loginState: const _LoginError('Gagal Login')));
        return;
      }
      final finalResult = jsonDecode(result['body']);
      await _repository.save(SecureStorageKey.token, finalResult['token']);
      await _repository.save(SecureStorageKey.email, finalResult['user_email']);
      await _repository.save(
          SecureStorageKey.username, finalResult['user_nicename']);
      await _repository.save(
          SecureStorageKey.userDisplay, finalResult['user_display_name']);
      await _preferences.setValue(PreferenceKey.isLoggedIn, true);
      emit(state.copyWith(loginState: const _LoginSuccess()));
    } catch (e) {
      emit(state.copyWith(loginState: _LoginError(e.toString())));
    }
  }

  Future _register(_Register event, Emitter<AuthState> emit) async {
    emit(state.copyWith(registerState: const _RegisterLoading()));
    try {
      final response = await _apiService.register(event.param);
      final result = jsonDecode(response);
      log(result.toString());
      if (result['code'] == 400) {
        var body = jsonDecode(result['body']);
        emit(state.copyWith(registerState: _RegisterError(body['message'])));
        return;
      }
      emit(state.copyWith(registerState: const _RegisterSuccess()));
    } catch (e) {
      emit(state.copyWith(registerState: _RegisterError(e.toString())));
    }
  }

  Future _logout(_Logout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(logoutState: const _LogoutLoading()));
    try {
      await _preferences.setValue(PreferenceKey.isLoggedIn, false);
      await Future.delayed(const Duration(seconds: 3),
              () => emit(state.copyWith(logoutState: const _LogoutLoading())))
          .then((_) {
        emit(state.copyWith(logoutState: const _LogoutSuccess()));
        emit(state.copyWith(logoutState: const _LogoutInitial()));
      });
    } catch (e) {
      emit(state.copyWith(logoutState: _LogoutError(e.toString())));
    }
  }
}

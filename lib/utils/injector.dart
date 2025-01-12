import 'package:deltanews/data/api/api_service.dart';
import 'package:deltanews/data/local/preference.dart';
import 'package:deltanews/data/local/repository.dart';
import 'package:deltanews/screens/auth/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerFactory(() => AuthBloc());

  serviceLocator.registerLazySingleton(() => ApiService());
  serviceLocator.registerLazySingleton(() => Repository());
  serviceLocator.registerLazySingleton(() => Preferences());
}

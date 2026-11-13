import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/users/data/datasources/user_remote_data_source.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/domain/usecases/get_users.dart';
import '../../features/users/presentation/bloc/user_list_bloc.dart';

final sl = GetIt.instance;


Future<void> initDependencies() async {
  // Dio
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    ),
  );

  // Data Source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
  );

  // Use Case
  sl.registerLazySingleton<GetUsers>(
    () => GetUsers(sl<UserRepository>()),
  );

  // BLoC
  sl.registerFactory<UserListBloc>(
    () => UserListBloc(getUsers: sl<GetUsers>()),
  );
}
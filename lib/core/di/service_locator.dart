import 'package:get_it/get_it.dart';
import 'package:isp_app/data/models/datasources/local/local_data_source.dart';
import 'package:isp_app/data/models/datasources/local/local_data_source_impl.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source_impl.dart';
import 'package:isp_app/domain/repositories/auth_repository_impl.dart';
import 'package:isp_app/domain/repositories/auth_repository.dart';
import 'package:isp_app/domain/repositories/user_repository.dart';
import 'package:isp_app/domain/repositories/user_repository_impl.dart';
import 'package:isp_app/domain/usecases/get_user_data.dart';
import 'package:isp_app/domain/usecases/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data sources
  getIt.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());
  getIt.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUser(getIt()));
  getIt.registerLazySingleton(() => GetUserData(getIt()));
}
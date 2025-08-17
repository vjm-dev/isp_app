import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:isp_app/data/models/datasources/local/local_data_source.dart';
import 'package:isp_app/data/models/datasources/local/local_data_source_impl.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source_impl.dart';
import 'package:isp_app/domain/repositories/auth_repository.dart';
import 'package:isp_app/domain/repositories/auth_repository_impl.dart';
import 'package:isp_app/domain/repositories/data_repository.dart';
import 'package:isp_app/domain/repositories/data_repository_impl.dart';
import 'package:isp_app/domain/repositories/user_repository.dart';
import 'package:isp_app/domain/repositories/user_repository_impl.dart';
import 'package:isp_app/domain/usecases/get_user_data.dart';
import 'package:isp_app/domain/usecases/login_user.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';
import 'package:isp_app/presentation/controllers/home_controller.dart';
import 'package:isp_app/presentation/controllers/theme_controller.dart';
import 'package:isp_app/presentation/controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);

  // Data sources
  Get.lazyPut<LocalDataSource>(() => LocalDataSourceImpl(sharedPreferences));
  Get.lazyPut<RemoteDataSource>(() => RemoteDataSourceImpl(useMocks: kDebugMode));

  // Repositories
  Get.put<AuthRepository>(AuthRepositoryImpl(
    remoteDataSource: Get.find(),
    localDataSource: Get.find(),
  ));
  
  Get.put<UserRepository>(UserRepositoryImpl(
    remoteDataSource: Get.find(),
    localDataSource: Get.find(),
  ));
  
  Get.lazyPut<DataRepository>(() => DataRepositoryImpl(
    remoteDataSource: Get.find<RemoteDataSource>()
  ));

  // Use cases
  Get.put(LoginUser(Get.find<AuthRepository>()));
  Get.put(GetUserData(Get.find<UserRepository>()));

  // Controllers
  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(Get.find<LoginUser>()), permanent: true);
  Get.put(UserController(Get.find<GetUserData>()), permanent: true);
  Get.put(DataController(Get.find<DataRepository>()), permanent: true);
  Get.put(HomeController(), permanent: true);
}
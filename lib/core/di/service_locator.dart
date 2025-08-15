import 'package:get/get.dart';
import 'package:isp_app/domain/repositories/auth_repository.dart';
import 'package:isp_app/domain/repositories/auth_repository_impl.dart';
import 'package:isp_app/domain/repositories/user_repository.dart';
import 'package:isp_app/domain/repositories/user_repository_impl.dart';
import 'package:isp_app/domain/usecases/get_user_data.dart';
import 'package:isp_app/domain/usecases/login_user.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/home_controller.dart';
import 'package:isp_app/presentation/controllers/theme_controller.dart';
import 'package:isp_app/presentation/controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);

  // Repositories
  Get.put<AuthRepository>(AuthRepositoryImpl(
    remoteDataSource: Get.find(),
    localDataSource: Get.find(),
  ));
  
  Get.put<UserRepository>(UserRepositoryImpl(
    remoteDataSource: Get.find(),
    localDataSource: Get.find(),
  ));

  // Use cases
  Get.put(LoginUser(Get.find<AuthRepository>()));
  Get.put(GetUserData(Get.find<UserRepository>()));

  // Controllers
  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(Get.find<LoginUser>()), permanent: true);
  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(Get.find<LoginUser>()), permanent: true);
  Get.put(UserController(Get.find<GetUserData>()), permanent: true);
  Get.put(HomeController(), permanent: true);
}
import 'package:get/get.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/home_controller.dart';
import 'package:isp_app/presentation/controllers/theme_controller.dart';
import 'package:isp_app/presentation/controllers/user_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Global dependencies
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => AuthController(Get.find()), fenix: true);
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(Get.find()));
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(Get.find()));
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(Get.find()));
  }
}
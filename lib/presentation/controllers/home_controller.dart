import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final AuthController _authController = Get.find();

  @override
  void onInit() {
    super.onInit();
    ever(_authController.user as RxInterface<Object?>, (user) {
      if (user == null) {
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        Get.offAllNamed(AppRoutes.DASHBOARD);
      }
    });
  }
}
import 'package:get/get.dart';
import 'package:isp_app/core/bindings/app_bindings.dart';
import 'package:isp_app/presentation/pages/auth/login_page.dart';
import 'package:isp_app/presentation/pages/auth/password_recovery_page.dart';
import 'package:isp_app/presentation/pages/auth/splash_page.dart';
import 'package:isp_app/presentation/pages/home/dashboard_page.dart';
import 'package:isp_app/presentation/pages/home/home_page.dart';

abstract class AppRoutes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const DASHBOARD = '/dashboard';
  static const PASSWORD_RECOVERY = '/password_recovery';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.PASSWORD_RECOVERY,
      page: () => PasswordRecoveryPage(),
    ),
  ];
}
import 'package:get/get.dart';
import 'package:isp_app/core/bindings/app_bindings.dart';
import 'package:isp_app/presentation/pages/auth/login_page.dart';
import 'package:isp_app/presentation/pages/auth/password_recovery_page.dart';
import 'package:isp_app/presentation/pages/auth/splash_page.dart';
import 'package:isp_app/presentation/pages/home/dashboard_page.dart';
import 'package:isp_app/presentation/pages/home/home_page.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const passwordRecovery = '/password_recovery';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.passwordRecovery,
      page: () => PasswordRecoveryPage(),
    ),
  ];
}
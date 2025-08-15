import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/repositories/auth_repository.dart';
import 'package:isp_app/domain/usecases/login_user.dart';

class AuthController extends GetxController {
  final LoginUser _loginUser;
  final Rx<User?> _user = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  AuthController(this._loginUser);

  User? get user => _user.value;
  bool get isAuthenticated => _user.value != null;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final result = await _loginUser(email, password);
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.snackbar('Error', failure.message);
        },
        (loggedInUser) {
          _user.value = loggedInUser;
          Get.offAllNamed(AppRoutes.HOME);
        },
      );
    } catch (e) {
      errorMessage.value = 'Authentication failed: $e';
      Get.snackbar('Error', 'Authentication failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await Get.find<AuthRepository>().logout();
      _user.value = null;
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkAuthStatus() async {
    isLoading.value = true;
    try {
      final result = await Get.find<AuthRepository>().checkAuthStatus();
      result.fold(
        (failure) => Get.offAllNamed(AppRoutes.LOGIN),
        (user) {
          _user.value = user;
          Get.offAllNamed(AppRoutes.HOME);
        },
      );
    } catch (e) {
      Get.offAllNamed(AppRoutes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recoverPassword(String email) async {
    isLoading.value = true;
    try {
      // Password recovery simulation
      await Future.delayed(const Duration(seconds: 2));
      
      Get.snackbar(
        'Email Sent',
        'Password reset instructions sent to $email',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      Get.offNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send recovery email: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
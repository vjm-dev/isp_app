import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/repositories/auth_repository.dart';
import 'package:isp_app/domain/usecases/login_user.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';

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
        (loggedInUser) async {
          _user.value = loggedInUser;
          
          // Load data usage after successful login
          try {
            final dataController = Get.find<DataController>();
            await dataController.loadDataUsage(loggedInUser.id);
          } catch (e) {
            errorMessage.value = 'Error loading data usage: $e';
            Get.snackbar('Error', 'Error loading data usage: $e');
          }

          Get.offAllNamed(AppRoutes.home);
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
      Get.offAllNamed(AppRoutes.login);
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
        (failure) => Get.offAllNamed(AppRoutes.login),
        (user) async {
          _user.value = user;
          
          // Load data after a successful authentication check
          try {
            final dataController = Get.find<DataController>();
            await dataController.loadDataUsage(user.id);
          } catch (e) {
            errorMessage.value = 'Error loading data usage: $e';
            Get.snackbar('Error', 'Error loading data usage: $e');
          }
          
          Get.offAllNamed(AppRoutes.home);
        },
      );
    } catch (e) {
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recoverPassword(String email) async {
    isLoading.value = true;
    try {
      // TODO: Implement password recovery responses


      // Password recovery simulation
      await Future.delayed(const Duration(seconds: 2));
      
      Get.snackbar(
        'Email Sent',
        'Password reset instructions sent to $email',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      Get.offNamed(AppRoutes.login);
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
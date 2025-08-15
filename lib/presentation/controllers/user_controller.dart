import 'package:get/get.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/usecases/get_user_data.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';

class UserController extends GetxController {
  final GetUserData _getUserData;
  final Rx<User?> _user = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  UserController(this._getUserData);

  User? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final user = Get.find<AuthController>().user;
      final result = await _getUserData(user!.id);
      result.fold(
        (failure) => errorMessage.value = failure.message,
        (userData) => _user.value = userData,
      );
        } catch (e) {
      errorMessage.value = 'Failed to load user data: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
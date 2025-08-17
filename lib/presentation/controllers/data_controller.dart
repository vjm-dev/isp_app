import 'package:get/get.dart';
import 'package:isp_app/domain/entities/data_usage.dart';
import 'package:isp_app/domain/repositories/data_repository.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';

class DataController extends GetxController {
  final DataRepository repository;
  final Rxn<DataUsage> usage = Rxn<DataUsage>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  DataController(this.repository);

  Future<void> loadDataUsage(String userId) async {
    isLoading.value = true;
    try {
      usage.value = await repository.getUserDataUsage(userId);
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSimulatedUsage(double amount) async {
    final user = Get.find<AuthController>().user;
    if (user != null) {
      await repository.simulateUsage(user.id, amount);
      await loadDataUsage(user.id);
    }
  }
}
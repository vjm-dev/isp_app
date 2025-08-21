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
      // Guardar el estado actual para posible reversión
      final currentUsage = usage.value;
      
      if (currentUsage != null) {
        // Actualización optimista local
        final newUsed = currentUsage.used + amount;
        
        // Actualizar el uso diario
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        List<DataConsumption> newDailyUsage = [];
        bool todayUpdated = false;
        
        for (var daily in currentUsage.dailyUsage) {
          if (isSameDay(daily.date, today)) {
            // Actualizar el día actual
            newDailyUsage.add(DataConsumption(
              date: daily.date,
              download: daily.download + amount,
              upload: daily.upload,
            ));
            todayUpdated = true;
          } else {
            newDailyUsage.add(daily);
          }
        }
        
        // Si no existe registro para hoy, crear uno nuevo
        if (!todayUpdated) {
          newDailyUsage.add(DataConsumption(
            date: today,
            download: amount,
            upload: 0,
          ));
        }
        
        // Crear nuevo DataUsage con los valores actualizados
        usage.value = DataUsage(
          startDate: currentUsage.startDate,
          endDate: currentUsage.endDate,
          used: newUsed,
          limit: currentUsage.limit,
          dailyUsage: newDailyUsage,
        );
        
        // Sincronizar con el servidor en segundo plano
        try {
          await repository.simulateUsage(user.id, amount);
          // Recargar para asegurar sincronización completa
          await loadDataUsage(user.id);
        } catch (e) {
          // Revertir en caso de error
          usage.value = currentUsage;
          error.value = 'Error al simular uso: $e';
          Get.snackbar('Error', 'No se pudo actualizar el uso: $e');
        }
      }
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
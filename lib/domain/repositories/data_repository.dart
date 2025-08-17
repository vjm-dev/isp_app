import 'package:isp_app/domain/entities/data_usage.dart';

abstract class DataRepository {
  Future<DataUsage> getUserDataUsage(String userId);
  Future<void> simulateUsage(String userId, double amount);
}
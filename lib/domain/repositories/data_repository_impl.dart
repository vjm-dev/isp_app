import 'package:isp_app/core/api_endpoints.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/domain/entities/data_usage.dart';
import 'package:isp_app/domain/repositories/data_repository.dart';

class DataRepositoryImpl implements DataRepository {
  final RemoteDataSource remoteDataSource;

  DataRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<DataUsage> getUserDataUsage(String userId) async {
    try {
      final response = await remoteDataSource.get(ApiEndpoints.userData(userId));
      
      return DataUsage(
        startDate: DateTime.parse(response['start_date']),
        endDate: DateTime.parse(response['end_date']),
        used: response['used'].toDouble(),
        limit: response['limit'].toDouble(),
        dailyUsage: (response['daily_usage'] as List).map((e) => 
          DataConsumption(
            date: DateTime.parse(e['date']),
            download: e['download'].toDouble(),
            upload: e['upload'].toDouble(),
          )).toList(),
      );
    } catch (e) {
      throw Exception('Failed to load data usage: $e');
    }
  }

  @override
  Future<void> simulateUsage(String userId, double amount) async {
    await remoteDataSource.post(
      ApiEndpoints.updateUsage(userId),
      body: {'amount': amount}
    );
  }
}
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:isp_app/core/api_endpoints.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/data/models/user_model.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final GetConnect _connect = GetConnect();
  final bool useMocks;
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'user_guest',
      'name': 'Guest User',
      'email': 'guest@isp.com',
      'phone': '+1234567890',
      'planName': 'Internet 100 Mbps',
      'monthlyPayment': 29.99,
      'lastUpdated': DateTime.now().toIso8601String(),
      'data_usage': {
        'start_date': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
        'end_date': DateTime.now().add(Duration(days: 5)).toIso8601String(),
        'used': 150.0,
        'limit': 500.0,
        'daily_usage': _generateDailyUsage(30, 5.0),
      },
    },
    {
      'id': 'user_123',
      'name': 'Premium User',
      'email': 'premium@isp.com',
      'phone': '+0987654321',
      'planName': 'Internet 1 Gbps',
      'monthlyPayment': 79.99,
      'lastUpdated': DateTime.now().toIso8601String(),
      'data_usage': {
        'start_date': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
        'end_date': DateTime.now().add(Duration(days: 5)).toIso8601String(),
        'used': 750.0,
        'limit': 2000.0,
        'daily_usage': _generateDailyUsage(30, 25.0),
      },
    }
  ];

  RemoteDataSourceImpl({this.useMocks = kDebugMode});

  static List<Map<String, dynamic>> _generateDailyUsage(int days, double maxUsage) {
    final rng = Random();
    return List.generate(days, (index) {
      final date = DateTime.now().subtract(Duration(days: days - index - 1));
      final download = rng.nextDouble() * maxUsage;
      return {
        'date': date.toIso8601String(),
        'download': download,
        'upload': download * 0.2,
      };
    });
  }

  @override
  Future<dynamic> get(String url) async {
    if (useMocks) return _mockResponse(url);
    
    final response = await _connect.get(url);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('GET Failed: ${response.statusCode}');
    }
    return response.body;
  }

  @override
  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    if (useMocks) return _mockResponse(url);
    
    final response = await _connect.post(url, body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('POST Failed: ${response.statusCode}');
    }
    return response.body;
  }

  dynamic _mockResponse(String url) {
    if (url.contains(ApiEndpoints.userData(''))) {
      return {
        'id': 'user_123',
        'name': 'John Doe',
        'email': 'john@isp.com',
        'phone': '+1234567890',
        'planName': 'Internet 300 Mbps',
        'monthlyPayment': 49.99,
        'data_usage': {
          'start_date': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
          'end_date': DateTime.now().add(Duration(days: 5)).toIso8601String(),
          'used': 325.6,
          'limit': 1000.0,
          'daily_usage': List.generate(30, (index) {
            final date = DateTime.now().subtract(Duration(days: 29 - index));
            return {
              'date': date.toIso8601String(),
              'download': (index % 5 + 2.5),
              'upload': (index % 3 + 0.5),
            };
          }),
        },
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    }
    
    if (url.contains(ApiEndpoints.updateUsage(''))) {
      return {'status': 'success'};
    }
    
    throw Exception('Endpoint not mocked: $url');
  }

  
  @override
  Future<UserModel> login(String email, String password) async {
    if (useMocks) {
      await Future.delayed(const Duration(seconds: 1));
      
      final user = _mockUsers.firstWhere(
        (u) => u['email'] == email,
        orElse: () => throw Exception('User not found'),
      );
      
      if (password.isEmpty) throw Exception('Invalid password');
      
      return UserModel.fromJson(user);
    } else { // for release
      final response = await _connect.post(
        ApiEndpoints.login(),
        {
          'email': email,
          'password': password
        },
      );
      
      if (response.statusCode == 401) {
        throw Exception('Invalid email or password');
      }
      
      if (response.statusCode == 403) {
        throw Exception('This user is not authorized or is banned');
      }

      if (response.statusCode != 200) {
        throw Exception('Login error: '
          'Status code response is ${response.statusCode}'
          'Check your connection or the server');
      }
      
      return UserModel.fromJson(response.body);
    }
  }

  @override
  Future<UserModel> getUserData(String userId) async {
    if (useMocks) {
      await Future.delayed(const Duration(seconds: 1));
      
      final user = _mockUsers.firstWhere(
        (u) => u['id'] == userId,
        orElse: () => throw Exception('User not found'),
      );
      
      return UserModel.fromJson(user);
    } else { // for release
      final response = await _connect.get(ApiEndpoints.userData(userId));
      
      if (response.statusCode != 200) {
        throw Exception('Get user data error: ${response.statusCode}');
      }
      
      return UserModel.fromJson(response.body);
    }
  }

  @override
  dynamic mockResponse(String url) => _mockResponse(url);
}
import 'package:flutter/foundation.dart';
import 'package:isp_app/core/utils/validators.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/data/models/user_model.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // API call simulation
    await Future.delayed(const Duration(seconds: 1));

    if (!Validators.email(email)) {
      throw Exception('Invalid email format');
    }

    if (!Validators.password(password)) {
      throw Exception('Password cannot be less than 8 characters');
    }

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Block guest user on release
    if (!kDebugMode && email == 'guest@isp.com') {
      throw Exception('Guest access not allowed');
    }

    if (kDebugMode && email == 'guest@isp.com' && password == '12345678') {
      return UserModel(
        id: 'user_guest',
        name: 'Guest user',
        email: email,
        phone: '+1234567890',
        planName: 'Internet 100 Mbps',
        monthlyPayment: 29.99,
        dataUsage: 150.0,
        dataLimit: 500.0,
        lastUpdated: DateTime.now(),
      );
    }

    throw Exception('Invalid email or password');
  }

  @override
  Future<UserModel> getUserData(String userId) async {
    // API call simulation
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: userId,
      name: 'ISP Client',
      email: 'client@isp.com',
      phone: '+1234567890',
      planName: 'Internet 300 Mbps',
      monthlyPayment: 49.99,
      dataUsage: 325.6,
      dataLimit: 1000.0,
      lastUpdated: DateTime.now(),
    );
  }
}
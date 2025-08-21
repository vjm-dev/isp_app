import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';

class SplashPage extends StatelessWidget {
  final AuthController _authController = Get.find();
  final DataController _dataController = Get.find();

  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use addPostFrameCallback to avoid building error
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _authController.checkAuthStatus();
      
      if (_authController.user == null) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        // Load data after authentication check
        await _dataController.loadDataUsage(_authController.user!.id);
        Get.offAllNamed(AppRoutes.home);
      }
    });
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'ISP Connect',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Obx(() {
              if (_authController.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _authController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
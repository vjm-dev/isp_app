import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/pages/home/dashboard_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (_authController.isAuthenticated) {
        return DashboardPage();
      }
      
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Authentication required'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
                child: const Text('Go to login'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
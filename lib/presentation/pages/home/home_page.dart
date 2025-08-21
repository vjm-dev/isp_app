import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';
import 'package:isp_app/presentation/pages/home/dashboard_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AuthController _authController = Get.find();
  final DataController _dataController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Load data after completing the recent frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_authController.isAuthenticated &&
            _authController.user != null && 
            _dataController.usage.value == null) {
          _dataController.loadDataUsage(_authController.user!.id);
        }
      });

      if (_authController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (_authController.isAuthenticated) {
        // Load data when the user is authenticated
        /*if (_authController.user != null && 
            _dataController.usage.value == null) {
          _dataController.loadDataUsage(_authController.user!.id);
        }*/
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
                onPressed: () => Get.offAllNamed(AppRoutes.login),
                child: const Text('Go to login'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
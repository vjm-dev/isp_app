import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/pages/home/dashboard_page.dart';

class HomeController extends GetxController {
  final AuthController _authController = Get.find();

  Widget build(BuildContext context) {
    return Obx(() {
      if (_authController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return _authController.user != null
          ? DashboardPage()
          : Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.login),
                  child: const Text('Go to login'),
                ),
              ),
            );
    });
  }
}
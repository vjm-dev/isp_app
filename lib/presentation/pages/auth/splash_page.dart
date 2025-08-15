import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';

class SplashPage extends StatelessWidget {
  final AuthController _authController = Get.find();

  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => _authController.checkAuthStatus());
    
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/core/routes/app_pages.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/theme_controller.dart';
import 'package:isp_app/presentation/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find();

  LoginPage({super.key}) {
    if (kDebugMode) {
      _emailController.text = 'guest@isp.com';
      _passwordController.text = '12345678';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ISP Connect',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _authController.isLoading.value
                        ? null
                        : () => _authController.login(
                              _emailController.text,
                              _passwordController.text,
                            ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Log in',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                )),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.PASSWORD_RECOVERY),
                  child: const Text('Forgot your password?'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GetBuilder<ThemeController>(
              builder: (themeController) {
                return IconButton(
                  icon: Icon(
                    themeController.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: themeController.toggleTheme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
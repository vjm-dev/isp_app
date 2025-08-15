import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/presentation/controllers/user_controller.dart';
import 'package:isp_app/presentation/widgets/custom_app_bar.dart';
import 'package:isp_app/presentation/widgets/data_usage_card.dart';

class DashboardPage extends StatelessWidget {
  final UserController _userController = Get.find();

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Account',
        showLogout: true,
      ),
      body: Obx(() {
        if (_userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (_userController.user != null) {
          return _buildDashboard(_userController.user!);
        }
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_userController.errorMessage.value),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _userController.loadUserData,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDashboard(User user) {
    final theme = Theme.of(Get.context!);
    final colorScheme = theme.colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.isGuest)
            _buildGuestWarning(),
          
          Text(
            'Hi, ${user.name}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Plan: ${user.planName}',
            style: TextStyle(
              fontSize: 18, 
              color: colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 30),
          DataUsageCard(
            used: user.dataUsage,
            total: user.dataLimit,
          ),
          const SizedBox(height: 30),
          _buildInfoCard('Current billing', '\$${user.monthlyPayment}'),
          const SizedBox(height: 15),
          _buildInfoCard('Next billing', '15 each month'),
          const SizedBox(height: 15),
          _buildInfoCard('Account status', 'Up to date'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('View contracted services'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    final theme = Theme.of(Get.context!);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, 
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCF40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Color(0xFFDD8500)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Guest mode: Data test',
              style: TextStyle(color: const Color(0xFFB45100)),
            ),
          ),
        ],
      ),
    );
  }
}
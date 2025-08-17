import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';
import 'package:isp_app/presentation/widgets/custom_app_bar.dart';
import 'package:isp_app/presentation/widgets/data_usage_card.dart';
import 'package:isp_app/presentation/widgets/usage_simulator.dart';
class DashboardPage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final dataController = Get.find<DataController>();

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Account',
        showLogout: true,
      ),
      body: Obx(() {
        if (dataController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (authController.user != null) {
          return _buildDashboard(authController.user!);
        }
        
        return Center(child: Text('No user data'));
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
            used: dataController.usage.value?.used ?? 0,
            total: dataController.usage.value?.limit ?? 1,
          ),
          const SizedBox(height: 20),
          UsageSimulator(),
          const SizedBox(height: 20),
          _buildUsageHistory(dataController),
          const SizedBox(height: 30),
          _buildInfoCard('Current billing', '\$${user.monthlyPayment}'),
          const SizedBox(height: 15),
          _buildInfoCard('Next billing', '15 each month'),
          const SizedBox(height: 15),
          _buildInfoCard('Account status', 'Up to date'),
          const SizedBox(height: 30),
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

  
  Widget _buildUsageHistory(DataController controller) {
    return Obx(() {
      if (controller.usage.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return Column(
        children: [
          const Text('Daily history'),
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Download (GB)')),
              DataColumn(label: Text('Upload (GB)')),
            ],
            rows: controller.usage.value!.dailyUsage.map((usage) {
              return DataRow(cells: [
                DataCell(Text(DateFormat('dd/MM').format(usage.date))),
                DataCell(Text(usage.download.toStringAsFixed(2))),
                DataCell(Text(usage.upload.toStringAsFixed(2))),
              ]);
            }).toList(),
          ),
        ],
      );
    });
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
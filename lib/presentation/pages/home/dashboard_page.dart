import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isp_app/domain/entities/data_usage.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/presentation/controllers/auth_controller.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';
import 'package:isp_app/presentation/widgets/custom_app_bar.dart';
import 'package:isp_app/presentation/widgets/data_usage_card.dart';
import 'package:isp_app/presentation/widgets/usage_simulator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final authController = Get.find<AuthController>();
  final dataController = Get.find<DataController>();

  @override
  void initState() {
    super.initState();
    // Load data after completing the recent frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataIfNeeded();
    });
  }

  void _loadDataIfNeeded() {
    if (authController.user != null && 
        (dataController.usage.value == null || 
         dataController.isLoading.value == false)) {
      dataController.loadDataUsage(authController.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Account',
        showLogout: true,
      ),
      body: Obx(() {
        // Reload data if needed
        if (authController.user != null && dataController.usage.value == null) {
          _loadDataIfNeeded();
        }

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
      final currentUsage = controller.usage.value;
      if (currentUsage == null) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final sortedDailyUsage = List<DataConsumption>.from(currentUsage.dailyUsage)
        ..sort((a, b) => b.date.compareTo(a.date));
      
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Usage history',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Download (GB)')),
                  DataColumn(label: Text('Upload (GB)')),
                ],
                rows: sortedDailyUsage.take(7).map((usage) {
                  return DataRow(cells: [
                    DataCell(Text(DateFormat('dd/MM').format(usage.date))),
                    DataCell(Text(usage.download.toStringAsFixed(2))),
                    DataCell(Text(usage.upload.toStringAsFixed(2))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
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
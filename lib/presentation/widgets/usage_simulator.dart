import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';

class UsageSimulator extends StatelessWidget {
  final DataController controller = Get.find();

  UsageSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Simulate data usage'),
            const SizedBox(height: 10),
            Row(
              children: [0.5, 1, 5, 10].map((amount) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () => controller.addSimulatedUsage(amount.toDouble()),
                    child: Text('+${amount}GB'),
                  ),
                );
              }).toList(),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return Text(
                controller.error.value.isNotEmpty 
                  ? controller.error.value
                  : 'Press to simulate the usage',
              );
            }),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_app/presentation/controllers/data_controller.dart';

class UsageSimulator extends StatelessWidget {
  final DataController controller = Get.find();

  UsageSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Simulate data usage'),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [0.5, 1, 5, 10].map((amount) {
                  return ElevatedButton(
                    onPressed: () => controller.addSimulatedUsage(amount.toDouble()),
                    child: Text('+${amount}GB'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }
                return Text(
                  controller.error.value.isNotEmpty 
                    ? controller.error.value
                    : 'Press to simulate the usage',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
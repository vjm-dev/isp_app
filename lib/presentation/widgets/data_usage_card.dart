import 'package:flutter/material.dart';

class DataUsageCard extends StatelessWidget {
  final double used;
  final double total;

  const DataUsageCard({
    super.key,
    required this.used,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = used / total;
    final remaining = total - used;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data consumption',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: colorScheme.surface,
              color: percentage > 0.8 ? Colors.red : colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${used.toStringAsFixed(1)} GB used',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                Text(
                  '${remaining.toStringAsFixed(1)} GB remaining',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'Total: ${total.toStringAsFixed(1)} GB',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
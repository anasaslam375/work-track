// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

/// Widget displaying attendance summary with statistics
class AttendanceSummaryCard extends StatelessWidget {
  final Map<String, int> summary;
  final double percentage;

  const AttendanceSummaryCard({
    Key? key,
    required this.summary,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = summary.values.fold(0, (sum, count) => sum + count);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attendance Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.ATTENDANCE),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Attendance percentage
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Text(
                        'Attendance Rate',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Circular progress indicator
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage >= 90
                          ? Colors.green
                          : percentage >= 75
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Statistics breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Present',
                  summary['present'] ?? 0,
                  Colors.green,
                ),
                _buildStatItem('Late', summary['late'] ?? 0, Colors.orange),
                _buildStatItem('Absent', summary['absent'] ?? 0, Colors.red),
              ],
            ),

            if (total > 0) ...[
              const SizedBox(height: 16),
              Text(
                'Total working days: $total',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_getIconForStatus(label), color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'Present':
        return Icons.check_circle;
      case 'Late':
        return Icons.access_time;
      case 'Absent':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

/// Widget displaying weekly attendance chart
class WeeklyAttendanceChart extends GetView<DashboardController> {
  const WeeklyAttendanceChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Obx(() {
              final weeklyData = controller.weeklyAttendanceData;

              return SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weeklyData.map((dayData) {
                    return _buildDayColumn(
                      dayData['day'],
                      dayData['status'],
                      _isToday(dayData['date']),
                    );
                  }).toList(),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Present', Colors.green),
                const SizedBox(width: 16),
                _buildLegendItem('Late', Colors.orange),
                const SizedBox(width: 16),
                _buildLegendItem('Absent', Colors.red),
                const SizedBox(width: 16),
                _buildLegendItem('No Data', Colors.grey[300]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayColumn(String day, int statusIndex, bool isToday) {
    Color color;
    double height;

    switch (statusIndex) {
      case 0: // Present
        color = Colors.green;
        height = 60;
        break;
      case 1: // Late
        color = Colors.orange;
        height = 40;
        break;
      case 2: // Absent
        color = Colors.red;
        height = 20;
        break;
      default: // No data
        color = Colors.grey[300]!;
        height = 10;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? Colors.blue : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

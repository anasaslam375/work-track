import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/attendance_summary_card.dart';
import '../widgets/payslip_summary_card.dart';
import '../widgets/weekly_attendance_chart.dart';
import '../widgets/quick_actions_card.dart';

/// Dashboard view with overview of all modules
class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting
                _buildHeader(),
                const SizedBox(height: 24),

                // Quick actions
                const QuickActionsCard(),
                const SizedBox(height: 20),

                // Attendance summary
                Obx(
                  () => AttendanceSummaryCard(
                    summary: controller.attendanceSummary,
                    percentage: controller.attendancePercentage,
                  ),
                ),
                const SizedBox(height: 20),

                // Weekly attendance chart
                const WeeklyAttendanceChart(),
                const SizedBox(height: 20),

                // Latest payslip
                Obx(
                  () => PayslipSummaryCard(
                    payslip: controller.latestPayslip.value,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            '${controller.greeting.value}!',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            controller.userName.value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s your overview for today',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/payslip_model.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../payslip/controllers/payslip_controller.dart';

/// Controller for dashboard with combined data from multiple modules
class DashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxMap<String, int> attendanceSummary = <String, int>{}.obs;
  final Rxn<PayslipModel> latestPayslip = Rxn<PayslipModel>();
  final RxList<AttendanceModel> recentAttendance = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      await Future.wait([_loadAttendanceData(), _loadPayslipData()]);
    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load attendance data and compute summary
  Future<void> _loadAttendanceData() async {
    try {
      // Get attendance controller if available
      if (Get.isRegistered<AttendanceController>()) {
        final attendanceController = Get.find<AttendanceController>();
        attendanceSummary.value = attendanceController.getAttendanceSummary();

        // Get recent attendance (last 7 days)
        final allRecords = attendanceController.attendanceRecords;
        final now = DateTime.now();
        recentAttendance.value = allRecords
            .where((record) => now.difference(record.date).inDays <= 7)
            .take(7)
            .toList();
      } else {
        // Load directly from storage if controller not available
        final data = _storageService.read<List>('attendance_records');
        if (data != null) {
          final records = data
              .map(
                (json) =>
                    AttendanceModel.fromJson(Map<String, dynamic>.from(json)),
              )
              .toList();

          _computeAttendanceSummary(records);

          final now = DateTime.now();
          recentAttendance.value = records
              .where((record) => now.difference(record.date).inDays <= 7)
              .take(7)
              .toList();
        }
      }
    } catch (e) {
      print('Error loading attendance data: $e');
    }
  }

  /// Load latest payslip data
  Future<void> _loadPayslipData() async {
    try {
      if (Get.isRegistered<PayslipController>()) {
        final payslipController = Get.find<PayslipController>();
        latestPayslip.value = payslipController.latestPayslip;
      } else {
        // Load directly from storage if controller not available
        final data = _storageService.read<List>('payslip_history');
        if (data != null && data.isNotEmpty) {
          final payslips = data
              .map(
                (json) =>
                    PayslipModel.fromJson(Map<String, dynamic>.from(json)),
              )
              .toList();
          latestPayslip.value = payslips.first;
        }
      }
    } catch (e) {
      print('Error loading payslip data: $e');
    }
  }

  /// Compute attendance summary from records
  void _computeAttendanceSummary(List<AttendanceModel> records) {
    final summary = {'present': 0, 'late': 0, 'absent': 0};

    for (final record in records) {
      switch (record.status) {
        case AttendanceStatus.present:
          summary['present'] = summary['present']! + 1;
          break;
        case AttendanceStatus.late:
          summary['late'] = summary['late']! + 1;
          break;
        case AttendanceStatus.absent:
          summary['absent'] = summary['absent']! + 1;
          break;
      }
    }

    attendanceSummary.value = summary;
  }

  /// Get attendance percentage
  double get attendancePercentage {
    final total = attendanceSummary.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return 0.0;

    final present = attendanceSummary['present'] ?? 0;
    return (present / total) * 100;
  }

  /// Get weekly attendance data for chart
  List<Map<String, dynamic>> get weeklyAttendanceData {
    final data = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);

      // Find attendance for this day
      final attendance = recentAttendance.firstWhereOrNull(
        (record) => _isSameDay(record.date, date),
      );

      data.add({
        'day': dayName.substring(0, 3), // Short day name
        'status': attendance?.status.index ?? -1, // -1 for no data
        'date': date,
      });
    }

    return data;
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get day name from weekday number
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  /// Refresh dashboard data
  Future<void> refreshData() async {
    await loadDashboardData();
  }

  /// Get greeting based on time of day
  RxString get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning'.obs;
    } else if (hour < 17) {
      return 'Good Afternoon'.obs;
    } else {
      return 'Good Evening'.obs;
    }
  }

  /// Get user name from auth service
  RxString get userName {
    // This would typically come from auth service
    return 'Muhammad Anas'.obs;
  }
}

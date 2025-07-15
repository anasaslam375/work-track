import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/attendance_model.dart';

/// Controller for attendance management using GetX
class AttendanceController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Observable variables
  final RxList<AttendanceModel> _attendanceRecords = <AttendanceModel>[].obs;
  final RxString selectedFilter = 'All'.obs;

  // Getters
  List<AttendanceModel> get attendanceRecords => _attendanceRecords;

  /// Computed filtered list based on selected filter
  List<AttendanceModel> get filteredRecords {
    if (selectedFilter.value == 'All') {
      return _attendanceRecords;
    }

    final status = _getStatusFromFilter(selectedFilter.value);
    return _attendanceRecords
        .where((record) => record.status == status)
        .toList();
  }

  /// Available filter options
  List<String> get filterOptions => ['All', 'Present', 'Late', 'Absent'];

  @override
  void onInit() {
    super.onInit();
    _loadAttendanceData();
    _generateMockData(); // For demo purposes
  }

  /// Load attendance data from storage
  void _loadAttendanceData() {
    final data = _storageService.read<List>('attendance_records');
    if (data != null) {
      _attendanceRecords.value = data
          .map(
            (json) => AttendanceModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    }
  }

  /// Save attendance data to storage
  Future<void> _saveAttendanceData() async {
    final data = _attendanceRecords.map((record) => record.toJson()).toList();
    await _storageService.write('attendance_records', data);
  }

  /// Generate mock attendance data for demo
  void _generateMockData() {
    if (_attendanceRecords.isEmpty) {
      final mockData = _createMockAttendanceData();
      _attendanceRecords.addAll(mockData);
      _saveAttendanceData();
    }
  }

  /// Create mock attendance data
  List<AttendanceModel> _createMockAttendanceData() {
    final List<AttendanceModel> mockData = [];
    final now = DateTime.now();

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));

      // Skip weekends for demo
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        continue;
      }

      AttendanceStatus status;
      TimeOfDay? timeIn;

      // Generate random status with weighted probability
      final random = DateTime.now().millisecond % 10;
      if (random < 7) {
        status = AttendanceStatus.present;
        timeIn = const TimeOfDay(hour: 9, minute: 0);
      } else if (random < 9) {
        status = AttendanceStatus.late;
        timeIn = const TimeOfDay(hour: 9, minute: 30);
      } else {
        status = AttendanceStatus.absent;
        timeIn = null;
      }

      mockData.add(
        AttendanceModel(
          date: date,
          status: status,
          timeIn: timeIn,
          timeOut: status != AttendanceStatus.absent
              ? const TimeOfDay(hour: 17, minute: 30)
              : null,
        ),
      );
    }

    return mockData.reversed.toList(); // Most recent first
  }

  /// Update selected filter
  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Get attendance status from filter string
  AttendanceStatus _getStatusFromFilter(String filter) {
    switch (filter) {
      case 'Present':
        return AttendanceStatus.present;
      case 'Late':
        return AttendanceStatus.late;
      case 'Absent':
        return AttendanceStatus.absent;
      default:
        return AttendanceStatus.present;
    }
  }

  /// Add new attendance record
  Future<void> addAttendanceRecord(AttendanceModel record) async {
    _attendanceRecords.add(record);
    await _saveAttendanceData();
  }

  /// Get attendance summary for dashboard
  Map<String, int> getAttendanceSummary() {
    final summary = {'present': 0, 'late': 0, 'absent': 0};

    for (final record in _attendanceRecords) {
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

    return summary;
  }

  /// Refresh attendance data
  Future<void> refreshData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _loadAttendanceData();
  }
}

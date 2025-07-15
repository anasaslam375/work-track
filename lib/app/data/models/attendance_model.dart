import 'package:flutter/material.dart';

/// Enum for attendance status
enum AttendanceStatus {
  present,
  late,
  absent,
}

/// Extension for AttendanceStatus to get color and display text
extension AttendanceStatusExtension on AttendanceStatus {
  Color get color {
    switch (this) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.late:
        return Colors.orange;
      case AttendanceStatus.absent:
        return Colors.red;
    }
  }

  String get displayText {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
    }
  }
}

/// Model for attendance record
class AttendanceModel {
  final DateTime date;
  final AttendanceStatus status;
  final TimeOfDay? timeIn;
  final TimeOfDay? timeOut;
  final String? notes;

  AttendanceModel({
    required this.date,
    required this.status,
    this.timeIn,
    this.timeOut,
    this.notes,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status.index,
      'timeIn': timeIn != null ? '${timeIn!.hour}:${timeIn!.minute}' : null,
      'timeOut': timeOut != null ? '${timeOut!.hour}:${timeOut!.minute}' : null,
      'notes': notes,
    };
  }

  /// Create from JSON
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: DateTime.parse(json['date']),
      status: AttendanceStatus.values[json['status']],
      timeIn: json['timeIn'] != null ? _parseTimeOfDay(json['timeIn']) : null,
      timeOut: json['timeOut'] != null ? _parseTimeOfDay(json['timeOut']) : null,
      notes: json['notes'],
    );
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// Get formatted date string
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Get formatted time string
  String get formattedTimeIn {
    if (timeIn == null) return 'N/A';
    return '${timeIn!.hour.toString().padLeft(2, '0')}:${timeIn!.minute.toString().padLeft(2, '0')}';
  }
}
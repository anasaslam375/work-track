// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';
import '../widgets/attendance_card.dart';
import '../widgets/empty_state_widget.dart';

/// Attendance view with filtering and reactive updates
class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance'), elevation: 0),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                  children: controller.filterOptions.map((filter) {
                    final isSelected =
                        controller.selectedFilter.value == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => controller.updateFilter(filter),
                        selectedColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.2),
                        checkmarkColor: Theme.of(context).primaryColor,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Attendance list
          Expanded(
            child: Obx(() {
              final filteredRecords = controller.filteredRecords;

              if (filteredRecords.isEmpty) {
                return const EmptyStateWidget();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    final record = filteredRecords[index];
                    return AttendanceCard(
                      attendance: record,
                      margin: const EdgeInsets.only(bottom: 12),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

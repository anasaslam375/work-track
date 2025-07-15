import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/payslip_model.dart';

/// Widget for displaying payslip extraction results
class PayslipResultCard extends StatelessWidget {
  final PayslipModel payslip;
  final EdgeInsets? margin;
  final bool isCompact;

  const PayslipResultCard({
    Key? key,
    required this.payslip,
    this.margin,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.receipt_long, color: Colors.green[600], size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCompact ? 'Payslip' : 'Extracted Payslip Data',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Processed: ${DateFormat('MMM dd, yyyy HH:mm').format(payslip.processedAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (!isCompact) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Employee details
                _buildInfoSection('Employee Information', [
                  _buildInfoRow('Name', payslip.employeeName),
                  _buildInfoRow('ID', payslip.employeeId),
                  _buildInfoRow('Pay Period', payslip.payPeriod),
                ]),

                const SizedBox(height: 16),

                // Salary breakdown
                _buildInfoSection('Salary Breakdown', [
                  _buildInfoRow('Basic Salary', payslip.basicSalary.toString()),
                  _buildInfoRow('Allowances', payslip.allowances.toString()),
                  _buildInfoRow('Gross Pay', payslip.netPay.toString()),
                  _buildInfoRow(
                    'Deductions',
                    payslip.deductions.toString(),
                    isNegative: true,
                  ),
                ]),

                const SizedBox(height: 16),

                // Net pay highlight
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Net Pay',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        payslip.netPay.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payslip.employeeName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          payslip.payPeriod,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      payslip.netPay.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isNegative ? Colors.red[600] : null,
            ),
          ),
        ],
      ),
    );
  }
}

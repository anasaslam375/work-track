class PayslipModel {
  final String employeeName;
  final String employeeId;
  final String payPeriod;
  final String department;
  final String designation;
  final String company;
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double netPay;
  final DateTime processedAt;

  PayslipModel({
    required this.employeeName,
    required this.employeeId,
    required this.payPeriod,
    this.department = 'N/A',
    this.designation = 'N/A',
    this.company = 'N/A',
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.netPay,
    required this.processedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'employeeName': employeeName,
      'employeeId': employeeId,
      'payPeriod': payPeriod,
      'department': department,
      'designation': designation,
      'company': company,
      'basicSalary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'netPay': netPay,
      'processedAt': processedAt.toIso8601String(),
    };
  }

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      employeeName: json['employeeName'] ?? 'Unknown',
      employeeId: json['employeeId'] ?? 'N/A',
      payPeriod: json['payPeriod'] ?? 'Unknown',
      department: json['department'] ?? 'N/A',
      designation: json['designation'] ?? 'N/A',
      company: json['company'] ?? 'N/A',
      basicSalary: (json['basicSalary'] ?? 0.0).toDouble(),
      allowances: (json['allowances'] ?? 0.0).toDouble(),
      deductions: (json['deductions'] ?? 0.0).toDouble(),
      netPay: (json['netPay'] ?? 0.0).toDouble(),
      processedAt: DateTime.parse(json['processedAt']),
    );
  }

  @override
  String toString() {
    return 'PayslipModel(name: $employeeName, id: $employeeId, period: $payPeriod, '
        'basic: $basicSalary, allowances: $allowances, deductions: $deductions, '
        'netPay: $netPay)';
  }
}

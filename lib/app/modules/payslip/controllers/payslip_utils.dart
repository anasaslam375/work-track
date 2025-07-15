import 'dart:developer';

import 'package:worktrack/app/data/models/payslip_model.dart';

class PayslipExtractor {
  // Comprehensive patterns for different payslip formats
  static final Map<String, List<RegExp>> _patterns = {
    'employeeName': [
      RegExp(
        r'(?:employee\s+name|name)\s*:?\s*(.+?)(?:\n|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:emp\s+name|full\s+name)\s*:?\s*(.+?)(?:\n|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:worker\s+name|staff\s+name)\s*:?\s*(.+?)(?:\n|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'^(.+?)(?:\s+\d{4,}|\s+employee)',
        caseSensitive: false,
      ), // Name followed by ID
    ],

    'employeeId': [
      RegExp(
        r'(?:employee\s+id|emp\s+id|id|employee\s+no|emp\s+no)\s*:?\s*([a-zA-Z0-9\-_]+)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:staff\s+id|worker\s+id|personnel\s+id)\s*:?\s*([a-zA-Z0-9\-_]+)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:badge\s+no|badge\s+number)\s*:?\s*([a-zA-Z0-9\-_]+)',
        caseSensitive: false,
      ),
    ],

    'payPeriod': [
      RegExp(
        r'(?:pay\s+period|period|salary\s+period)\s*:?\s*(.+?)(?:\n|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:from|for\s+the\s+period)\s*:?\s*(.+?)(?:\n|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:month|pay\s+month)\s*:?\s*(.+?)(?:\n|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}\s*(?:to|-)?\s*\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4})',
        caseSensitive: false,
      ),
      RegExp(
        r'((?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\w*\s+\d{2,4})',
        caseSensitive: false,
      ),
    ],

    'basicSalary': [
      RegExp(
        r'(?:basic\s+salary|basic\s+pay|base\s+salary|base\s+pay)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:gross\s+salary|gross\s+pay)(?:\s*before\s+deductions?)?\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:monthly\s+salary|monthly\s+pay)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
    ],

    'allowances': [
      RegExp(
        r'(?:total\s+allowances?|allowances?\s+total)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:hra|house\s+rent\s+allowance)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:da|dearness\s+allowance)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:transport\s+allowance|travel\s+allowance)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:medical\s+allowance|health\s+allowance)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:special\s+allowance|other\s+allowance)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
    ],

    'deductions': [
      RegExp(
        r'(?:total\s+deductions?|deductions?\s+total)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:pf|provident\s+fund|epf)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:esi|esic)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:tax|income\s+tax|tds)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:loan\s+deduction|advance\s+deduction)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:insurance\s+premium|insurance)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
    ],

    'netPay': [
      RegExp(
        r'(?:net\s+pay|net\s+salary|take\s+home|net\s+amount)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:total\s+pay|final\s+pay|amount\s+paid)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:payable\s+amount|amount\s+payable)\s*:?\s*(?:[₹\$£€¥]?\s*)?([0-9,]+\.?\d*)',
        caseSensitive: false,
      ),
    ],
  };

  // Department and designation patterns
  static final List<RegExp> _departmentPatterns = [
    RegExp(r'(?:department|dept)\s*:?\s*(.+?)(?:\n|$)', caseSensitive: false),
    RegExp(r'(?:division|team)\s*:?\s*(.+?)(?:\n|$)', caseSensitive: false),
  ];

  static final List<RegExp> _designationPatterns = [
    RegExp(
      r'(?:designation|position|title|role)\s*:?\s*(.+?)(?:\n|$)',
      caseSensitive: false,
    ),
    RegExp(r'(?:job\s+title|post)\s*:?\s*(.+?)(?:\n|$)', caseSensitive: false),
  ];

  // Company patterns
  static final List<RegExp> _companyPatterns = [
    RegExp(
      r'(?:company|organization|employer)\s*:?\s*(.+?)(?:\n|$)',
      caseSensitive: false,
    ),
    RegExp(r'^(.+?)(?:\s+payslip|\s+salary\s+slip)', caseSensitive: false),
  ];

  static PayslipModel extractPayslipData(String text) {
    // Preprocess text
    text = _preprocessText(text);

    log("Text Data: $text");

    // Initialize variables
    String employeeName = 'Unknown';
    String employeeId = 'N/A';
    String payPeriod = 'Unknown';
    String department = 'N/A';
    String designation = 'N/A';
    String company = 'N/A';
    double basicSalary = 0.0;
    double allowances = 0.0;
    double deductions = 0.0;
    double netPay = 0.0;

    // Track found amounts for smart calculation
    List<double> allowanceAmounts = [];
    List<double> deductionAmounts = [];

    // Extract basic information
    // employeeName =
    //     _extractWithPatterns(text, _patterns['employeeName']!) ?? 'Unknown';
    // employeeId = _extractWithPatterns(text, _patterns['employeeId']!) ?? 'N/A';
    // payPeriod =
    //     _extractWithPatterns(text, _patterns['payPeriod']!) ?? 'Unknown';
    department = _extractWithPatterns(text, _departmentPatterns) ?? 'N/A';
    designation = _extractWithPatterns(text, _designationPatterns) ?? 'N/A';
    company = _extractWithPatterns(text, _companyPatterns) ?? 'N/A';

    // Extract financial data
    basicSalary =
        _extractAmountWithPatterns(text, _patterns['basicSalary']!) ?? 0.0;

    // Extract multiple allowances and sum them
    allowanceAmounts = _extractMultipleAmounts(text, _patterns['allowances']!);
    double totalAllowancesFromPatterns =
        _extractAmountWithPatterns(text, _patterns['allowances']!) ?? 0.0;

    if (totalAllowancesFromPatterns > 0) {
      allowances = totalAllowancesFromPatterns;
    } else if (allowanceAmounts.isNotEmpty) {
      allowances = allowanceAmounts.reduce((a, b) => a + b);
    }

    // Extract multiple deductions and sum them
    deductionAmounts = _extractMultipleAmounts(text, _patterns['deductions']!);
    double totalDeductionsFromPatterns =
        _extractAmountWithPatterns(text, _patterns['deductions']!) ?? 0.0;

    if (totalDeductionsFromPatterns > 0) {
      deductions = totalDeductionsFromPatterns;
    } else if (deductionAmounts.isNotEmpty) {
      deductions = deductionAmounts.reduce((a, b) => a + b);
    }

    // Extract net pay
    netPay = _extractAmountWithPatterns(text, _patterns['netPay']!) ?? 0.0;

    // Smart calculation if values are missing
    if (netPay == 0.0 && basicSalary > 0) {
      netPay = basicSalary + allowances - deductions;
    }

    if (basicSalary == 0.0 && netPay > 0) {
      basicSalary = netPay + deductions - allowances;
    }

    // Additional validation and cleanup
    employeeName = _cleanupName(employeeName);
    employeeId = _cleanupId(employeeId);
    payPeriod = _cleanupPeriod(payPeriod);

    return PayslipModel(
      employeeName: employeeName,
      employeeId: employeeId,
      payPeriod: payPeriod,
      department: department,
      designation: designation,
      company: company,
      basicSalary: basicSalary,
      allowances: allowances,
      deductions: deductions,
      netPay: netPay,
      processedAt: DateTime.now(),
    );
  }

  static String _preprocessText(String text) {
    // Remove excessive whitespace and normalize
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.replaceAll(RegExp(r'[^\w\s\d.,:-₹\$£€¥]'), ' ');
    text = text.replaceAll(RegExp(r'\s*:\s*'), ': ');
    return text.trim();
  }

  static String? _extractWithPatterns(String text, List<RegExp> patterns) {
    for (RegExp pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        String result = match.group(1)!.trim();
        if (result.isNotEmpty && result != '-' && result != 'N/A') {
          return result;
        }
      }
    }
    return null;
  }

  static double? _extractAmountWithPatterns(
    String text,
    List<RegExp> patterns,
  ) {
    for (RegExp pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        String amountStr = match.group(1)!.trim();
        double? amount = _parseAmount(amountStr);
        if (amount != null && amount > 0) {
          return amount;
        }
      }
    }
    return null;
  }

  static List<double> _extractMultipleAmounts(
    String text,
    List<RegExp> patterns,
  ) {
    List<double> amounts = [];
    for (RegExp pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (Match match in matches) {
        if (match.groupCount >= 1) {
          String amountStr = match.group(1)!.trim();
          double? amount = _parseAmount(amountStr);
          if (amount != null && amount > 0) {
            amounts.add(amount);
          }
        }
      }
    }
    return amounts;
  }

  static double? _parseAmount(String amountStr) {
    if (amountStr.isEmpty) return null;

    // Remove currency symbols and spaces
    amountStr = amountStr.replaceAll(RegExp(r'[₹\$£€¥,\s]'), '');

    // Handle negative amounts in parentheses
    if (amountStr.startsWith('(') && amountStr.endsWith(')')) {
      amountStr = amountStr.substring(1, amountStr.length - 1);
    }

    try {
      return double.parse(amountStr);
    } catch (e) {
      return null;
    }
  }

  static String _cleanupName(String name) {
    // Remove common prefixes and suffixes
    name = name.replaceAll(
      RegExp(r'^(mr\.?|ms\.?|mrs\.?|dr\.?)\s*', caseSensitive: false),
      '',
    );
    name = name.replaceAll(
      RegExp(r'\s*(jr\.?|sr\.?|ii|iii)$', caseSensitive: false),
      '',
    );

    // Title case
    return name
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : word,
        )
        .join(' ');
  }

  static String _cleanupId(String id) {
    // Remove common prefixes
    id = id.replaceAll(RegExp(r'^(emp|id|no\.?)\s*', caseSensitive: false), '');
    return id.toUpperCase();
  }

  static String _cleanupPeriod(String period) {
    // Standardize date formats
    period = period.replaceAll(RegExp(r'\s+'), ' ');
    period = period.replaceAll(RegExp(r'[,.]$'), '');
    return period.trim();
  }
}

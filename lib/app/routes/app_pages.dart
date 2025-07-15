import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/controllers/login_controller.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/attendance/views/attendance_view.dart';
import '../modules/attendance/controllers/attendance_controller.dart';
import '../modules/payslip/views/payslip_view.dart';
import '../modules/payslip/controllers/payslip_controller.dart';
import 'app_routes.dart';

/// Application pages configuration with GetX routing
class AppPages {
  static final routes = [
    // Login route
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    
    // Dashboard route
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
        Get.lazyPut<AttendanceController>(() => AttendanceController());
        Get.lazyPut<PayslipController>(() => PayslipController());
      }),
    ),
    
    // Attendance route
    GetPage(
      name: AppRoutes.ATTENDANCE,
      page: () => const AttendanceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AttendanceController>(() => AttendanceController());
      }),
    ),
    
    // Payslip route
    GetPage(
      name: AppRoutes.PAYSLIP,
      page: () => const PayslipView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PayslipController>(() => PayslipController());
      }),
    ),
  ];
}
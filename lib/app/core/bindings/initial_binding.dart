import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/payslip_service.dart';

/// Initial binding for dependency injection
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<PayslipService>(PayslipService(), permanent: true);
  }
}
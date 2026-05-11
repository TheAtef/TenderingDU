import 'dart:async';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class WaitingApprovalController extends GetxController {
  final isCheckingStatus = false.obs;
  Timer? _statusTimer;

  @override
  void onInit() {
    super.onInit();
    // بدء التحقق التلقائي كل 5 ثوانٍ
    _startAutoCheck();
  }

  void _startAutoCheck() {
    // سيقوم بالتحقق من حالة الحساب كل 5 ثوانٍ بشكل مستمر
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _verifyStatusBackground();
    });
  }

  Future<void> _verifyStatusBackground() async {
    // محاكاة الاتصال بالـ API أو قاعدة البيانات لمعرفة حالة الحساب
    // يمكنك استبدال هذا المتغير باستدعاء حقيقي للـ API:
    // bool isApproved = await apiService.checkUserApproval();
    bool isApproved = false; // غيّر هذا إلى true لاختبار الانتقال التلقائي

    if (isApproved) {
      _statusTimer?.cancel(); // إيقاف المؤقت

      Get.snackbar(
        'تمت الموافقة',
        'تم تنشيط حسابك بنجاح. جاري الدخول...',
        snackPosition: SnackPosition.BOTTOM,
      );

      // الانتقال التلقائي للصفحة الرئيسية
      Get.offAllNamed(Routes.HOME);
    }
  }

  /// Trigger a mock API call to check if the account is approved (للزر اليدوي)
  Future<void> checkApprovalStatus() async {
    isCheckingStatus.value = true;

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock condition: Account still pending
    bool isApproved = false;

    isCheckingStatus.value = false;

    if (isApproved) {
      _statusTimer?.cancel();
      Get.snackbar(
        'Success',
        'Your account has been approved!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        'Status Pending',
        'Your account is still under review by the administrator. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Handle logout
  void logout() {
    _statusTimer?.cancel(); // تأكد من إيقاف المؤقت عند الخروج
    // Perform logout logic (clear tokens, etc.)
    // Navigate back to Login scale
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}

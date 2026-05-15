import 'dart:async';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'package:tendering_du/app/core/services/api_service.dart';

class WaitingApprovalController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isCheckingStatus = false.obs;

  Timer? _statusTimer;

  @override
  void onInit() {
    super.onInit();
    _startAutoCheck();
  }

  void _startAutoCheck() {
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _verifyStatusBackground();
    });
  }

  Future<void> _verifyStatusBackground() async {
    try {
      bool isApproved = await _apiService.checkUserApproval();

      if (isApproved) {
        _statusTimer?.cancel();

        Get.snackbar(
          'Account Activated',
          'Your account has been approved. Welcome!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );

        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      print("Background status check failed: $e");
    }
  }

  Future<void> checkApprovalStatus() async {
    if (isCheckingStatus.value) return;

    isCheckingStatus.value = true;

    try {
      bool isApproved = await _apiService.checkUserApproval();

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
          'Your account is still under review by the administrator.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Connection Error',
        'Could not reach the server. Please check your internet.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCheckingStatus.value = false;
    }
  }

  Future<void> logout() async {
    _statusTimer?.cancel();

    try {
      await _apiService.logout();
    } finally {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}

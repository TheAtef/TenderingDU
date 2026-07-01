import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';

class CreateTenderController extends GetxController {
  final activities = ['construction'.tr, 'it'.tr, 'healthcare'.tr];
  var selectedActivity = RxnString();
  void setActivity(String? val) => selectedActivity.value = val;

  final statuses = ['Draft', 'Published'];
  var selectedStatus = RxnString();

  final RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final applyDeadCtrl = TextEditingController();
  final finishDeadCtrl = TextEditingController();
  final budgetMinCtrl = TextEditingController();
  final budgetMaxCtrl = TextEditingController();

  var currency = "USD".obs;
  var fileName = "".obs;
  var isSubmitting = false.obs;

  File? selectedMobileFile;
  Uint8List? selectedWebFile;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );

      if (result != null) {
        fileName.value = result.files.single.name;

        if (kIsWeb) {
          selectedWebFile = result.files.single.bytes;
        } else {
          if (result.files.single.path != null) {
            selectedMobileFile = File(result.files.single.path!);
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick file: ${e.toString()}");
    }
  }

  void removeFile() {
    selectedMobileFile = null;
    selectedWebFile = null;
    fileName.value = "";
  }

  Future<void> submitBidApi() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedMobileFile == null && selectedWebFile == null) {
      Get.snackbar("Error", "Please attach your tender document.");
      return;
    }

    isSubmitting.value = true;

    try {
      final ApiService _apiService = ApiService();

      int categoryId = 1;
      if (selectedActivity.value == 'it'.tr) categoryId = 2;
      if (selectedActivity.value == 'healthcare'.tr) categoryId = 3;

      int currencyId = 1;
      if (currency.value == 'EUR') currencyId = 2;
      if (currency.value == 'JD') currencyId = 3;

      int locationId = 1;
      String typedLocation = locationCtrl.text.trim().toLowerCase();
      if (typedLocation.contains('zarqa')) {
        locationId = 2;
      } else if (typedLocation.contains('irbid')) {
        locationId = 3;
      } else if (typedLocation.contains('aqaba')) {
        locationId = 4;
      }

      int statusId = 1;
      if (selectedStatus.value == 'Published') statusId = 2;

      String formattedStartDate = "${startDateCtrl.text}T00:00:00Z";
      String formattedDeadline = "${applyDeadCtrl.text}T23:59:59Z";
      String formattedCompletion = "${finishDeadCtrl.text}T23:59:59Z";

      double budgetMin = double.tryParse(budgetMinCtrl.text) ?? 0.0;
      double budgetMax = double.tryParse(budgetMaxCtrl.text) ?? 0.0;

      final result = await _apiService.createTender(
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        budgetMin: budgetMin,
        budgetMax: budgetMax,
        startDate: formattedStartDate,
        deadline: formattedDeadline,
        completionDeadline: formattedCompletion,
        categoryId: categoryId,
        currencyId: currencyId,
        locationId: locationId,
        statusId: statusId,
      );

      if (result['success']) {
        final int newTenderId = result['data']['id'];

        final bool fileUploaded = await _apiService.uploadTenderAttachment(
          tenderId: newTenderId,
          mobileFile: selectedMobileFile,
          webFileBytes: selectedWebFile,
          fileName: fileName.value,
        );

        if (fileUploaded) {
          Get.back();
          Get.snackbar(
            "Success",
            "Tender and document submitted successfully.\nWaiting for admin approval.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        } else {
          Get.snackbar(
            "Warning",
            "Tender created, but document upload failed.",
          );
        }
      } else {
        Get.snackbar("Error", result['message'] ?? "Failed to submit tender");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to submit: ${e.toString()}");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    locationCtrl.dispose();
    startDateCtrl.dispose();
    applyDeadCtrl.dispose();
    finishDeadCtrl.dispose();
    budgetMinCtrl.dispose();
    budgetMaxCtrl.dispose();
    super.onClose();
  }
}

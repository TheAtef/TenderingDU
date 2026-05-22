import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';

class CreateTenderController extends GetxController {
  final activities = ['construction'.tr, 'it'.tr, 'healthcare'.tr];
  var selectedActivity = RxnString();
  void setActivity(String? val) => selectedActivity.value = val;

  final RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  // Controllers
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final applyDeadCtrl = TextEditingController();
  final finishDeadCtrl = TextEditingController();
  final budgetCtrl = TextEditingController();

  // Observables
  var currency = "USD".obs;
  var fileName = "".obs;
  var isSubmitting = false.obs;

  File? selectedFile;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFile = File(result.files.single.path!);
        fileName.value = result.files.single.name;
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick file: ${e.toString()}");
    }
  }

  void removeFile() {
    selectedFile = null;
    fileName.value = "";
  }

  Future<void> submitBidApi() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedFile == null) {
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

      String formattedStartDate =
          "${DateTime.now().toIso8601String().split('.')[0]}Z";
      String formattedDeadline = "${applyDeadCtrl.text}T23:59:59Z";
      String formattedCompletion = "${finishDeadCtrl.text}T23:59:59Z";

      double expectedBudget = double.tryParse(budgetCtrl.text) ?? 0.0;

      final result = await _apiService.createTender(
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        budgetMin: expectedBudget,
        budgetMax: expectedBudget,
        startDate: formattedStartDate,
        deadline: formattedDeadline,
        completionDeadline: formattedCompletion,
        categoryId: categoryId,
        currencyId: currencyId,
        locationId: 1,
        statusId: 1,
      );

      if (result['success']) {
        final int newTenderId = result['data']['id'];

        final bool fileUploaded = await _apiService.uploadTenderAttachment(
          tenderId: newTenderId,
          file: selectedFile!,
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
    applyDeadCtrl.dispose();
    finishDeadCtrl.dispose();
    budgetCtrl.dispose();
    super.onClose();
  }
}

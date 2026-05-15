import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      print("Title: ${titleCtrl.text}");
      print("Description: ${descCtrl.text}");
      print("Selected Activity: ${selectedActivity.value}");
      print("Applying Deadline: ${applyDeadCtrl.text}");
      print("Completion Deadline: ${finishDeadCtrl.text}");
      print("Expected Budget: ${budgetCtrl.text}");
      print("Currency: ${currency.value}");
      print("Uploading file: ${selectedFile!.path}");

      await Future.delayed(const Duration(seconds: 2));

      Get.back();
      Get.snackbar(
        "Success",
        "Tender submitted successfully.\nWaiting for admin approval.",
      );
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

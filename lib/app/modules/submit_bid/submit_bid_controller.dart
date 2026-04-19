import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../tender_details/tender_details_model.dart';

class SubmitBidController extends GetxController {
  final TenderDetailsModel tender = Get.arguments;

  final formKey = GlobalKey<FormState>();

  // Controllers
  final amountCtrl = TextEditingController();
  final planCtrl = TextEditingController();
  final deliverablesCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // Observables
  var currency = "USD".obs;
  var fileName = "".obs;
  var agreedTerms = false.obs;
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

    if (!agreedTerms.value) {
      Get.snackbar("Required", "Please accept the terms and conditions.");
      return;
    }

    if (selectedFile == null) {
      Get.snackbar("Error", "Please attach your proposal document.");
      return;
    }

    isSubmitting.value = true;

    try {
      print("Uploading file: ${selectedFile!.path}");

      await Future.delayed(const Duration(seconds: 2));

      Get.back();
      Get.snackbar("Success", "Proposal submitted successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit: ${e.toString()}");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    planCtrl.dispose();
    deliverablesCtrl.dispose();
    durationCtrl.dispose();
    companyCtrl.dispose();
    contactCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}

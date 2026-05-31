import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import '../tender_details/tender_details_model.dart';
import 'submit_bid_model.dart';

class SubmitBidController extends GetxController {
  final TenderDetailsModel tender = Get.arguments;
  final ApiService apiService = ApiService();
  final formKey = GlobalKey<FormState>();

  final amountCtrl = TextEditingController();
  final planCtrl = TextEditingController();
  final deliverablesCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

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
      final bidModel = SubmitBidModel(
        tenderId: tender.id,
        title: "Bid for ${tender.title}",
        proposal: planCtrl.text,
        totalPrice: double.parse(amountCtrl.text),
        executionPlan: planCtrl.text,
        deliverables: deliverablesCtrl.text,
        estimatedDuration: durationCtrl.text,
        companyName: companyCtrl.text,
        contactPerson: contactCtrl.text,
        contactEmail: emailCtrl.text,
        contactPhone: phoneCtrl.text,
      );

      final bidResponse = await apiService.submitBid(bidModel);

      if (bidResponse['success'] == true) {
        final int bidId = bidResponse['data']['id'];

        final bool docUploaded = await apiService.uploadBidDocument(
          bidId: bidId,
          file: selectedFile!,
        );

        if (docUploaded) {
          Get.back();
          Get.snackbar("Success", "Proposal submitted successfully.");
        } else {
          Get.snackbar(
            "Error",
            "Bid data created, but document upload failed.",
          );
        }
      } else {
        Get.snackbar("Error", bidResponse['message'] ?? "Submission failed.");
      }
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

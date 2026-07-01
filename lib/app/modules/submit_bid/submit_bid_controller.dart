import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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
  final proposalCtrl = TextEditingController();
  final planCtrl = TextEditingController();
  final deliverablesCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  var currency = "USD".obs; //
  var fileName = "".obs;
  var agreedTerms = false.obs;
  var isSubmitting = false.obs;

  File? selectedMobileFile;
  Uint8List? selectedWebFile;

  @override
  void onInit() {
    super.onInit();
    _extractTenderCurrency();
  }

  void _extractTenderCurrency() {
    if (tender.currency != null) {
      currency.value = tender.currency;
    }
  }

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

    if (!agreedTerms.value) {
      Get.snackbar("Required", "Please accept the terms and conditions.");
      return;
    }

    if (selectedMobileFile == null && selectedWebFile == null) {
      Get.snackbar("Error", "Please attach your proposal document.");
      return;
    }

    isSubmitting.value = true;

    try {
      final bidModel = SubmitBidModel(
        tenderId: tender.id,
        title: "Bid for ${tender.title}",
        proposal: proposalCtrl.text.trim(),
        totalPrice: double.tryParse(amountCtrl.text) ?? 0.0,
        executionPlan: planCtrl.text.trim(),
        deliverables: deliverablesCtrl.text.trim(),
        estimatedDuration: durationCtrl.text.trim(),
        companyName: companyCtrl.text.trim(),
        contactPerson: contactCtrl.text.trim(),
        contactEmail: emailCtrl.text.trim(),
        contactPhone: phoneCtrl.text.trim(),
      );

      final bidResponse = await apiService.submitBid(bidModel);

      if (bidResponse['success'] == true) {
        final int bidId = bidResponse['data']['id'];

        final bool docUploaded = await apiService.uploadBidDocument(
          bidId: bidId,
          mobileFile: selectedMobileFile,
          webFileBytes: selectedWebFile,
          fileName: fileName.value,
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
    proposalCtrl.dispose();
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

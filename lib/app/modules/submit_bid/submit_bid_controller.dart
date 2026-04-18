import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../tender_details/tender_details_model.dart';
import 'submit_bid_model.dart';

class SubmitBidController extends GetxController {
  final TenderDetailsModel tender = Get.arguments;

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

  Future<void> pickFile() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    // if (result != null) {
    //   fileName.value = result.files.single.name;
    // } else {
    //   Get.snackbar("Cancelled", "No file selected");
    // }
    fileName.value = "Proposal_Document.pdf";
  }

  Future<void> submitBidApi() async {
    if (!formKey.currentState!.validate()) return;

    if (!agreedTerms.value) {
      Get.snackbar(
        "Required",
        "Please accept the terms and conditions.",
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    if (fileName.value.isEmpty) {
      Get.snackbar("Error", "Please attach your proposal document.");
      return;
    }

    isSubmitting.value = true;

    try {
      final payload = SubmitBidModel(
        tenderId: tender.id,
        bidAmount: double.tryParse(amountCtrl.text) ?? 0.0,
        currency: currency.value,
        executionPlan: planCtrl.text,
        duration: durationCtrl.text,
        bidderName: companyCtrl.text,
        email: emailCtrl.text,
        phone: phoneCtrl.text,
        agreedTerms: agreedTerms.value,
      );

      // Perform your actual API logic here
      await Future.delayed(const Duration(seconds: 2));

      Get.back();
      Get.snackbar(
        "Success",
        "Proposal submitted successfully.",
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
      );
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

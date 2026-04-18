import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'submit_bid_controller.dart';

class SubmitBidView extends GetView<SubmitBidController> {
  const SubmitBidView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Bid Submission")),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 400),
                childAnimationBuilder: (w) => SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(child: w),
                ),
                children: [
                  Text(
                    controller.tender.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  _buildSection("Pricing", [
                    _customTextField(
                      "Total Bid Amount",
                      controller.amountCtrl,
                      true,
                    ),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.currency.value,
                        decoration: InputDecoration(
                          labelText: "Currency",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: ["USD", "EUR", "JD", "BDSM"]
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) => controller.currency.value = v!,
                      ),
                    ),
                  ]),
                  _buildSection("Technical Proposal", [
                    _customTextField(
                      "Execution Plan / Methodology",
                      controller.planCtrl,
                      false,
                      lines: 3,
                    ),
                    _customTextField(
                      "Deliverables",
                      controller.deliverablesCtrl,
                      false,
                      lines: 2,
                    ),
                  ]),
                  _buildSection("Timeline", [
                    _customTextField(
                      "Estimated Duration (e.g. 30 days)",
                      controller.durationCtrl,
                      false,
                    ),
                  ]),
                  _buildSection("Bidder Information", [
                    _customTextField(
                      "Company Name",
                      controller.companyCtrl,
                      false,
                    ),
                    _customTextField(
                      "Contact Person",
                      controller.contactCtrl,
                      false,
                    ),
                    _customTextField("Email", controller.emailCtrl, false),
                    _customTextField("Phone", controller.phoneCtrl, false),
                  ]),
                  _buildSection("Supporting Documents", [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          const Text("Upload Tech & Financial Proposals"),
                          const Spacer(),
                          IconButton(
                            onPressed: controller.pickFile,
                            icon: const Icon(Icons.attach_file),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.fileName.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Selected: ${controller.fileName.value}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ]),
                  _buildSection("Compliance", [
                    Obx(
                      () => CheckboxListTile(
                        title: const Text(
                          "I confirm all info is accurate and accept terms.",
                        ),
                        value: controller.agreedTerms.value,
                        onChanged: (v) => controller.agreedTerms.value = v!,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(colorScheme),
    );
  }

  Widget _buildSection(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      ...children,
    ],
  );

  Widget _customTextField(
    String label,
    TextEditingController ctrl,
    bool isNum, {
    int lines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: ctrl,
      maxLines: lines,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    ),
  );

  Widget _buildBottomBar(ColorScheme colorScheme) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: colorScheme.surface,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
    ),
    child: Obx(
      () => ElevatedButton(
        onPressed: controller.isSubmitting.value
            ? null
            : controller.submitBidApi,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: colorScheme.primary,
        ),
        child: controller.isSubmitting.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("SUBMIT PROPOSAL"),
      ),
    ),
  );
}

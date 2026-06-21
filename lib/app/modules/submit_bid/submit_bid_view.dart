import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';
import 'submit_bid_controller.dart';

class SubmitBidView extends GetView<SubmitBidController> {
  const SubmitBidView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveLayout(
      mobile: _buildMobileLayout(context, colorScheme),
      desktop: _buildDesktopLayout(context, colorScheme),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ColorScheme colorScheme) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bid Submission")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _FormFields(controller: controller, isDesktop: false),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(colorScheme, isDesktop: false),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ColorScheme colorScheme) {
    final theme = ThemeController.to;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(12),
                        hoverColor: colorScheme.primary.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                color: theme.textPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Back to Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Submit Your Proposal",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: theme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "You are currently preparing a bid for:",
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.tender.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Ensure your technical proposal is detailed and your financial estimations are accurate before submitting.",
                                style: TextStyle(
                                  color: theme.textSecondary,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.borderColor),
                      boxShadow: theme.isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(40),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FormFields(
                              controller: controller,
                              isDesktop: true,
                            ),
                            const SizedBox(height: 24),
                            _buildBottomBar(colorScheme, isDesktop: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme, {required bool isDesktop}) {
    return Container(
      padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(24),
      decoration: isDesktop
          ? null
          : BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submitBidApi,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isDesktop ? 0 : 2,
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "SUBMIT PROPOSAL",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormFields extends StatelessWidget {
  final SubmitBidController controller;
  final bool isDesktop;

  const _FormFields({required this.controller, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 400),
          childAnimationBuilder: (w) => SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(child: w),
          ),
          children: [
            if (!isDesktop) ...[
              Text(
                controller.tender.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 32),
            ],

            _buildSection("Pricing", [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _customTextField(
                        "Total Bid Amount",
                        controller.amountCtrl,
                        true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCurrencyDropdown()),
                  ],
                )
              else ...[
                _customTextField(
                  "Total Bid Amount",
                  controller.amountCtrl,
                  true,
                ),
                _buildCurrencyDropdown(),
              ],
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
              if (isDesktop) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _customTextField(
                        "Company Name",
                        controller.companyCtrl,
                        false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _customTextField(
                        "Contact Person",
                        controller.contactCtrl,
                        false,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _customTextField(
                        "Email",
                        controller.emailCtrl,
                        false,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return "This field is required";
                          if (!GetUtils.isEmail(v))
                            return "Enter a valid email address";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _customTextField(
                        "Phone",
                        controller.phoneCtrl,
                        false,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _customTextField("Company Name", controller.companyCtrl, false),
                _customTextField(
                  "Contact Person",
                  controller.contactCtrl,
                  false,
                ),
                _customTextField(
                  "Email",
                  controller.emailCtrl,
                  false,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "This field is required";
                    if (!GetUtils.isEmail(v))
                      return "Enter a valid email address";
                    return null;
                  },
                ),
                _customTextField("Phone", controller.phoneCtrl, false),
              ],
            ]),

            _buildSection("Supporting Documents", [
              Obx(() {
                if (controller.fileName.value.isEmpty) {
                  return _buildUploadButton(colorScheme);
                } else {
                  return _buildSelectedFile(colorScheme);
                }
              }),
            ]),

            const SizedBox(height: 16),

            Obx(
              () => CheckboxListTile(
                title: Text(
                  "I agree to the terms and conditions of this tender proposal",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeController.to.textPrimary,
                  ),
                ),
                value: controller.agreedTerms.value,
                onChanged: (v) => controller.agreedTerms.value = v!,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: colorScheme.primary,
                checkColor: Colors.white,
              ),
            ),
            if (isDesktop)
              const SizedBox(height: 24)
            else
              const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.currency.value,
        dropdownColor: ThemeController.to.cardColor,
        decoration: InputDecoration(
          labelText: "Currency",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: ["USD", "EUR", "JD"]
            .map(
              (c) => DropdownMenuItem(
                value: c,
                child: Text(
                  c,
                  style: TextStyle(color: ThemeController.to.textPrimary),
                ),
              ),
            )
            .toList(),
        onChanged: (v) => controller.currency.value = v!,
      ),
    );
  }

  Widget _buildUploadButton(ColorScheme colorScheme) {
    return InkWell(
      onTap: controller.pickFile,
      borderRadius: BorderRadius.circular(12),
      hoverColor: colorScheme.primary.withOpacity(0.05),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.upload_file_rounded, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Upload Tech & Financial Proposals (PDF, DOC)",
                style: TextStyle(color: ThemeController.to.textPrimary),
              ),
            ),
            Icon(Icons.attach_file, color: ThemeController.to.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFile(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.05),
        border: Border.all(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.fileName.value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: ThemeController.to.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: ThemeController.to.textSecondary),
            onPressed: controller.removeFile,
            tooltip: "Remove File",
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeController.to.textPrimary,
          ),
        ),
      ),
      ...children
          .map(
            (w) =>
                Padding(padding: const EdgeInsets.only(bottom: 16), child: w),
          )
          .toList(),
    ],
  );

  Widget _customTextField(
    String label,
    TextEditingController ctrl,
    bool isNum, {
    int lines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: lines,
      style: TextStyle(color: ThemeController.to.textPrimary),
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: ThemeController.to.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator:
          validator ?? (v) => v!.isEmpty ? "This field is required" : null,
    );
  }
}

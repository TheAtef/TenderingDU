import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/modules/create_tender/create_tender_controller.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';

class CreateTenderView extends GetView<CreateTenderController> {
  const CreateTenderView({super.key});

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
      appBar: AppBar(title: Text("create_tender".tr)),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _FormFields(controller: controller, isDesktop: false),
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
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "back".tr,
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
                        "create_tender".tr,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: theme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "heading".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.textSecondary,
                          height: 1.5,
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
                              Icons.info_outline_rounded,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Make sure to provide clear documentation and accurate timelines to attract the best bids.",
                                style: TextStyle(
                                  color: theme.textSecondary,
                                  fontSize: 14,
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
              : Text(
                  "submit_tender".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}

class _FormFields extends StatelessWidget {
  final CreateTenderController controller;
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
                "heading".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Divider(height: 32),
            ],

            _buildSection("basics".tr, [
              _customTextField("title".tr, controller.titleCtrl, false),
              _customTextField(
                "description".tr,
                controller.descCtrl,
                false,
                lines: 3,
              ),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedActivity.value,
                  dropdownColor: ThemeController.to.cardColor,
                  decoration: InputDecoration(
                    labelText: "category".tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: controller.activities
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => controller.selectedActivity.value = v!,
                  validator: (value) =>
                      value == null ? "select_category".tr : null,
                ),
              ),
            ]),

            _buildSection("pricing".tr, [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _customTextField(
                        "expected_budget".tr,
                        controller.budgetCtrl,
                        true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCurrencyDropdown()),
                  ],
                )
              else ...[
                _customTextField(
                  "expected_budget".tr,
                  controller.budgetCtrl,
                  true,
                ),
                _buildCurrencyDropdown(),
              ],
            ]),

            _buildSection("timeline".tr, [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _DatePicker(
                        label: "applying_deadline".tr,
                        dateController: controller.applyDeadCtrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DatePicker(
                        label: "completion_deadline".tr,
                        dateController: controller.finishDeadCtrl,
                      ),
                    ),
                  ],
                )
              else ...[
                _DatePicker(
                  label: "applying_deadline".tr,
                  dateController: controller.applyDeadCtrl,
                ),
                _DatePicker(
                  label: "completion_deadline".tr,
                  dateController: controller.finishDeadCtrl,
                ),
              ],
            ]),

            _buildSection("supporting_documents".tr, [
              Obx(() {
                if (controller.fileName.value.isEmpty) {
                  return _buildUploadButton(colorScheme);
                } else {
                  return _buildSelectedFile(colorScheme);
                }
              }),
            ]),
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
          labelText: "currency".tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: [
          "USD",
          "EUR",
          "JD",
        ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
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
            Expanded(child: Text("upload_hint".tr)),
            const Icon(Icons.attach_file),
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
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: controller.removeFile,
            tooltip: "remove_file".tr,
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: lines,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "req_field".tr : null,
    );
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final TextEditingController dateController;

  const _DatePicker({required this.label, required this.dateController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
          dateController.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
      ),
      validator: (v) => v!.isEmpty ? "req_field".tr : null,
    );
  }
}

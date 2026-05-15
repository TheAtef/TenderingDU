import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/modules/create_tender/create_tender_controller.dart';

class CreateTenderView extends GetView<CreateTenderController> {
  const CreateTenderView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("create_tender".tr)),
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
                    "heading".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Divider(height: 32),
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
                        decoration: InputDecoration(
                          labelText: "category".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: controller.activities
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            controller.selectedActivity.value = v!,
                        validator: (value) =>
                            value == null ? "select_category".tr : null,
                      ),
                    ),
                  ]),
                  _buildSection("pricing".tr, [
                    _customTextField(
                      "expected_budget".tr,
                      controller.budgetCtrl,
                      true,
                    ),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.currency.value,
                        decoration: InputDecoration(
                          labelText: "currency".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: ["USD", "EUR", "JD"]
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) => controller.currency.value = v!,
                      ),
                    ),
                  ]),
                  _buildSection("timeline".tr, [
                    _DatePciker(
                      label: "applying_deadline".tr,
                      dateController: controller.applyDeadCtrl,
                    ),
                    _DatePciker(
                      label: "completion_deadline".tr,
                      dateController: controller.finishDeadCtrl,
                    ),
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

  Widget _buildUploadButton(ColorScheme colorScheme) {
    return InkWell(
      onTap: controller.pickFile,
      borderRadius: BorderRadius.circular(12),
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
  }) => TextFormField(
    controller: ctrl,
    maxLines: lines,
    keyboardType: isNum ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (v) => v!.isEmpty ? "req_field".tr : null,
  );

  Widget _buildBottomBar(ColorScheme colorScheme) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: colorScheme.surface,
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    ),
  );
}

class _DatePciker extends StatelessWidget {
  final String label;
  final TextEditingController dateController;

  const _DatePciker({required this.label, required this.dateController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(), // Earliest allowable date
          lastDate: DateTime(2030), // Latest allowable date
        );
        if (pickedDate != null) {
          // Formats date into "YYYY-MM-DD" or use 'intl' package for custom formats
          String formattedDate =
              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
          dateController.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "req_field".tr : null,
    );
  }
}

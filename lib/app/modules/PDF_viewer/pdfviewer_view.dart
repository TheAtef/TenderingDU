import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'
    as sf; // Add prefix here
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/modules/PDF_viewer/pdfviewer_controller.dart';

class PdfViewerView extends GetView<PdfViewerController> {
  const PdfViewerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.title.value,
            style: TextStyle(color: theme.textPrimary),
          ),
        ),
        backgroundColor: theme.cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textPrimary),
      ),
      body: Obx(() {
        if (controller.pdfUrl.value.isEmpty) {
          return const Center(child: Text("No URL found"));
        }

        return sf.SfPdfViewer.network(
          controller.pdfUrl.value,
          controller: controller.sfPdfController,
          onDocumentLoadFailed: (details) {
            print("PDF LOAD FAILED: ${details.description}");
            Get.snackbar("Error", "Could not load PDF: ${details.description}");
          },
        );
      }),
    );
  }
}

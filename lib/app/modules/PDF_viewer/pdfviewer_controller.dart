import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as sf;

class PdfViewerController extends GetxController {
  late sf.PdfViewerController sfPdfController;

  var pdfUrl = ''.obs;
  var title = 'Tender Document'.obs;

  @override
  void onInit() {
    super.onInit();
    sfPdfController = sf.PdfViewerController();

    final dynamic args = Get.arguments;
    if (args != null && args is Map) {
      pdfUrl.value = args['url'] ?? '';
      title.value = args['title'] ?? "Tender Document";
    }
  }
}

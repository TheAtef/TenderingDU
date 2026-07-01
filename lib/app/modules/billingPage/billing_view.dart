import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';
import 'billing_controller.dart';
import 'billing_model.dart';

class BillingView extends GetView<BillingController> {
  const BillingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    Get.put(BillingController());

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text("Billing & Invoices"),
        backgroundColor: theme.cardColor,
        foregroundColor: theme.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(theme),
        desktop: _buildDesktopLayout(theme),
      ),
    );
  }

  Widget _buildMobileLayout(ThemeController theme) {
    return Column(
      children: [
        _buildTabBar(theme),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.actionBlue),
              );
            }

            final invoicesList = controller.filteredInvoices;
            if (invoicesList.isEmpty) {
              return _buildEmptyState(theme);
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemCount: invoicesList.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildInvoiceCard(
                          context,
                          invoicesList[index],
                          theme,
                          false,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeController theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1300),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Billing Controls",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDesktopTabButton(
                      "Outstanding Invoices",
                      0,
                      Icons.pending_actions_rounded,
                      theme,
                    ),
                    const SizedBox(height: 12),
                    _buildDesktopTabButton(
                      "Paid Receipts History",
                      1,
                      Icons.receipt_long_rounded,
                      theme,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.actionBlue,
                      ),
                    );
                  }

                  final invoicesList = controller.filteredInvoices;
                  if (invoicesList.isEmpty) {
                    return _buildEmptyState(theme);
                  }

                  return AnimationLimiter(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 450,
                            mainAxisExtent: 220,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                      itemCount: invoicesList.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _buildInvoiceCard(
                                context,
                                invoicesList[index],
                                theme,
                                true,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeController theme) {
    return Obx(() {
      return Container(
        color: theme.cardColor,
        child: Row(
          children: [
            _buildTabItem("Outstanding", 0, theme),
            _buildTabItem("Paid Receipts", 1, theme),
          ],
        ),
      );
    });
  }

  Widget _buildTabItem(String label, int index, ThemeController theme) {
    final isActive = controller.activeTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.activeTab.value = index,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.actionBlue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.actionBlue : theme.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTabButton(
    String label,
    int index,
    IconData icon,
    ThemeController theme,
  ) {
    return Obx(() {
      final isActive = controller.activeTab.value == index;
      return InkWell(
        onTap: () => controller.activeTab.value = index,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? Colors.teal.withOpacity(0.12) : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Colors.teal.withOpacity(0.3)
                  : theme.borderColor,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.teal : theme.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.teal : theme.textPrimary,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInvoiceCard(
    BuildContext context,
    BillingInvoice invoice,
    ThemeController theme,
    bool isDesktop,
  ) {
    final isPaid = invoice.paymentStatus == 'Paid';
    final formattedDate = invoice.paymentDate != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(invoice.paymentDate!)
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  invoice.tenderTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPaid
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  invoice.paymentStatus,
                  style: TextStyle(
                    color: isPaid ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Tender ID: #${invoice.tenderId}  •  ${invoice.category}",
            style: TextStyle(color: theme.textSecondary, fontSize: 13),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Publication Fee",
                    style: TextStyle(color: theme.textSecondary, fontSize: 11),
                  ),
                  Text(
                    "\$${invoice.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                ],
              ),
              if (!isPaid)
                ElevatedButton(
                  onPressed: () {
                    _initiatePaymentFlow(
                      context,
                      invoice.tenderId,
                      invoice.amount,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Pay with Sham Cash"),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Paid via Sham Cash",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeController theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: theme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            controller.activeTab.value == 0
                ? "No outstanding invoices"
                : "No receipts found",
            style: TextStyle(color: theme.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _initiatePaymentFlow(
    BuildContext context,
    int tenderId,
    double feeAmount,
  ) {
    if (ResponsiveLayout.isDesktop(context)) {
      _showShamCashDialog(context, tenderId, feeAmount);
    } else {
      _showShamCashBottomSheet(context, tenderId, feeAmount);
    }
  }

  void _showShamCashBottomSheet(
    BuildContext context,
    int tenderId,
    double feeAmount,
  ) {
    final theme = ThemeController.to;
    final ApiService apiService = ApiService();
    bool isProcessing = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(color: theme.borderColor),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentHeader(),
                  const SizedBox(height: 12),
                  _buildPaymentDescription(theme),
                  const SizedBox(height: 20),
                  _buildBarcodeSection(theme),
                  const SizedBox(height: 24),
                  _buildAmountDisplay(feeAmount, theme),
                  const SizedBox(height: 28),
                  _buildSubmitButton(
                    isProcessing: isProcessing,
                    label: "I Have Paid",
                    onPressed: () async {
                      setState(() => isProcessing = true);
                      await _processPayment(apiService, tenderId, feeAmount);
                      setState(() => isProcessing = false);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showShamCashDialog(
    BuildContext context,
    int tenderId,
    double feeAmount,
  ) {
    final theme = ThemeController.to;
    final ApiService apiService = ApiService();
    bool isProcessing = false;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 500,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.borderColor),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPaymentHeader(),
                    const SizedBox(height: 16),
                    _buildPaymentDescription(theme),
                    const SizedBox(height: 24),
                    _buildBarcodeSection(theme),
                    const SizedBox(height: 24),
                    _buildAmountDisplay(feeAmount, theme),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(color: theme.borderColor),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: theme.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSubmitButton(
                            isProcessing: isProcessing,
                            label: "I Have Paid",
                            onPressed: () async {
                              setState(() => isProcessing = true);
                              await _processPayment(
                                apiService,
                                tenderId,
                                feeAmount,
                              );
                              setState(() => isProcessing = false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Sham Cash Payment",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "شام كاش",
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDescription(ThemeController theme) {
    return Text(
      "Scan the barcode using your Sham Cash wallet to complete the transfer.",
      style: TextStyle(color: theme.textSecondary, fontSize: 14),
    );
  }

  Widget _buildBarcodeSection(ThemeController theme) {
    const String walletNumber = "0993112233";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.borderColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              size: 160,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Scan QR to Pay",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Wallet: $walletNumber",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy, size: 16, color: Colors.teal),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: walletNumber));
                  Get.snackbar(
                    "Copied",
                    "Wallet number copied to clipboard",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.teal,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Open your Sham Cash application, scan the QR above, execute the transfer, then tap 'I Have Paid'.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay(double amount, ThemeController theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Invoice Balance",
            style: TextStyle(
              color: theme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton({
    required bool isProcessing,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isProcessing ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }

  Future<void> _processPayment(
    ApiService apiService,
    int tenderId,
    double fee,
  ) async {
    final String mockRef = "SHAM-${DateTime.now().millisecondsSinceEpoch}";
    final result = await apiService.payTender(
      tenderId: tenderId,
      paymentMethod: "Sham Cash",
      paymentReference: mockRef,
      amount: fee,
    );

    if (result['success'] == true) {
      Get.back();
      controller.fetchInvoices();
      Get.snackbar(
        "Payment Successful",
        "Your Sham Cash transaction has been confirmed.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Payment Process Failed",
        result['message'] ?? "Verify your transaction and try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_model.dart';
import 'tender_results_controller.dart';

class TenderResultsView extends GetView<TenderResultsController> {
  const TenderResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "tenders_results".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tenders.isEmpty) {
          return Center(child: Text("no_tenders_available".tr));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.tenders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _TenderCard(item: controller.tenders[index]),
        );
      }),
    );
  }
}

class _TenderCard extends StatelessWidget {
  final TenderDetailsModel item;
  const _TenderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/tender-details', arguments: item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.grid_view_rounded,
              label: "category".tr,
              value: item.category,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.attach_money_rounded,
              label: "budget".tr,
              value: item.estimatedBudget,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.event_available_rounded,
              label: "deadline".tr,
              value: item.deadline,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'waiting_approval_controller.dart';

class WaitingApprovalView extends GetView<WaitingApprovalController> {
  const WaitingApprovalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Icon / Illustration
              Icon(
                Icons.hourglass_empty_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Account Under Review',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Your registration has been received successfully. Please wait while an administrator reviews and approves your account. You will be notified once your account is activated.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // Status check progress indicator or spacer
              Obx(
                () => controller.isCheckingStatus.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox(height: 36),
              ), // matches approx height of loader to avoid layout jump

              const Spacer(),

              // Action Buttons
              FilledButton.icon(
                onPressed: () {
                  if (!controller.isCheckingStatus.value) {
                    controller.checkApprovalStatus();
                  }
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Check Status'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),

              TextButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import '../../widgets/common/banner_ad_widget.dart';

class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60), // Balance the skip button
                  // Page Indicator
                  Obx(() => Row(
                    children: List.generate(
                      controller.onboardingPages.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentPage == index
                              ? Get.theme.primaryColor
                              : Get.theme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  )),
                  // Skip Button
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = controller.onboardingPages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            color: page.backgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            page.icon,
                            size: 120,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Title
                        Text(
                          page.title,
                          style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          page.description,
                          style: Get.textTheme.bodyLarge?.copyWith(
                            color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // Feature List (if any)
                        if (page.features != null && page.features!.isNotEmpty)
                          ...page.features!.map((feature) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Get.theme.primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Banner Ad
                  const BannerAdWidget(),
                  const SizedBox(height: 16),

                  // Navigation Buttons
                  Row(
                    children: [
                      // Previous Button
                      Obx(() => controller.currentPage > 0
                          ? Expanded(
                        child: OutlinedButton(
                          onPressed: controller.previousPage,
                          child: const Text('Previous'),
                        ),
                      )
                          : const Expanded(child: SizedBox())),

                      const SizedBox(width: 16),

                      // Next/Get Started Button
                      Obx(() => Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: controller.isLastPage
                              ? controller.finishOnboarding
                              : controller.nextPage,
                          child: Text(
                            controller.isLastPage ? 'Get Started' : 'Next',
                          ),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
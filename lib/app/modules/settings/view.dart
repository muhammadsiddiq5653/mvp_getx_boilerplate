import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/common/banner_ad_widget.dart';
import 'controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Settings
            Text(
              'Appearance',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  Obx(() => ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Theme'),
                    subtitle: Text(controller.currentThemeText),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: controller.showThemeDialog,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ad Settings
            Text(
              'Ads & Premium',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                    secondary: const Icon(Icons.ads_click),
                    title: const Text('Show Ads'),
                    subtitle: Text(controller.isAdsEnabled
                        ? 'Ads help support the app'
                        : 'Ads are disabled'),
                    value: controller.isAdsEnabled,
                    onChanged: controller.toggleAds,
                  )),
                  const Divider(),
                  Obx(() => ListTile(
                    leading: Icon(
                      controller.isPremiumUser ? Icons.stars : Icons.star_border,
                      color: controller.isPremiumUser ? Colors.amber : null,
                    ),
                    title: Text(controller.isPremiumUser ? 'Premium User' : 'Upgrade to Premium'),
                    subtitle: Text(controller.isPremiumUser
                        ? 'Thank you for supporting us!'
                        : 'Remove ads and unlock features'),
                    trailing: controller.isPremiumUser
                        ? null
                        : const Icon(Icons.arrow_forward_ios),
                    onTap: controller.isPremiumUser ? null : controller.showPremiumDialog,
                  )),
                  if (!controller.isPremiumUser) const Divider(),
                  if (!controller.isPremiumUser)
                    ListTile(
                      leading: const Icon(Icons.video_call),
                      title: const Text('Watch Ad for Reward'),
                      subtitle: const Text('Get premium features temporarily'),
                      trailing: const Icon(Icons.play_arrow),
                      onTap: controller.showRewardedAd,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account Settings
            Text(
              'Account',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    subtitle: const Text('Manage your profile'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: controller.goToProfile,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign Out'),
                    subtitle: const Text('Sign out of your account'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: controller.showSignOutDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About
            Text(
              'About',
              style: Get.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About App'),
                    subtitle: const Text('Version 1.0.0'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: controller.showAboutDialog,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: controller.openPrivacyPolicy,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: controller.openTermsOfService,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Banner Ad at bottom
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
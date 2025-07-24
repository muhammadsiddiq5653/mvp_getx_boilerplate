import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvp_boilerplate/app/routes/app_routes.dart';
import 'package:mvp_boilerplate/app/widgets/common/banner_ad_widget.dart';
import 'controller.dart';


class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(Routes.SETTINGS),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Get.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ready to build something amazing?',
                        style: Get.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.PROFILE),
                        child: const Text('View Profile'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Get.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildActionCard(
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'View your profile',
                    onTap: () => Get.toNamed(Routes.PROFILE),
                  ),
                  _buildActionCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () => Get.toNamed(Routes.SETTINGS),
                  ),
                  _buildActionCard(
                    icon: Icons.analytics,
                    title: 'Analytics',
                    subtitle: 'View statistics',
                    onTap: () => controller.showFeatureComingSoon(),
                  ),
                  _buildActionCard(
                    icon: Icons.help,
                    title: 'Help',
                    subtitle: 'Get support',
                    onTap: () => controller.showFeatureComingSoon(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Banner Ad
              const BannerAdWidget(),
              const SizedBox(height: 24),

              // Recent Activity
              Text(
                'Recent Activity',
                style: Get.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Activity ${index + 1}'),
                      subtitle: Text('This is a sample activity item'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => controller.showFeatureComingSoon(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Get.theme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Get.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Get.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
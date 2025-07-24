import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'controller.dart';
import '../../widgets/common/banner_ad_widget.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.enableEditMode,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(),
              const SizedBox(height: 24),

              // Profile Form
              _buildProfileForm(),
              const SizedBox(height: 24),

              // Action Buttons
              if (controller.isEditing) _buildActionButtons(),
              const SizedBox(height: 24),

              // Account Settings
              _buildAccountSettings(),
              const SizedBox(height: 24),

              // Banner Ad
              const BannerAdWidget(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Get.theme.primaryColor,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: controller.profileImageUrl.isEmpty
                    ? Container(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Get.theme.primaryColor,
                  ),
                )
                    : CachedNetworkImage(
                  imageUrl: controller.profileImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            if (controller.isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: controller.showImagePicker,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          controller.displayName.isEmpty ? 'No Name' : controller.displayName,
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          controller.email,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // Full Name
          TextFormField(
            controller: controller.nameController,
            enabled: controller.isEditing,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: controller.validateName,
          ),
          const SizedBox(height: 16),

          // Email (Read-only)
          TextFormField(
            controller: controller.emailController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // Phone Number
          TextFormField(
            controller: controller.phoneController,
            enabled: controller.isEditing,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: controller.validatePhone,
          ),
          const SizedBox(height: 16),

          // Bio
          TextFormField(
            controller: controller.bioController,
            enabled: controller.isEditing,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Bio',
              prefixIcon: Icon(Icons.info_outline),
              hintText: 'Tell us about yourself...',
            ),
            validator: controller.validateBio,
          ),
          const SizedBox(height: 16),

          // Location
          TextFormField(
            controller: controller.locationController,
            enabled: controller.isEditing,
            decoration: const InputDecoration(
              labelText: 'Location',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // Website
          TextFormField(
            controller: controller.websiteController,
            enabled: controller.isEditing,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Website',
              prefixIcon: Icon(Icons.web_outlined),
            ),
            validator: controller.validateWebsite,
          ),
          const SizedBox(height: 16),

          // Date of Birth
          TextFormField(
            controller: controller.dobController,
            enabled: controller.isEditing,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            onTap: controller.isEditing ? controller.selectDateOfBirth : null,
          ),
          const SizedBox(height: 16),

          // Gender
          DropdownButtonFormField<String>(
            value: controller.gender.isEmpty ? null : controller.gender,
            onChanged: controller.isEditing ? controller.setGender : null,
            decoration: const InputDecoration(
              labelText: 'Gender',
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
              DropdownMenuItem(value: 'prefer_not_to_say', child: Text('Prefer not to say')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: controller.cancelEditing,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.saveProfile,
            child: controller.isSaving
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text('Save'),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Account Settings',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),

          // Email Verification
          ListTile(
            leading: Icon(
              controller.isEmailVerified ? Icons.verified : Icons.warning,
              color: controller.isEmailVerified ? Colors.green : Colors.orange,
            ),
            title: const Text('Email Verification'),
            subtitle: Text(
              controller.isEmailVerified
                  ? 'Your email is verified'
                  : 'Please verify your email',
            ),
            trailing: controller.isEmailVerified
                ? null
                : TextButton(
              onPressed: controller.sendEmailVerification,
              child: const Text('Verify'),
            ),
          ),
          const Divider(),

          // Phone Verification
          ListTile(
            leading: Icon(
              controller.isPhoneVerified ? Icons.verified : Icons.warning,
              color: controller.isPhoneVerified ? Colors.green : Colors.orange,
            ),
            title: const Text('Phone Verification'),
            subtitle: Text(
              controller.isPhoneVerified
                  ? 'Your phone is verified'
                  : 'Please verify your phone number',
            ),
            trailing: controller.isPhoneVerified
                ? null
                : TextButton(
              onPressed: controller.sendPhoneVerification,
              child: const Text('Verify'),
            ),
          ),
          const Divider(),

          // Change Password
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            subtitle: const Text('Update your password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: controller.changePassword,
          ),
          const Divider(),

          // Delete Account
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Permanently delete your account'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: controller.showDeleteAccountDialog,
          ),
        ],
      ),
    );
  }
}
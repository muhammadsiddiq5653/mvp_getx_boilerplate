import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../core/services/firebase_service.dart';
import '../../core/services/admob_service.dart';
import '../../core/controllers/app_controller.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final AdMobService _adMobService = Get.find();
  final AppController _appController = Get.find();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  final dobController = TextEditingController();

  // State variables
  final _isLoading = false.obs;
  final _isEditing = false.obs;
  final _isSaving = false.obs;
  final _profileImageUrl = ''.obs;
  final _displayName = ''.obs;
  final _email = ''.obs;
  final _gender = ''.obs;
  final _dateOfBirth = Rxn<DateTime>();
  final _isEmailVerified = false.obs;
  final _isPhoneVerified = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isEditing => _isEditing.value;
  bool get isSaving => _isSaving.value;
  String get profileImageUrl => _profileImageUrl.value;
  String get displayName => _displayName.value;
  String get email => _email.value;
  String get gender => _gender.value;
  DateTime? get dateOfBirth => _dateOfBirth.value;
  bool get isEmailVerified => _isEmailVerified.value;
  bool get isPhoneVerified => _isPhoneVerified.value;

  // Original data for canceling
  Map<String, dynamic> _originalData = {};

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    locationController.dispose();
    websiteController.dispose();
    dobController.dispose();
    super.onClose();
  }

  // Load user profile data
  Future<void> _loadUserProfile() async {
    try {
      _isLoading.value = true;

      final user = _firebaseService.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // Load user data from Firestore
      final userDoc = await _firebaseService.getUserDocument(user.uid);
      final userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        _populateUserData(userData);
        _saveOriginalData();
      } else {
        // If no user document exists, create one
        await _firebaseService.createUserDocument(user.uid, {
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'phoneNumber': user.phoneNumber,
        });
        _loadUserProfile(); // Reload after creating
      }
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to load profile: ${e.toString()}',
        isError: true,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _populateUserData(Map<String, dynamic> userData) {
    final user = _firebaseService.currentUser!;

    _displayName.value = userData['displayName'] ?? user.displayName ?? '';
    _email.value = userData['email'] ?? user.email ?? '';
    _profileImageUrl.value = userData['photoURL'] ?? user.photoURL ?? '';
    _gender.value = userData['gender'] ?? '';
    _isEmailVerified.value = userData['isEmailVerified'] ?? user.emailVerified;
    _isPhoneVerified.value = userData['isPhoneVerified'] ?? false;

    // Populate controllers
    nameController.text = _displayName.value;
    emailController.text = _email.value;
    phoneController.text = userData['phoneNumber'] ?? user.phoneNumber ?? '';
    bioController.text = userData['bio'] ?? '';
    locationController.text = userData['location'] ?? '';
    websiteController.text = userData['website'] ?? '';

    // Handle date of birth
    if (userData['dateOfBirth'] != null) {
      _dateOfBirth.value = DateTime.parse(userData['dateOfBirth']);
      dobController.text = DateFormat('yyyy-MM-dd').format(_dateOfBirth.value!);
    }
  }

  void _saveOriginalData() {
    _originalData = {
      'displayName': nameController.text,
      'phoneNumber': phoneController.text,
      'bio': bioController.text,
      'location': locationController.text,
      'website': websiteController.text,
      'dateOfBirth': dobController.text,
      'gender': _gender.value,
      'photoURL': _profileImageUrl.value,
    };
  }

  void _restoreOriginalData() {
    nameController.text = _originalData['displayName'] ?? '';
    phoneController.text = _originalData['phoneNumber'] ?? '';
    bioController.text = _originalData['bio'] ?? '';
    locationController.text = _originalData['location'] ?? '';
    websiteController.text = _originalData['website'] ?? '';
    dobController.text = _originalData['dateOfBirth'] ?? '';
    _gender.value = _originalData['gender'] ?? '';
    _profileImageUrl.value = _originalData['photoURL'] ?? '';
  }

  // Edit mode controls
  void enableEditMode() {
    _isEditing.value = true;
    _saveOriginalData();
  }

  void cancelEditing() {
    _isEditing.value = false;
    _restoreOriginalData();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? validateBio(String? value) {
    if (value != null && value.length > 500) {
      return 'Bio must be less than 500 characters';
    }
    return null;
  }

  String? validateWebsite(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isURL(value)) {
        return 'Please enter a valid website URL';
      }
    }
    return null;
  }

  // Profile image handling
  Future<void> showImagePicker() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt, size: 32),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    const Text('Camera'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo_library, size: 32),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                    const Text('Gallery'),
                  ],
                ),
                if (_profileImageUrl.isNotEmpty)
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, size: 32, color: Colors.red),
                        onPressed: _removeProfileImage,
                      ),
                      const Text('Remove'),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      Get.back(); // Close bottom sheet

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        await _uploadProfileImage(file);
      }
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        isError: true,
      );
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      _isSaving.value = true;

      final user = _firebaseService.currentUser;
      if (user == null) return;

      final imagePath = 'profile_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageUrl = await _firebaseService.uploadFile(imagePath, imageFile);

      if (imageUrl != null) {
        _profileImageUrl.value = imageUrl;

        // Update Firebase Auth profile
        await user.updatePhotoURL(imageUrl);

        _appController.showSnackbar(
          'Success',
          'Profile image updated successfully',
        );
      }
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        isError: true,
      );
    } finally {
      _isSaving.value = false;
    }
  }

  void _removeProfileImage() {
    Get.back(); // Close bottom sheet
    _profileImageUrl.value = '';
    _appController.showSnackbar(
      'Removed',
      'Profile image removed',
    );
  }

  // Date picker
  Future<void> selectDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: _dateOfBirth.value ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _dateOfBirth.value = pickedDate;
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  // Gender setter
  void setGender(String? value) {
    _gender.value = value ?? '';
  }

  // Save profile
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      _isSaving.value = true;

      final user = _firebaseService.currentUser;
      if (user == null) return;

      // Update Firebase Auth profile
      await user.updateDisplayName(nameController.text.trim());

      // Prepare user data for Firestore
      final userData = {
        'displayName': nameController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'bio': bioController.text.trim(),
        'location': locationController.text.trim(),
        'website': websiteController.text.trim(),
        'dateOfBirth': _dateOfBirth.value?.toIso8601String(),
        'gender': _gender.value,
        'photoURL': _profileImageUrl.value,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Update user document in Firestore
      await _firebaseService.updateDocument('users', user.uid, userData);

      // Update local state
      _displayName.value = nameController.text.trim();
      _saveOriginalData();
      _isEditing.value = false;

      // Show interstitial ad after profile update
      _adMobService.incrementInterstitialCounter();

      _appController.showSnackbar(
        'Success',
        'Profile updated successfully',
      );
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        isError: true,
      );
    } finally {
      _isSaving.value = false;
    }
  }

  // Email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseService.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _appController.showSnackbar(
          'Verification Email Sent',
          'Please check your email and click the verification link',
        );
      }
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to send verification email: ${e.toString()}',
        isError: true,
      );
    }
  }

  // Phone verification
  Future<void> sendPhoneVerification() async {
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      _appController.showSnackbar(
        'Phone Required',
        'Please enter your phone number first',
        isError: true,
      );
      return;
    }

    try {
      await _firebaseService.auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed
          await _firebaseService.currentUser?.updatePhoneNumber(credential);
          _isPhoneVerified.value = true;
          await _firebaseService.updateDocument('users', _firebaseService.currentUser!.uid, {
            'isPhoneVerified': true,
            'phoneNumber': phoneNumber,
          });
          _appController.showSnackbar(
            'Phone Verified',
            'Your phone number has been verified',
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          _appController.showSnackbar(
            'Verification Failed',
            e.message ?? 'Phone verification failed',
            isError: true,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          _showVerificationCodeDialog(verificationId, phoneNumber);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
        },
      );
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to send verification code: ${e.toString()}',
        isError: true,
      );
    }
  }

  void _showVerificationCodeDialog(String verificationId, String phoneNumber) {
    final codeController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Enter Verification Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('We sent a verification code to $phoneNumber'),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                hintText: 'Enter 6-digit code',
              ),
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = codeController.text.trim();
              if (code.length == 6) {
                await _verifyPhoneCode(verificationId, code, phoneNumber);
                Get.back();
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyPhoneCode(String verificationId, String code, String phoneNumber) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      await _firebaseService.currentUser?.updatePhoneNumber(credential);
      _isPhoneVerified.value = true;

      await _firebaseService.updateDocument('users', _firebaseService.currentUser!.uid, {
        'isPhoneVerified': true,
        'phoneNumber': phoneNumber,
      });

      _appController.showSnackbar(
        'Phone Verified',
        'Your phone number has been verified successfully',
      );
    } catch (e) {
      _appController.showSnackbar(
        'Verification Failed',
        'Invalid verification code',
        isError: true,
      );
    }
  }

  // Change password
  Future<void> changePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updatePassword(
                currentPasswordController.text,
                newPasswordController.text,
                confirmPasswordController.text,
              );
              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePassword(String currentPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      _appController.showSnackbar(
        'Password Mismatch',
        'New passwords do not match',
        isError: true,
      );
      return;
    }

    if (newPassword.length < 6) {
      _appController.showSnackbar(
        'Weak Password',
        'Password must be at least 6 characters long',
        isError: true,
      );
      return;
    }

    try {
      final user = _firebaseService.currentUser;
      if (user?.email != null) {
        // Re-authenticate user
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(newPassword);

        _appController.showSnackbar(
          'Password Updated',
          'Your password has been updated successfully',
        );
      }
    } catch (e) {
      String message = 'Failed to update password';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'wrong-password':
            message = 'Current password is incorrect';
            break;
          case 'weak-password':
            message = 'New password is too weak';
            break;
          case 'requires-recent-login':
            message = 'Please log in again and try';
            break;
          default:
            message = e.message ?? message;
        }
      }
      _appController.showSnackbar('Error', message, isError: true);
    }
  }

  // Delete account
  void showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete your account?'),
            SizedBox(height: 8),
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _confirmDeleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Account Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your password to confirm account deletion:'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _deleteAccount(passwordController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(String password) async {
    try {
      final user = _firebaseService.currentUser;
      if (user?.email != null) {
        // Re-authenticate user
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        // Delete user document from Firestore
        await _firebaseService.deleteDocument('users', user.uid);

        // Delete user account
        await user.delete();

        _appController.showSnackbar(
          'Account Deleted',
          'Your account has been deleted successfully',
        );

        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      String message = 'Failed to delete account';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'wrong-password':
            message = 'Password is incorrect';
            break;
          case 'requires-recent-login':
            message = 'Please log in again and try';
            break;
          default:
            message = e.message ?? message;
        }
      }
      _appController.showSnackbar('Error', message, isError: true);
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await _loadUserProfile();
  }
}
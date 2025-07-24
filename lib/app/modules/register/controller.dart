import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvp_boilerplate/app/core/controllers/app_controller.dart';
import 'package:mvp_boilerplate/app/core/services/firebase_service.dart';
import 'package:mvp_boilerplate/app/core/services/storage_service.dart';
import 'package:mvp_boilerplate/app/routes/app_routes.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class RegisterController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final StorageService _storageService = Get.find();
  final AppController _appController = Get.find();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // State variables
  final _isLoading = false.obs;
  final _isPasswordHidden = true.obs;
  final _isConfirmPasswordHidden = true.obs;
  final _acceptTerms = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isPasswordHidden => _isPasswordHidden.value;
  bool get isConfirmPasswordHidden => _isConfirmPasswordHidden.value;
  bool get acceptTerms => _acceptTerms.value;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    _isPasswordHidden.value = !_isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordHidden.value = !_isConfirmPasswordHidden.value;
  }

  void toggleTermsAcceptance(bool? value) {
    _acceptTerms.value = value ?? false;
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Email/Password Registration
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    if (!acceptTerms) {
      _appController.showSnackbar(
        'Terms Required',
        'Please accept the Terms of Service and Privacy Policy',
        isError: true,
      );
      return;
    }

    try {
      _isLoading.value = true;

      final userCredential = await _firebaseService.createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userCredential != null) {
        // Update user profile
        await userCredential.user!.updateDisplayName(nameController.text.trim());

        await _handleSuccessfulRegistration(userCredential.user);
      }
    } catch (e) {
      _handleRegistrationError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Google Sign Up
  Future<void> signUpWithGoogle() async {
    try {
      _isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _firebaseService.auth.signInWithCredential(credential);
        await _handleSuccessfulRegistration(userCredential.user);
      }
    } catch (e) {
      _handleRegistrationError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Apple Sign Up
  Future<void> signUpWithApple() async {
    try {
      _isLoading.value = true;

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseService.auth.signInWithCredential(oauthCredential);
      await _handleSuccessfulRegistration(userCredential.user);
    } catch (e) {
      _handleRegistrationError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Facebook Sign Up
  Future<void> signUpWithFacebook() async {
    try {
      _isLoading.value = true;

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

        final userCredential = await _firebaseService.auth.signInWithCredential(facebookAuthCredential);
        await _handleSuccessfulRegistration(userCredential.user);
      } else {
        throw Exception('Facebook sign up failed: ${result.message}');
      }
    } catch (e) {
      _handleRegistrationError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Handle successful registration
  Future<void> _handleSuccessfulRegistration(User? user) async {
    if (user != null) {
      // Save user token
      final token = await user.getIdToken();
      await _storageService.setUserToken(token!);

      // Create user document in Firestore
      await _firebaseService.createUserDocument(user.uid, {
        'email': user.email,
        'displayName': user.displayName ?? nameController.text.trim(),
        'photoURL': user.photoURL,
        'phoneNumber': user.phoneNumber,
        'bio': '',
        'location': '',
        'website': '',
        'dateOfBirth': null,
        'gender': '',
        'isEmailVerified': user.emailVerified,
        'isPhoneVerified': false,
        'preferences': {
          'notifications': true,
          'emailUpdates': true,
          'marketing': false,
        },
      });

      // Send email verification if not verified
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        _appController.showSnackbar(
          'Verification Email Sent',
          'Please check your email and verify your account',
        );
      }

      _appController.showSnackbar(
        'Account Created!',
        'Welcome to the app! Your account has been created successfully.',
      );

      Get.offAllNamed(Routes.HOME);
    }
  }

  // Handle registration errors
  void _handleRegistrationError(dynamic error) {
    String message = 'An error occurred during registration';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          message = 'An account with this email already exists';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'The password is too weak';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection';
          break;
        default:
          message = error.message ?? message;
      }
    } else {
      message = error.toString();
    }

    _appController.showSnackbar('Registration Failed', message, isError: true);
  }
}
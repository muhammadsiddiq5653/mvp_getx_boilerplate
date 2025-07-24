import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvp_boilerplate/app/core/controllers/app_controller.dart';
import 'package:mvp_boilerplate/app/core/services/firebase_service.dart';
import 'package:mvp_boilerplate/app/core/services/storage_service.dart';
import 'package:mvp_boilerplate/app/routes/app_routes.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class LoginController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final StorageService _storageService = Get.find();
  final AppController _appController = Get.find();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State variables
  final _isLoading = false.obs;
  final _isPasswordHidden = true.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isPasswordHidden => _isPasswordHidden.value;

  @override
  void onInit() {
    super.onInit();
    _checkIfAlreadyLoggedIn();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _checkIfAlreadyLoggedIn() {
    if (_firebaseService.isLoggedIn) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void togglePasswordVisibility() {
    _isPasswordHidden.value = !_isPasswordHidden.value;
  }

  // Validation methods
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
    return null;
  }

  // Email/Password Login
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      _isLoading.value = true;

      final userCredential = await _firebaseService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userCredential != null) {
        await _handleSuccessfulLogin(userCredential.user);
      }
    } catch (e) {
      _handleLoginError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
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
        await _handleSuccessfulLogin(userCredential.user);
      }
    } catch (e) {
      _handleLoginError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Apple Sign In
  Future<void> signInWithApple() async {
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
      await _handleSuccessfulLogin(userCredential.user);
    } catch (e) {
      _handleLoginError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Facebook Sign In
  Future<void> signInWithFacebook() async {
    try {
      _isLoading.value = true;

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

        final userCredential = await _firebaseService.auth.signInWithCredential(facebookAuthCredential);
        await _handleSuccessfulLogin(userCredential.user);
      } else {
        throw Exception('Facebook login failed: ${result.message}');
      }
    } catch (e) {
      _handleLoginError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Handle successful login
  Future<void> _handleSuccessfulLogin(User? user) async {
    if (user != null) {
      // Save user token
      final token = await user.getIdToken();
      await _storageService.setUserToken(token!);

      // Check if user document exists, if not create it
      final userDoc = await _firebaseService.getUserDocument(user.uid);
      if (!userDoc.exists) {
        await _firebaseService.createUserDocument(user.uid, {
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'phoneNumber': user.phoneNumber,
        });
      }

      _appController.showSnackbar(
        'Welcome!',
        'You have successfully signed in',
      );

      Get.offAllNamed(Routes.HOME);
    }
  }

  // Handle login errors
  void _handleLoginError(dynamic error) {
    String message = 'An error occurred during login';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password provided';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'too-many-requests':
          message = 'Too many failed attempts. Please try again later';
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

    _appController.showSnackbar('Login Failed', message, isError: true);
  }

  // Forgot Password
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _appController.showSnackbar(
        'Email Required',
        'Please enter your email address first',
        isError: true,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _appController.showSnackbar(
        'Invalid Email',
        'Please enter a valid email address',
        isError: true,
      );
      return;
    }

    try {
      await _firebaseService.sendPasswordResetEmail(email);
      _appController.showSnackbar(
        'Password Reset Email Sent',
        'Please check your email for password reset instructions',
      );
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to send password reset email. Please try again.',
        isError: true,
      );
    }
  }
}
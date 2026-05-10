import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/app_auth_service.dart';

class AuthController extends GetxController {
  AuthController(this._authService);

  final AppAuthService _authService;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isRegisterMode = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<AuthSession> session = Rxn<AuthSession>();

  @override
  void onInit() {
    super.onInit();
    session.value = _authService.currentSession();
    _authService.authStateChanges().listen((AuthSession? value) {
      session.value = value;
    });
  }

  Future<void> continueAsGuest() async {
    await _authService.ensureGuestSession();
    Get.back();
  }

  Future<void> submitEmailAuth() async {
    errorMessage.value = '';
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.length < 6) {
      errorMessage.value = 'Nhập email hợp lệ và mật khẩu tối thiểu 6 ký tự.';
      return;
    }
    await _run(() async {
      if (isRegisterMode.value) {
        await _authService.registerWithEmail(email: email, password: password);
      } else {
        await _authService.signInWithEmail(email: email, password: password);
      }
      Get.back();
    });
  }

  Future<void> signInWithGoogle() async {
    errorMessage.value = '';
    await _run(() async {
      await _authService.signInWithGoogle();
      Get.back();
    });
  }

  Future<void> signInWithApple() async {
    errorMessage.value = '';
    await _run(() async {
      await _authService.signInWithApple();
      Get.back();
    });
  }

  Future<void> signOut() async {
    errorMessage.value = '';
    await _run(() => _authService.signOut());
  }

  Future<void> _run(Future<void> Function() action) async {
    isLoading.value = true;
    try {
      await action();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

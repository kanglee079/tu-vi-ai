import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class AuthPlaceholderPage extends GetView<AuthController> {
  const AuthPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.jade),
                    SizedBox(height: 16),
                    Text('Đang xử lý...'),
                  ],
                ),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        // Logo + Brand
                        _buildBrand(context),
                        const Spacer(flex: 1),
                        // Main auth options
                        _buildSocialButtons(context),
                        const SizedBox(height: 24),
                        _buildDivider(context),
                        const SizedBox(height: 24),
                        // Email/Password
                        _buildEmailAuth(context),
                        const Spacer(flex: 2),
                        // Guest mode
                        _buildGuestMode(context),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrand(BuildContext context) {
    return Column(
      children: [
        // App icon placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.jade,
                AppColors.jade.withValues(alpha: 0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.jade.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '命',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Minh Mệnh',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Lá số Tử Vi — Bản địa hóa cho người Việt',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Session status
        if (controller.session.value != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.jadeSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.session.value!.isAnonymous
                      ? Icons.person_outline
                      : Icons.check_circle_outline,
                  size: 14,
                  color: AppColors.jade,
                ),
                const SizedBox(width: 6),
                Text(
                  controller.session.value!.isAnonymous
                      ? 'Đang dùng chế độ khách'
                      : 'Đã đăng nhập',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.jade,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        const Spacer(flex: 1),
        Text(
          'Đăng nhập để đồng bộ lá số\nvà mở khóa tính năng đầy đủ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.muted,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Column(
      children: [
        // Google
        _SocialButton(
          icon: _googleIcon(),
          label: 'Tiếp tục với Google',
          onPressed: controller.isLoading.value ? null : controller.signInWithGoogle,
          background: Colors.white,
          foreground: AppColors.ink,
        ),
        const SizedBox(height: 12),
        // Apple
        if (!Platform.isAndroid)
          SignInWithAppleButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.signInWithApple,
            style: SignInWithAppleButtonStyle.black,
          ),
      ],
    );
  }

  Widget _googleIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.line)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'hoặc',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.muted,
                ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.line)),
      ],
    );
  }

  Widget _buildEmailAuth(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'email@example.com',
            prefixIcon: Icon(Icons.email_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => controller.submitEmailAuth(),
          decoration: const InputDecoration(
            labelText: 'Mật khẩu',
            hintText: 'Tối thiểu 6 ký tự',
            prefixIcon: Icon(Icons.lock_outline, size: 20),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: controller.isLoading.value ? null : controller.submitEmailAuth,
          child: Obx(
            () => Text(
              controller.isRegisterMode.value
                  ? 'Tạo tài khoản'
                  : 'Đăng nhập',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.isRegisterMode.value
                  ? 'Đã có tài khoản? '
                  : 'Chưa có tài khoản? ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            GestureDetector(
              onTap: () => controller.isRegisterMode.value = !controller.isRegisterMode.value,
              child: Text(
                controller.isRegisterMode.value ? 'Đăng nhập' : 'Đăng ký ngay',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.jade,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestMode(BuildContext context) {
    if (controller.session.value?.isAnonymous == false) {
      return Column(
        children: [
          const Divider(),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isLoading.value ? null : controller.signOut,
            child: const Text('Đăng xuất'),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (controller.errorMessage.value.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.caution.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.caution.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.caution, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.errorMessage.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.caution,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        OutlinedButton(
          onPressed:
              controller.isLoading.value ? null : controller.continueAsGuest,
          child: const Text('Tiếp tục với chế độ khách'),
        ),
        const SizedBox(height: 8),
        Text(
          'Lá số vẫn được lưu cục bộ.\nĐăng nhập sau để đồng bộ trên nhiều thiết bị.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.muted,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ============================================================
// Social button
// ============================================================

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.background,
    required this.foreground,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

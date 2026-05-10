import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../controllers/auth_controller.dart';

class AuthPlaceholderPage extends GetView<AuthController> {
  const AuthPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập / Đăng ký')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeader(
                    title: 'Firebase Auth',
                    subtitle:
                        'Guest session được giữ bằng anonymous auth, sau đó link lên email/Google/Apple khi người dùng đăng nhập.',
                  ),
                  const SizedBox(height: 12),
                  if (controller.session.value != null)
                    StatusPill(
                      label: controller.session.value!.isAnonymous
                          ? 'Khách cục bộ đã có Firebase UID'
                          : 'Đã đăng nhập: ${controller.session.value!.email ?? controller.session.value!.displayName ?? controller.session.value!.uid}',
                      background: const Color(0xFFD7ECE7),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Chế độ đăng ký mới'),
                    value: controller.isRegisterMode.value,
                    onChanged: (bool value) =>
                        controller.isRegisterMode.value = value,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitEmailAuth,
                    child: Text(
                      controller.isRegisterMode.value
                          ? 'Đăng ký bằng email'
                          : 'Đăng nhập bằng email',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.signInWithGoogle,
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Tiếp tục với Google'),
            ),
            const SizedBox(height: 12),
            if (!Platform.isAndroid)
              SignInWithAppleButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.signInWithApple,
              ),
            if (controller.session.value?.isAnonymous == true) ...<Widget>[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.continueAsGuest,
                child: const Text('Tiếp tục với chế độ khách'),
              ),
            ],
            if (controller.session.value?.isAnonymous == false) ...<Widget>[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.signOut,
                child: const Text('Đăng xuất'),
              ),
            ],
            if (controller.errorMessage.value.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Color(0xFFB85B3A)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

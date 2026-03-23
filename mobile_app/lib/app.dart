import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/auth/views/splash_view.dart';

// Current Role Provider for Theming demo
final roleProvider = StateProvider<AuthRole>((ref) => AuthRole.teacher);

enum AuthRole { teacher, parent }

class DGSmartApp extends ConsumerWidget {
  const DGSmartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRole = ref.watch(roleProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DG Smart',
      theme: authRole == AuthRole.teacher 
        ? AppTheme.getTeacherTheme() 
        : AppTheme.getParentTheme(),
      home: const SplashView(),
    );
  }
}

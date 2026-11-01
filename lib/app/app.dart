import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/app_state_providers.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class GoatCodeApp extends ConsumerWidget {
  const GoatCodeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final accessibility = ref.watch(accessibilityProvider);

    return MaterialApp.router(
      title: 'GoatCode — Aprende Lógica de Programación',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.create(
        textScale: accessibility.textScale,
        highContrast: accessibility.highContrast,
      ),
      routerConfig: router,
    );
  }
}

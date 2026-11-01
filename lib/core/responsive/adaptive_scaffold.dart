import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../storage/app_state_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';
import '../widgets/cosmic_background.dart';
import '../widgets/lives_badge.dart';
import 'responsive_layout.dart';

class AdaptiveScaffold extends ConsumerWidget {
  final Widget body;
  final String currentRoute;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
  });

  int _calculateSelectedIndex(String path) {
    if (path.startsWith('/catalog')) return 1;
    if (path.startsWith('/roadmap')) return 2;
    if (path.startsWith('/mascot')) return 3;
    if (path.startsWith('/profile')) return 4;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/catalog');
        break;
      case 2:
        context.go('/roadmap');
        break;
      case 3:
        context.go('/mascot');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final accessibility = ref.watch(accessibilityProvider);
    final scale = accessibility.textScale.scaleFactor;
    final isCompact = ResponsiveLayout.isCompact(context);
    final selectedIndex = _calculateSelectedIndex(currentRoute);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CosmicBackground(
        child: Row(
          children: [
            if (!isCompact)
              _buildNavigationRail(context, ref, user, selectedIndex, scale),
            Expanded(
              child: Column(
                children: [
                  _buildTopAppBar(context, ref, user, scale, isCompact),
                  Expanded(child: body),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isCompact
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (idx) =>
                  _onDestinationSelected(context, idx),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(
                    Icons.home,
                    color: AppColors.secondaryCyan,
                  ),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_stories_outlined),
                  selectedIcon: Icon(
                    Icons.auto_stories,
                    color: AppColors.secondaryCyan,
                  ),
                  label: 'Cursos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.map_outlined),
                  selectedIcon: Icon(Icons.map, color: AppColors.secondaryCyan),
                  label: 'Ruta',
                ),
                NavigationDestination(
                  icon: Icon(Icons.pets_outlined),
                  selectedIcon: Icon(
                    Icons.pets,
                    color: AppColors.secondaryCyan,
                  ),
                  label: 'Cabra',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(
                    Icons.person,
                    color: AppColors.secondaryCyan,
                  ),
                  label: 'Perfil',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildTopAppBar(
    BuildContext context,
    WidgetRef ref,
    UserProfileState user,
    double scale,
    bool isCompact,
  ) {
    final accessibility = ref.watch(accessibilityProvider);
    final isGlass = accessibility.glassEffectEnabled;

    final barContent = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact
            ? 12.0
            : ResponsiveLayout.horizontalPadding(context),
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: !isGlass ? const Color(0xFF0F0C1C) : null,
        gradient: isGlass
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xF5130E26), Color(0xEA0D0A1C)],
              )
            : null,
        border: const Border(
          bottom: BorderSide(color: Color(0x33A882FF), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          if (isCompact) ...[
            Image.asset(
              user.currentMascotAsset,
              key: ValueKey(user.currentMascotAsset),
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.pets,
                color: AppColors.primaryNeon,
                size: 22,
              ),
            ),
            if (MediaQuery.sizeOf(context).width > 420) ...[
              const SizedBox(width: 6),
              Text(
                'GoatCode',
                style: AppTypography.headingSmall(scale).copyWith(
                  color: AppColors.secondaryCyan,
                  fontWeight: FontWeight.w700,
                  fontSize: 15 * scale,
                ),
              ),
            ],
          ],
          const Spacer(),
          Semantics(
            label: 'Racha de ${user.streak} días',
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 8 : 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.streakFire.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.streakFire.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.streakFire,
                    size: 18,
                  ).animatePulsing(),
                  const SizedBox(width: 4),
                  Text(
                    isCompact ? '${user.streak}' : '${user.streak} días',
                    style: TextStyle(
                      color: AppColors.streakFire,
                      fontWeight: FontWeight.w700,
                      fontSize: 13 * scale,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 8 : 12,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryNeon.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryNeon.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bolt,
                  color: AppColors.primaryNeonLight,
                  size: 18,
                ),
                const SizedBox(width: 2),
                Text(
                  isCompact ? '${user.xp}' : '${user.xp} XP',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13 * scale,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          LivesBadge(compact: isCompact, showCountdown: !isCompact),
          if (!isCompact) ...[
            const SizedBox(width: 4),
            IconButton(
              tooltip: isGlass
                  ? 'Cambiar a modo Obsidiana Mate (Sin reflejos)'
                  : 'Cambiar a modo Cristal Cósmico',
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Icon(
                isGlass ? Icons.auto_awesome : Icons.layers_outlined,
                color: isGlass
                    ? AppColors.primaryNeonLight
                    : AppColors.secondaryCyan,
              ),
              onPressed: () =>
                  ref.read(accessibilityProvider.notifier).toggleGlassEffect(),
            ),
            const SizedBox(width: 4),
            IconButton(
              tooltip: ref.watch(accessibilityProvider).soundEnabled
                  ? 'Silenciar efectos de sonido'
                  : 'Activar efectos de sonido',
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Icon(
                ref.watch(accessibilityProvider).soundEnabled
                    ? Icons.volume_up_rounded
                    : Icons.volume_off_rounded,
                color: ref.watch(accessibilityProvider).soundEnabled
                    ? AppColors.secondaryCyan
                    : AppColors.textMuted,
              ),
              onPressed: () =>
                  ref.read(accessibilityProvider.notifier).toggleSound(),
            ),
          ],
          IconButton(
            tooltip: 'Ajustes de Accesibilidad',
            iconSize: 22,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: const Icon(
              Icons.accessibility_new,
              color: AppColors.secondaryCyan,
            ),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
    );

    return ClipRect(
      child: isGlass
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: barContent,
            )
          : barContent,
    );
  }

  Widget _buildNavigationRail(
    BuildContext context,
    WidgetRef ref,
    UserProfileState user,
    int selectedIndex,
    double scale,
  ) {
    final isDesktop = ResponsiveLayout.isExpanded(context);
    final accessibility = ref.watch(accessibilityProvider);
    final isGlass = accessibility.glassEffectEnabled;
    final mascotAsset = user.currentMascotAsset;

    final railContent = Container(
      width: isDesktop ? 220 : 76,
      decoration: BoxDecoration(
        color: !isGlass ? const Color(0xFF0F0C1C) : null,
        gradient: isGlass
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xF5130E26), Color(0xEA0D0A1C)],
              )
            : null,
        border: const Border(
          right: BorderSide(color: Color(0x33A882FF), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: isDesktop
                ? Row(
                    children: [
                      Image.asset(
                        mascotAsset,
                        key: ValueKey(mascotAsset),
                        width: 38,
                        height: 38,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.pets,
                              color: AppColors.primaryNeon,
                              size: 34,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'GoatCode',
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headingMedium(scale).copyWith(
                            color: AppColors.secondaryCyan,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Image.asset(
                      mascotAsset,
                      key: ValueKey(mascotAsset),
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.pets,
                        color: AppColors.primaryNeon,
                        size: 34,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 30),
          _railItem(
            context,
            0,
            Icons.home_rounded,
            'Inicio',
            selectedIndex == 0,
            isDesktop,
            scale,
          ),
          _railItem(
            context,
            1,
            Icons.auto_stories_rounded,
            'Catálogo',
            selectedIndex == 1,
            isDesktop,
            scale,
          ),
          _railItem(
            context,
            2,
            Icons.map_rounded,
            'Ruta',
            selectedIndex == 2,
            isDesktop,
            scale,
          ),
          _railItem(
            context,
            3,
            Icons.pets_rounded,
            'Mi Cabra',
            selectedIndex == 3,
            isDesktop,
            scale,
          ),
          _railItem(
            context,
            4,
            Icons.person_rounded,
            'Perfil & Ajustes',
            selectedIndex == 4,
            isDesktop,
            scale,
          ),
          const Spacer(),
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGlass,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.offline_bolt,
                      color: AppColors.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '100% Offline Activo',
                        style: AppTypography.caption(scale).copyWith(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );

    return ClipRect(
      child: isGlass
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: railContent,
            )
          : railContent,
    );
  }

  Widget _railItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    bool isSelected,
    bool isDesktop,
    double scale,
  ) {
    return InkWell(
      onTap: () => _onDestinationSelected(context, index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryNeon.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.secondaryCyan : AppColors.textMuted,
              size: 24,
            ),
            if (isDesktop) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14 * scale,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

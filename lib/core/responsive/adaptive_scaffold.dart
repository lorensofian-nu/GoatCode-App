import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../storage/app_state_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
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
      body: Row(
        children: [
          if (!isCompact)
            _buildNavigationRail(context, selectedIndex, user.streak, scale),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact
            ? 12.0
            : ResponsiveLayout.horizontalPadding(context),
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0C1C).withValues(alpha: 0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.surfaceBorder, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          if (isCompact) ...[
            Image.asset(
              'assets/mascot/goat_idle.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.pets,
                color: AppColors.primaryNeon,
                size: 22,
              ),
            ),
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
                  ),
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
          LivesBadge(
            compact: isCompact,
            showCountdown: !isCompact,
          ),
          const SizedBox(width: 4),
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
  }

  Widget _buildNavigationRail(
    BuildContext context,
    int selectedIndex,
    int streak,
    double scale,
  ) {
    final isDesktop = ResponsiveLayout.isExpanded(context);

    return Container(
      width: isDesktop ? 220 : 76,
      decoration: const BoxDecoration(
        color: Color(0xFF0F0C1C),
        border: Border(
          right: BorderSide(color: AppColors.surfaceBorder, width: 1.0),
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
                        'assets/mascot/goat_idle.png',
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
                      'assets/mascot/goat_idle.png',
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

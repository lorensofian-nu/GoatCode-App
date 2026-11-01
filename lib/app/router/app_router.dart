import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/adaptive_scaffold.dart';
import '../../core/storage/app_state_providers.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/lesson/presentation/lesson_screen.dart';
import '../../features/mascot/presentation/mascot_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/roadmap/presentation/roadmap_screen.dart';

/// Listenable that notifies GoRouter when user profile state changes
/// without disposing and recreating the GoRouter instance.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<UserProfileState>(
      userProfileProvider,
      (previous, next) => notifyListeners(),
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: notifier,
    redirect: (context, state) {
      final user = ref.read(userProfileProvider);
      final loc = state.matchedLocation;
      final isOnboarding = loc == '/onboarding';
      final hasUsername = user.isOnboarded;

      if (loc == '/') {
        return hasUsername ? '/dashboard' : '/onboarding';
      }
      if (!hasUsername && !isOnboarding) {
        return '/onboarding';
      }
      if (hasUsername && isOnboarding) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      // Root route redirect
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final user = ref.read(userProfileProvider);
          return user.isOnboarded ? '/dashboard' : '/onboarding';
        },
      ),

      // Onboarding Screen (Outside Shell)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Immersive Lesson Screen (Outside Shell for maximum focus)
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (context, state) {
          final id = state.pathParameters['lessonId'] ?? '';
          return LessonScreen(lessonId: id);
        },
      ),

      // Main Shell Route for Tabbed Navigation
      ShellRoute(
        builder: (context, state, child) {
          return AdaptiveScaffold(
            currentRoute: state.matchedLocation,
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: '/roadmap',
            builder: (context, state) => const RoadmapScreen(),
          ),
          GoRoute(
            path: '/mascot',
            builder: (context, state) => const MascotScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

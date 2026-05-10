import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../router/router_refresh_stream.dart';

part 'app_router.g.dart';

// -----------------------------------------------------------------------------
// 🔐 AUTH STATE PROVIDER (Mock)
// -----------------------------------------------------------------------------
@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() => false; // Default: Not authenticated

  void login() => state = true;
  void logout() => state = false;
}

// -----------------------------------------------------------------------------
// 🗺️ APP ROUTER PROVIDER
// -----------------------------------------------------------------------------
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final isLoggedIn = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/inbound',
    // Refresh the router whenever the auth state changes
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';

      // 🛡️ AuthGuard Logic
      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/inbound';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const PlaceholderLoginScreen(),
      ),
      
      // 🏗️ Main Application Layout (Bottom Navigation)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch A: Inbound
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inbound',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Inbound (Receiving Tasks)',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          
          // Branch B: Outbound
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/outbound',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Outbound (Picking & Dispatch)',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          
          // Branch C: Admin
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Admin (CQRS Dashboard)',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// -----------------------------------------------------------------------------
// 🖼️ UI COMPONENTS & PLACEHOLDERS
// -----------------------------------------------------------------------------

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inbound',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Outbound',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize_outlined),
            selectedIcon: Icon(Icons.dashboard_customize),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final Color color;
  const PlaceholderScreen({required this.title, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withOpacity(0.1),
        actions: [
          Consumer(builder: (context, ref, child) {
            return IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authStateProvider.notifier).logout(),
            );
          }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text('This screen is currently under construction.'),
          ],
        ),
      ),
    );
  }
}

class PlaceholderLoginScreen extends ConsumerWidget {
  const PlaceholderLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'PWMS Login',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => ref.read(authStateProvider.notifier).login(),
                  child: const Text('SIMULATE LOGIN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

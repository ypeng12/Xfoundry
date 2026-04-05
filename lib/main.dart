import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const XfoundryApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/housing',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/housing',
          builder: (context, state) => const PlaceholderScreen(title: 'University Housing'),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const PlaceholderScreen(title: 'Google Calendar Agent'),
        ),
        GoRoute(
          path: '/canva',
          builder: (context, state) => const PlaceholderScreen(title: 'Canva Webhooks & Designs'),
        ),
      ],
    ),
  ],
);

class XfoundryApp extends StatelessWidget {
  const XfoundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Xfoundry Universal',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      routerConfig: _router,
    );
  }
}

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/housing')) return 0;
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/canva')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/housing');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/canva');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xfoundry Dashboard'),
        centerTitle: true,
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.house), label: 'Housing'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.design_services), label: 'Canva'),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.widgets, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Module Placeholder - Realtime Logic Ready'),
        ],
      ),
    );
  }
}

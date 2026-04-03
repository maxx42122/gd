import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'services/local_storage_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage (Hive) — always available offline
  await LocalStorageService.instance.init();

  // Initialize Firebase
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (_) {
    // Firebase unavailable — app still works fully offline
  }

  runApp(
    ProviderScope(
      child: HealthApp(firebaseReady: firebaseReady),
    ),
  );
}

class HealthApp extends ConsumerWidget {
  final bool firebaseReady;
  const HealthApp({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'SimpLY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: SplashScreen(firebaseReady: firebaseReady),
      routes: {
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const _HomeShell(),
        '/history': (_) => const HistoryScreen(),
        '/profile': (_) => const ProfileSetupScreen(isEdit: true),
        '/profile-setup': (_) => const ProfileSetupScreen(),
      },
    );
  }
}

/// Bottom nav shell wrapping the dashboard
class _HomeShell extends StatefulWidget {
  const _HomeShell();
  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    HistoryScreen(),
    ProfileSetupScreen(isEdit: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.kSurface,
        indicatorColor: AppTheme.kAccent.withValues(alpha: 0.15),
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon:
                Icon(Icons.dashboard_outlined, color: AppTheme.kTextSecondary),
            selectedIcon:
                Icon(Icons.dashboard_rounded, color: AppTheme.kAccent),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined, color: AppTheme.kTextSecondary),
            selectedIcon: Icon(Icons.history_rounded, color: AppTheme.kAccent),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded,
                color: AppTheme.kTextSecondary),
            selectedIcon: Icon(Icons.person_rounded, color: AppTheme.kAccent),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

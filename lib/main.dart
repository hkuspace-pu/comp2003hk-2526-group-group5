import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Core configuration
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

// Services
import 'services/notification_service.dart';

// Providers
import 'providers/user_provider.dart';
import 'providers/gamification_provider.dart';
import 'providers/focus_session_provider.dart';

// Screens
import 'screens/auth/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/gamification/focus_city_page.dart';
import 'screens/dashboard/statistics_screen.dart';
import 'screens/activity/session_complete_screen.dart';
import 'screens/activity/mood_logging_page.dart';
import 'screens/settings/settings_page.dart';
import 'screens/settings/user_profile_screen.dart';
import 'screens/settings/family_leaderboard.dart';
import 'navigation_hub.dart';
import 'screens/counselor/counselor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before starting the app
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Notification Service
    final notificationService = NotificationService();
    await notificationService.init();

    // Request permissions (Crucial for Break Reminders to trigger)
    await notificationService.requestPermissions();

  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(const ScreenTimeTrackerApp());
}

class ScreenTimeTrackerApp extends StatelessWidget {
  const ScreenTimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),

        ChangeNotifierProvider(create: (_) => GamificationProvider()),

        // ProxyProvider for dependencies
        ChangeNotifierProxyProvider<GamificationProvider, FocusSessionProvider>(
          create: (context) => FocusSessionProvider(
            Provider.of<GamificationProvider>(context, listen: false),
          ),
          update: (context, gamification, focus) =>
          focus!..updateGamification(gamification),
        ),
      ],
      child: MaterialApp(
        title: 'Focus City',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // Use AuthWrapper to decide the initial screen
        home: const AuthWrapper(),

        // Named routes for cleaner navigation
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/main': (context) => const NavigationScreen(),
          '/gamification': (context) => const FocusCityPage(),
          '/dashboard': (context) => const StatisticsScreen(),
          '/session': (context) => const SessionCompleteScreen(),
          '/mood_logging': (context) => const MoodLoggingPage(),
          '/settings': (context) => const  SettingsPage(),
          '/user_profile': (context) => const UserProfileScreen(),
          '/family_leaderboard': (context) => const FamilyLeaderboard(),
          '/counselor': (context) => const CounselorDashboard(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    // Use AnimatedSwitcher to smooth out the transition between loading and content
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _buildBody(userProvider),
    );
  }

  Widget _buildBody(UserProvider userProvider) {
    // Loading State
    if (userProvider.isLoading) {
      return const Scaffold(
        key: ValueKey('loading'),
        body: Center(
          child: CircularProgressIndicator.adaptive(), // Adaptive looks native on iOS/Android
        ),
      );
    }

    // Unauthenticated State
    if (!userProvider.isAuthenticated) {
      return const HomeScreen(key: ValueKey('home'));
    }

    // Authenticated State - Role Based
    if (userProvider.userProfile?.role == 'counselor') {
      return const CounselorDashboard(key: ValueKey('counselor'));
    } else {
      return const NavigationScreen(key: ValueKey('login'));
    }
  }
}
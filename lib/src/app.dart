import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/ai_chat/presentation/screens/chat_screen.dart';
import 'features/ai_chat/presentation/screens/persona_selection_screen.dart';
import 'features/exercises/presentation/screens/exercise_screen.dart';
import 'features/exercises/presentation/screens/saved_drills_screen.dart';
import 'features/dashboard/presentation/screens/settings_screen.dart';
import 'features/vocabulary/presentation/screens/flashcard_home_screen.dart';
import 'features/vocabulary/presentation/screens/flashcard_session_screen.dart';
import 'features/vocabulary/presentation/screens/flashcard_add_screen.dart';
import 'features/vocabulary/presentation/screens/flashcard_result_screen.dart';
import 'core/widgets/responsive_scaffold.dart';

import 'features/splash/presentation/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ResponsiveScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const PersonaSelectionScreen(),
          ),
          GoRoute(
            path: '/chat/:personaId',
            builder: (context, state) {
              final personaId = state.pathParameters['personaId'] ?? 'dev';
              return ChatScreen(personaId: personaId);
            },
          ),
          GoRoute(
            path: '/exercise',
            builder: (context, state) => const ExerciseScreen(),
          ),
          GoRoute(
            path: '/saved-drills',
            builder: (context, state) => const SavedDrillsScreen(),
          ),
          GoRoute(
            path: '/flashcards',
            builder: (context, state) => const FlashcardHomeScreen(),
          ),
          GoRoute(
            path: '/flashcards/session',
            builder: (context, state) => const FlashcardSessionScreen(),
          ),
          GoRoute(
            path: '/flashcards/add',
            builder: (context, state) => const FlashcardAddScreen(),
          ),
          GoRoute(
            path: '/flashcards/result',
            builder: (context, state) => const FlashcardResultScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

class BrseAiCoachApp extends ConsumerWidget {
  const BrseAiCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'IT英語ドリル-BrSEへの道-',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

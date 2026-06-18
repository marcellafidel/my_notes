import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/about_page.dart';
import '../pages/home_page.dart';
import '../pages/note_detail_page.dart';
import '../pages/note_edit_page.dart';
import '../pages/profile_page.dart';
import '../pages/splash_page.dart';
import 'main_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash screen
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),

    // Shell: Bottom Navigation (Catatan, Profil, Tentang)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Catatan
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [
                // Detail catatan: /home/note/:id
                GoRoute(
                  path: 'note/:id',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: NoteDetailPage(noteId: id),
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (context, animation,
                          secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          )),
                          child: child,
                        );
                      },
                    );
                  },
                ),
                // Edit catatan: /home/note/edit/:id
                GoRoute(
                  path: 'note/edit/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return NoteEditPage(noteId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Tab 2: Profil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),

        // Tab 3: Tentang — transisi fade
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/about',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const AboutPage(),
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (context, animation,
                      secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
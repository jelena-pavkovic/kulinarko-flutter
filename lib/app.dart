import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/recipe_form_screen.dart';
import 'screens/shopping_screen.dart';
import 'screens/settings_screen.dart';

const kAccent = Color(0xFF3EB075);       // primarni accent
const kAccentDark = Color(0xFF238A53);   // tamniji accent za tekst/ikonice
const kAccentLight = Color(0xFF69BF70);  // svetliji accent

const kCream = Color(0xFFFAFCFE);            // glavna pozadina
const kCardBorder = Color(0xFFE5EAF0);       // border kartica i inputa
const kInk = Color(0xFF0A0A0F);              // glavni tekst

const kSurface = Color(0xFFFFFFFF);          // kartice
const kSurfaceContainer = Color(0xFFF6F8FC); // inputi i sekundarne površine
const kMutedText = Color(0xFF6B7280);        // sekundarni tekst

const kSuccess = Color(0xFF3EB075);
const kWarning = Color(0xFFE5A93D);
const kDanger = Color(0xFFD95454);

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _Shell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/shopping',
          builder: (context, state) => const ShoppingScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/recipe/new',
      builder: (context, state) => const RecipeFormScreen(),
    ),
    GoRoute(
      path: '/recipe/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return RecipeDetailScreen(recipeId: id);
      },
    ),
    GoRoute(
      path: '/recipe/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return RecipeFormScreen(recipeId: id);
      },
    ),
  ],
);

class KulinarkoApp extends StatelessWidget {
  const KulinarkoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kulinarko',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: _router,
    );
  }

  ThemeData _buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kAccent,
    brightness: Brightness.light,
  ).copyWith(
    primary: kAccent,
    onPrimary: Color(0xFF102038),
    secondary: kAccentDark,
    onSecondary: Color(0xFF102038),
    surface: kSurface,
    onSurface: kInk,
    surfaceContainerHighest: kSurfaceContainer,
    outline: kCardBorder,
    error: kDanger,
    onError: Color(0xFF2B1014),
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: kCream,
    canvasColor: kCream,
    visualDensity: VisualDensity.standard,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: kCream,
      foregroundColor: kInk,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: kInk,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: kSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kCardBorder, width: 0.8),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: kSurfaceContainer,
      selectedColor: kAccent.withValues(alpha: 0.22),
      labelStyle: const TextStyle(color: kInk, fontSize: 13),
      secondaryLabelStyle: const TextStyle(color: kAccentDark),
      side: const BorderSide(color: kCardBorder, width: 0.8),
      shape: const StadiumBorder(),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: kSurface,
      indicatorColor: kAccent.withValues(alpha: 0.18),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? kAccent
              : kMutedText,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected)
              ? kAccent
              : kMutedText,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurfaceContainer,
      hintStyle: const TextStyle(color: kMutedText),
      prefixIconColor: kAccentDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kCardBorder, width: 0.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kCardBorder, width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kAccent, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccent,
        foregroundColor: const Color(0xFF102038),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kAccentDark),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kAccent,
      foregroundColor: Color(0xFF102038),
    ),
    dividerTheme: const DividerThemeData(
      color: kCardBorder,
      thickness: 0.8,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: kAccent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: kSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kSurfaceContainer,
      contentTextStyle: const TextStyle(color: kInk),
      actionTextColor: kAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
}

class _Shell extends StatelessWidget {
  final Widget child;

  const _Shell({required this.child});

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/shopping')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/shopping');
              break;
            case 2:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Recepti',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Kupovina',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Postavke',
          ),
        ],
      ),
    );
  }
}

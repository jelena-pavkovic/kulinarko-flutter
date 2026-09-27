import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/recipe_form_screen.dart';
import 'screens/shopping_screen.dart';
import 'screens/settings_screen.dart';

/*const kTerracotta = Color(0xFFD85A30); // glavna akcentna
const kTerracottaDark = Color(0xFF993C1D);
const kTerracottaLight = Color(0xFFF0997B); // svetlija, za placeholdere
const kCream = Color(0xFFFAF3E9); // pozadina svih ekrana
const kCardBorder = Color(0xFFF5C4B3); // topli okvir kartica i polja
const kInk = Color(0xFF4A1B0C); // glavni tekst*/

// Kulinarko dark palette — namerno nije potpuno crna.
const kTerracotta = Color(0xFF82B1FF);      // glavni plavi akcenat
const kTerracottaDark = Color(0xFFA9C7FF); // tekst i ikone uz akcenat
const kTerracottaLight = Color(0xFFB8D2FF); // pomoćni akcenat
const kCream = Color(0xFF141A22);          // pozadina aplikacije
const kCardBorder = Color(0xFF34445A);     // diskretan okvir
const kInk = Color(0xFFE7EEF7);             // glavni tekst

const kSurface = Color(0xFF202A38);        // kartice
const kSurfaceContainer = Color(0xFF263346); // polja i povišene površine
const kMutedText = Color(0xFF9CAAC0);      // sekundarni tekst
const kSuccess = Color(0xFF78C6A3);
const kWarning = Color(0xFFE7B86A);
const kDanger = Color(0xFFF08A8A);

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

  /*ThemeData _buildTheme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: kCream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kTerracotta,
        primary: kTerracotta,
        surface: kCream,
        onSurface: kInk,
      ),
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
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kCardBorder, width: 0.8),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: kTerracotta,
        labelStyle: const TextStyle(color: kTerracottaDark, fontSize: 13),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: const StadiumBorder(
          side: BorderSide(color: kCardBorder, width: 0.8),
        ),
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: kTerracotta.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? kTerracottaDark
                : Colors.grey.shade500,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            color: states.contains(WidgetState.selected)
                ? kTerracottaDark
                : Colors.grey.shade500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.grey.shade400),
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
          borderSide: const BorderSide(color: kTerracotta, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kTerracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: kTerracottaDark),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kTerracotta,
        foregroundColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(color: kCardBorder, thickness: 0.8),
    );
  }*/

  ThemeData _buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kTerracotta,
    brightness: Brightness.dark,
  ).copyWith(
    primary: kTerracotta,
    onPrimary: Color(0xFF102038),
    secondary: kTerracottaDark,
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
    brightness: Brightness.dark,
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
      selectedColor: kTerracotta.withValues(alpha: 0.22),
      labelStyle: const TextStyle(color: kInk, fontSize: 13),
      secondaryLabelStyle: const TextStyle(color: kTerracottaDark),
      side: const BorderSide(color: kCardBorder, width: 0.8),
      shape: const StadiumBorder(),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: kSurface,
      indicatorColor: kTerracotta.withValues(alpha: 0.18),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? kTerracotta
              : kMutedText,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected)
              ? kTerracotta
              : kMutedText,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurfaceContainer,
      hintStyle: const TextStyle(color: kMutedText),
      prefixIconColor: kTerracottaDark,
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
        borderSide: const BorderSide(color: kTerracotta, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kTerracotta,
        foregroundColor: const Color(0xFF102038),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kTerracottaDark),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kTerracotta,
      foregroundColor: Color(0xFF102038),
    ),
    dividerTheme: const DividerThemeData(
      color: kCardBorder,
      thickness: 0.8,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: kTerracotta,
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
      actionTextColor: kTerracotta,
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

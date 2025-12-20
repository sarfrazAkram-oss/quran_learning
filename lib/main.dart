import 'package:flutter/material.dart';

import 'app_settings.dart';
import 'data/para_data.dart';
import 'screens/bismillah_splash_screen.dart';
import 'screens/holy_quran_para_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/para_detail_screen.dart';
import 'screens/tajweed_surah_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppSettings _settings = AppSettings();

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      notifier: _settings,
      child: AnimatedBuilder(
        animation: _settings,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quran App',
            themeMode: _settings.themeMode,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            home: const BismillahSplashScreen(),
            routes: {
              '/home': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                final language = args is String ? args : '';
                return HomeScreen(selectedLanguage: language);
              },
              '/tajweed': (context) => const TajweedSurahListScreen(),
              '/holy-quran': (context) => const HolyQuranParaListScreen(),
            },
            onGenerateRoute: (settings) {
              final name = settings.name;
              if (name != null && name.startsWith('/para/')) {
                final parts = name.split('/');
                if (parts.length >= 3) {
                  final number = int.tryParse(parts[2]);
                  if (number != null) {
                    final para = paras.firstWhere(
                      (p) => p.number == number,
                      orElse: () => paras.first,
                    );
                    return MaterialPageRoute(
                      builder: (context) => ParaDetailScreen(para: para),
                      settings: settings,
                    );
                  }
                }
              }
              return null;
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF11C86A),
      brightness: Brightness.light,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues(alpha: 0.35)
              : colorScheme.surfaceContainerHighest,
        ),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF11C86A),
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF181A1B),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF181A1B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues(alpha: 0.35)
              : colorScheme.surfaceContainerHighest,
        ),
      ),
      useMaterial3: true,
    );
  }
}

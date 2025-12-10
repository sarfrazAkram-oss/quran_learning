import 'package:flutter/material.dart';
import 'screens/language_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tajweed_surah_list_screen.dart';
import 'screens/holy_quran_para_list_screen.dart';
import 'screens/para_detail_screen.dart';
import 'data/para_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove DEBUG banner
      title: 'Quran App',
      home: LanguageSelectionScreen(), // show language screen first
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
  }
}

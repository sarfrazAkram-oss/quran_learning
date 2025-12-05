import 'package:flutter/material.dart';
import 'screens/language_selection_screen.dart';

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
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String selectedLanguage;

  const HomeScreen({required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    String welcomeMessage = selectedLanguage == 'العربية'
        ? 'مرحبًا بك في الصفحة الرئيسية!'
        : selectedLanguage == 'اردو'
        ? 'ہوم پیج میں خوش آمدید!'
        : 'Welcome to the Home Page!';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedLanguage == 'العربية'
              ? 'الصفحة الرئيسية'
              : selectedLanguage == 'اردو'
              ? 'ہوم پیج'
              : 'Home Page',
        ),
      ),
      body: Center(child: Text(welcomeMessage, style: TextStyle(fontSize: 24))),
    );
  }
}

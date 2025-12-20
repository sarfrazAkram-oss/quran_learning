import 'dart:async';

import 'package:flutter/material.dart';

import 'language_selection_screen.dart';

class BismillahSplashScreen extends StatefulWidget {
  const BismillahSplashScreen({super.key});

  @override
  State<BismillahSplashScreen> createState() => _BismillahSplashScreenState();
}

class _BismillahSplashScreenState extends State<BismillahSplashScreen> {
  static const String _fullText = 'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
  static const Duration _characterDelay = Duration(milliseconds: 120);

  String _visibleText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  Future<void> _startAnimation() async {
    final List<int> scalars = _fullText.runes.toList();
    for (int i = 0; i < scalars.length; i++) {
      if (!mounted) {
        return;
      }
      setState(() {
        _visibleText = String.fromCharCodes(scalars.sublist(0, i + 1));
      });
      await Future.delayed(_characterDelay);
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF0D8A3B);
    final TextStyle baseStyle =
        Theme.of(context).textTheme.displayMedium ??
        const TextStyle(fontSize: 40);
    final TextStyle textStyle = baseStyle.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      body: Container(
        color: backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            _visibleText,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

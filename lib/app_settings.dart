import 'package:flutter/material.dart';

enum HomeLanguage { english, urdu }

extension HomeLanguageDisplay on HomeLanguage {
  String get label {
    switch (this) {
      case HomeLanguage.english:
        return 'English';
      case HomeLanguage.urdu:
        return 'Urdu';
    }
  }
}

class AppSettings extends ChangeNotifier {
  bool _vibrateOnSwipe = false;
  HomeLanguage _homeLanguage = HomeLanguage.english;
  ThemeMode _themeMode = ThemeMode.system;

  bool get vibrateOnSwipe => _vibrateOnSwipe;
  HomeLanguage get homeLanguage => _homeLanguage;
  ThemeMode get themeMode => _themeMode;

  void updateVibrate(bool value) {
    if (_vibrateOnSwipe == value) {
      return;
    }
    _vibrateOnSwipe = value;
    notifyListeners();
  }

  void updateHomeLanguage(HomeLanguage value) {
    if (_homeLanguage == value) {
      return;
    }
    _homeLanguage = value;
    notifyListeners();
  }

  void updateThemeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _themeMode = value;
    notifyListeners();
  }
}

class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static AppSettings of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'No AppSettingsScope found in context');
    return scope!.notifier!;
  }
}

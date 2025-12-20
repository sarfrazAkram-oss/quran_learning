import 'package:flutter/material.dart';

import '../app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final AppSettings settings = AppSettingsScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _SettingsCard(
            children: [
              _SettingsRow(
                icon: Icons.vibration,
                title: 'Vibrate',
                subtitle: 'On Page Swipe',
                trailing: Switch.adaptive(
                  value: settings.vibrateOnSwipe,
                  onChanged: settings.updateVibrate,
                ),
                onTap: () => settings.updateVibrate(!settings.vibrateOnSwipe),
              ),
              const Divider(height: 1),
              _SettingsRow(
                icon: Icons.language,
                title: 'Language',
                subtitle: settings.homeLanguage.label,
                trailing: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _showLanguageDialog(settings),
                ),
                onTap: () => _showLanguageDialog(settings),
              ),
              const Divider(height: 1),
              _SettingsRow(
                icon: Icons.dark_mode,
                title: 'App Theme',
                subtitle: _themeLabel(settings.themeMode),
                trailing: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _showThemeDialog(settings),
                ),
                onTap: () => _showThemeDialog(settings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguageDialog(AppSettings settings) async {
    final HomeLanguage? selection = await showDialog<HomeLanguage>(
      context: context,
      builder: (dialogContext) {
        HomeLanguage current = settings.homeLanguage;
        return AlertDialog(
          title: const Text('Select Language'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: HomeLanguage.values.map((option) {
                  return RadioListTile<HomeLanguage>(
                    value: option,
                    groupValue: current,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => current = value);
                    },
                    title: Text(option.label),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(current),
              child: const Text('APPLY'),
            ),
          ],
        );
      },
    );

    if (selection != null) {
      settings.updateHomeLanguage(selection);
    }
  }

  Future<void> _showThemeDialog(AppSettings settings) async {
    final ThemeMode? selection = await showDialog<ThemeMode>(
      context: context,
      builder: (dialogContext) {
        ThemeMode current = settings.themeMode;
        const List<ThemeMode> options = [
          ThemeMode.light,
          ThemeMode.dark,
          ThemeMode.system,
        ];
        return AlertDialog(
          title: const Text('Select Theme'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((option) {
                  return RadioListTile<ThemeMode>(
                    value: option,
                    groupValue: current,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => current = value);
                    },
                    title: Text(_themeLabel(option)),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(current),
              child: const Text('APPLY'),
            ),
          ],
        );
      },
    );

    if (selection != null) {
      settings.updateThemeMode(selection);
    }
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final Color background = Theme.of(context).cardColor;
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color? subtitleColor = textTheme.bodyMedium?.color;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: subtitleColor?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

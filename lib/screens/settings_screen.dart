import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext c) {
    final tp = Provider.of<ThemeProvider>(c);
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('theme'.tr(), style: const TextStyle(fontSize: 18)),
            DropdownButton<AppTheme>(
              value: tp.currentTheme,
              items: [
                DropdownMenuItem(value: AppTheme.light,  child: Text('light'.tr())),
                DropdownMenuItem(value: AppTheme.dark,   child: Text('dark'.tr())),
                DropdownMenuItem(value: AppTheme.custom, child: Text('custom'.tr())),
              ],
              onChanged: (v) {
                if (v != null) tp.setTheme(v);
              },
            ),

            const SizedBox(height: 20),
            Text('language'.tr(), style: const TextStyle(fontSize: 18)),
            DropdownButton<Locale>(
              value: c.locale,
              onChanged: (Locale? locale) {
                if (locale != null) {
                  c.setLocale(locale);
                }
              },
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('ru'), child: Text('Русский')),
                DropdownMenuItem(value: Locale('kk'), child: Text('Қазақша')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

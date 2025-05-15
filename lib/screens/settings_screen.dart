import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext c) {
    final tp = Provider.of<ThemeProvider>(c);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Theme', style: TextStyle(fontSize:18)),
            DropdownButton<AppTheme>(
              value: tp.currentTheme,
              items: const [
                DropdownMenuItem(value:AppTheme.light,  child: Text('Light')),
                DropdownMenuItem(value:AppTheme.dark,   child: Text('Dark')),
                DropdownMenuItem(value:AppTheme.custom, child: Text('Custom')),
              ],
              onChanged: (v){ if (v!=null) tp.setTheme(v); },
            ),
          ],
        ),
      ),
    );
  }
}
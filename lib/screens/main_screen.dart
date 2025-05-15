import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int idx = 0;
  final tabs = const [
    HomeScreen(), MapScreen(), SettingsScreen(), ProfileScreen(),
  ];

  @override Widget build(BuildContext c) {
    return Scaffold(
      body: tabs[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i)=>setState(()=>idx=i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon:Icon(Icons.home), label:'Home'),
          BottomNavigationBarItem(icon:Icon(Icons.map), label:'Map'),
          BottomNavigationBarItem(icon:Icon(Icons.settings), label:'Settings'),
          BottomNavigationBarItem(icon:Icon(Icons.person), label:'Profile'),
        ],
      ),
    );
  }
}
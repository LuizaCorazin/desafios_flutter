import 'package:flutter/material.dart';
import 'screens/splash.dart';

void main() {
  runApp(const CaminhadasApp());
}

class CaminhadasApp extends StatefulWidget {
  const CaminhadasApp({super.key});

  @override
  State<CaminhadasApp> createState() => _CaminhadasAppState();
}

class _CaminhadasAppState extends State<CaminhadasApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caminhadas x Calorias',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.teal),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
    );
  }
}

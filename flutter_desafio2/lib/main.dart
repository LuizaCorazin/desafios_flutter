import 'package:flutter/material.dart';
import 'screens/splash.dart';

void main() {
  runApp(const AguaApp());
}

class AguaApp extends StatefulWidget {
  const AguaApp({super.key});

  @override
  State<AguaApp> createState() => _AguaAppState();
}

class _AguaAppState extends State<AguaApp> {
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
      title: 'Consumo de Água',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.blueGrey),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
    );
  }
}

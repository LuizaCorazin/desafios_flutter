import 'package:flutter/material.dart';
import 'screens/splash.dart';

void main() {
  runApp(const AbastecimentoApp());
}

class AbastecimentoApp extends StatefulWidget {
  const AbastecimentoApp({super.key});

  @override
  State<AbastecimentoApp> createState() => _AbastecimentoAppState();
}

class _AbastecimentoAppState extends State<AbastecimentoApp> {
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
      title: 'Abastecimento de Veículos',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.orange,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.orange),
      ),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.deepOrange),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
    );
  }
}

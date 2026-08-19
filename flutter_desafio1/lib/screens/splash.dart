import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem central
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                '/acad.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            // Alternador de tema
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Tema escuro"),
                Switch(value: isDarkMode, onChanged: onThemeChanged),
              ],
            ),
            const SizedBox(height: 20),
            // Botão Entrar
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}

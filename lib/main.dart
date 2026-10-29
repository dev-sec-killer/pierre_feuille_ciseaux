import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pierre-Feuille-Ciseaux',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pierre-Feuille-Ciseaux'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Fais ton choix !',
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceButton(
                  emoji: '✊',
                  name: 'Pierre',
                  onPressed: () => debugPrint('Pierre'),
                ),
                ChoiceButton(
                  emoji: '✋',
                  name: 'Feuille',
                  onPressed: () => debugPrint('Feuille'),
                ),
                ChoiceButton(
                  emoji: '✌️',
                  name: 'Ciseaux',
                  onPressed: () => debugPrint('Ciseaux'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
    required this.emoji,
    required this.name,
    required this.onPressed,
  });

  final String emoji;
  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 4),
            Text(name),
          ],
        ),
      ),
    );
  }
}

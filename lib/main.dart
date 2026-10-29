import 'package:flutter/material.dart';
import 'dart:math';

const Map<String, String> emojis = {
  'Pierre': '✊',
  'Feuille': '✋',
  'Ciseaux': '✌️',
};

const Map<String, String> beats = {
  'Pierre': 'Ciseaux', // la pierre casse les ciseaux
  'Feuille': 'Pierre', // la feuille enveloppe la pierre
  'Ciseaux': 'Feuille', // les ciseaux coupent la feuille
};
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

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? playerChoice;
  String? computerChoice;
  String result = '';

  final Random random = Random();

  void play(String choice) {
    final choices = emojis.keys.toList();
    final computerPick = choices[random.nextInt(choices.length)];
    setState(() {
      playerChoice = choice;
      computerChoice = computerPick;

      if (choice == computerPick) {
        result = 'Égalité !';
      } else if (beats[choice] == computerPick) {
        result = 'Tu as gagné ! 🎉';
      } else {
        result = 'Perdu… 😢';
      }
    });
  }

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
                for (final name in emojis.keys)
                  ChoiceButton(
                    emoji: emojis[name]!,
                    name: name,
                    onPressed: () => play(name),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            if (playerChoice != null && computerChoice != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildChoice('Toi', playerChoice!),
                  const Text('VS', style: TextStyle(fontSize: 24)),
                  buildChoice('Ordi', computerChoice!),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                result,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildChoice(String title, String choice) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        Text(emojis[choice]!, style: const TextStyle(fontSize: 64)),
      ],
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

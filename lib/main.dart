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

// Les couleurs de l'arène.
const Color arenaDark = Color(0xFF2C2C2A);
const Color computerColor = Color(0xFFA32D2D);
const Color playerColor = Color(0xFF185FA5);

// Le premier à 5 points gagne le combat.
const int winningScore = 5;

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
  Color resultColor = Colors.white;
  int playerScore = 0;
  int computerScore = 0;
  int round = 0; // numéro du coup, utile pour les animations

  final Random random = Random();
  // Un "getter" : une valeur recalculée à chaque fois qu'on la lit.
  bool get gameOver =>
      playerScore >= winningScore || computerScore >= winningScore;

  void play(String choice) {
    if (gameOver) return; // le combat est fini : on ne fait rien

    final options = emojis.keys.toList();
    final computerPick = options[random.nextInt(options.length)];

    setState(() {
      round++;
      playerChoice = choice;
      computerChoice = computerPick;

      if (choice == computerPick) {
        result = 'Égalité !';
        resultColor = Colors.white70;
      } else if (beats[choice] == computerPick) {
        result = 'Coup gagnant ! 💥';
        resultColor = Colors.lightGreenAccent;
        playerScore++;
      } else {
        result = 'Aïe, touché… 😵';
        resultColor = Colors.orangeAccent;
        computerScore++;
      }

      // Fin du combat.
      if (playerScore >= winningScore) {
        result = 'Victoire ! 🏆';
        resultColor = Colors.amberAccent;
      } else if (computerScore >= winningScore) {
        result = 'K.O.… 💀';
        resultColor = Colors.orangeAccent;
      }
    });
  }

  void reset() {
    setState(() {
      playerChoice = null;
      computerChoice = null;
      result = '';
      playerScore = 0;
      computerScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arenaDark,
      body: SafeArea(
        // Stack superpose ses enfants : l'arène, puis le badge VS par-dessus.
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(flex: 2, child: buildComputerZone()),
                Expanded(flex: 3, child: buildPlayerZone()),
              ],
            ),
            // La frontière entre les zones est à 2/5 de la hauteur,
            // soit y = -0.2 (de -1 en haut à 1 en bas).
            const Align(
              alignment: Alignment(0, -0.2),
              child: VsBadge(),
            ),
          ],
        ),
      ),
    );
  }

  // Le camp de l'ordinateur, en haut.
  Widget buildComputerZone() {
    return Container(
      width: double.infinity,
      color: computerColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HealthBar(
            label: 'Ordi',
            health: (winningScore - playerScore) / winningScore,
            color: const Color(0xFFF09595),
            backgroundColor: const Color(0xFF501313),
          ),
          const SizedBox(height: 16),
          buildFighter(computerChoice, waiting: '🤖', upsideDown: true),
        ],
      ),
    );
  }

  // Notre camp, en bas.
  Widget buildPlayerZone() {
    return Container(
      width: double.infinity,
      color: playerColor,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildFighter(playerChoice, waiting: '🙂'),
          const SizedBox(height: 8),
          Text(
            result.isEmpty ? 'Choisis ton coup !' : result,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: result.isEmpty ? Colors.white : resultColor,
            ),
          ),
          const SizedBox(height: 12),
          HealthBar(
            label: 'Toi',
            health: (winningScore - computerScore) / winningScore,
            color: const Color(0xFF85B7EB),
            backgroundColor: const Color(0xFF042C53),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final name in emojis.keys)
                ChoiceButton(
                  emoji: emojis[name]!,
                  name: name,
                  // null = bouton désactivé quand le combat est fini.
                  onPressed: gameOver ? null : () => play(name),
                ),
            ],
          ),
          TextButton.icon(
            onPressed: reset,
            icon: const Icon(Icons.refresh),
            label: Text(gameOver ? 'Nouveau combat' : 'Recommencer'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  // Le "combattant" : l'emoji du coup joué, ou un visage en attente.
  Widget buildFighter(
    String? choice, {
    required String waiting,
    bool upsideDown = false,
  }) {
    Widget fighter = Text(
      choice == null ? waiting : emojis[choice]!,
      style: const TextStyle(fontSize: 64),
    );

    // La main de l'ordi est retournée : elle pointe vers nous.
    if (choice != null && upsideDown) {
      fighter = Transform.rotate(angle: pi, child: fighter);
    }

    // AnimatedSwitcher anime le passage d'un enfant à un autre.
    // La "key" change à chaque coup, donc l'animation se rejoue toujours.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: SizedBox(key: ValueKey(round), child: fighter),
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
  final VoidCallback? onPressed; // "?" : peut être null (bouton désactivé)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C447C),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white12,
          side: const BorderSide(color: Color(0xFF85B7EB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          elevation: 6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// Barre de vie : un nom, des points de vie (PV) et une jauge.
class HealthBar extends StatelessWidget {
  const HealthBar({
    super.key,
    required this.label,
    required this.health,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final double health; // entre 0 (K.O.) et 1 (pleine forme)
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(health * 100).round()} PV',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            // TweenAnimationBuilder fait glisser la jauge en douceur.
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1, end: health),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                minHeight: 12,
                color: color,
                backgroundColor: backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Le badge « VS » au centre de l'arène.
class VsBadge extends StatelessWidget {
  const VsBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFAC775),
        shape: BoxShape.circle,
        border: Border.all(color: arenaDark, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 8),
        ],
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color(0xFF412402),
        ),
      ),
    );
  }
}

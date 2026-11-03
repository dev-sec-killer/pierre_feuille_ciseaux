# 🥊 Étape 6 — Transformer l'app en jeu : le design « Arène de combat »

**Suite du guide Pierre-Feuille-Ciseaux — Webinaire « Flutter pour débutants »**

Ton jeu fonctionne. Maintenant, on va lui donner l'allure d'un vrai jeu de combat :

- l'écran est coupé en **deux camps** : l'ordi en haut (rouge), toi en bas (bleu) ;
- un **badge VS** trône au milieu de l'arène ;
- le score devient des **barres de vie** : le premier à tomber à 0 PV est K.O. ;
- les coups apparaissent avec une **animation**.

```
┌──────────────────────────┐
│ Ordi ▓▓▓▓▓▓░░░░  60 PV   │  ← camp de l'ordi (rouge)
│            ✌️ (retourné)  │
├───────────( VS )─────────┤
│            ✊             │  ← ton camp (bleu)
│      Coup gagnant ! 💥    │
│ Toi  ▓▓▓▓▓▓▓▓░░  80 PV   │
│   [ ✊ ]  [ ✋ ]  [ ✌️ ]    │
│       ⟳ Recommencer      │
└──────────────────────────┘
```

> ✅ **On ne casse rien** : on part du code de l'étape 5 et la logique du jeu (choix, hasard, règles) reste la même. On change l'apparence, et on ajoute juste une fin de combat.
>
> 🛟 Après chaque sous-étape, l'app doit se lancer sans erreur. Si tu bloques, le code final complet est sur la branche `step6` (`git checkout step6`).

| Sous-étape | Ce qu'on fait | Nouveaux concepts |
|---|---|---|
| 6.1 | Les couleurs de l'arène | constantes `Color` |
| 6.2 | La fin du combat | *getter*, `return` anticipé |
| 6.3 | La barre de vie | `LinearProgressIndicator`, `ClipRRect`, `Spacer` |
| 6.4 | Le badge VS | `Container`, `BoxDecoration`, `BoxShadow` |
| 6.5 | Des boutons de combat | `ElevatedButton.styleFrom`, bouton désactivé |
| 6.6 | Construire l'arène | `Stack`, `Align`, `Expanded(flex)`, `Transform` |
| 6.7 | Les animations | `AnimatedSwitcher`, `TweenAnimationBuilder` |

---

## 6.1 — Les couleurs de l'arène

Juste sous la `Map` `beats`, ajoute :

```dart
// Les couleurs de l'arène.
const Color arenaDark = Color(0xFF2C2C2A);
const Color computerColor = Color(0xFFA32D2D);
const Color playerColor = Color(0xFF185FA5);

// Le premier à 5 points gagne le combat.
const int winningScore = 5;
```

**Ce qu'il faut comprendre**

- `Color(0xFF185FA5)` : une couleur écrite en hexadécimal. `FF` = opacité totale, puis rouge, vert, bleu (`18`, `5F`, `A5`).
- Ranger les couleurs dans des constantes, c'est pouvoir **changer tout le thème en modifiant 3 lignes**.

---

## 6.2 — La fin du combat

**1)** Dans `_GameScreenState`, remplace `Color resultColor = Colors.grey;` par `Colors.white`, et ajoute une variable `round` sous `computerScore` :

```dart
  Color resultColor = Colors.white;
  int playerScore = 0;
  int computerScore = 0;
  int round = 0; // numéro du coup, utile pour les animations
```

**2)** Juste sous `final Random random = Random();`, ajoute :

```dart
  // Un "getter" : une valeur recalculée à chaque fois qu'on la lit.
  bool get gameOver =>
      playerScore >= winningScore || computerScore >= winningScore;
```

**3)** Remplace toute la méthode `play` par :

```dart
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
```

**Ce qu'il faut comprendre**

- **`bool get gameOver => ...`** : un *getter*. On l'utilise comme une variable (`if (gameOver)`), mais sa valeur est **calculée** à partir des scores. Pas de risque d'oublier de la mettre à jour !
- **`if (gameOver) return;`** : on quitte la méthode tout de suite.
- Les couleurs passent en version claire (`lightGreenAccent`, `orangeAccent`) : elles seront lisibles sur le fond bleu de l'arène.

---

## 6.3 — La barre de vie

Tout en bas du fichier, ajoute ce nouveau widget :

```dart
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
            child: LinearProgressIndicator(
              value: health,
              minHeight: 12,
              color: color,
              backgroundColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Ce qu'il faut comprendre**

- **`LinearProgressIndicator`** est d'habitude une barre de chargement. Avec `value` entre 0 et 1, elle devient une jauge : parfaite pour une barre de vie !
- **`ClipRRect`** découpe son enfant avec des coins arrondis.
- **`Spacer`** prend toute la place libre dans une `Row` : il pousse les PV à droite.
- **`double`** : un nombre à virgule (0.6 = 60 %). `.round()` l'arrondit pour l'affichage.

---

## 6.4 — Le badge VS

Toujours en bas du fichier, ajoute :

```dart
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
```

**Ce qu'il faut comprendre**

- **`Container` + `BoxDecoration`** : le couteau suisse du design en Flutter. Couleur, forme (`BoxShape.circle`), bordure, ombre (`BoxShadow`)… tout se règle ici.
- `FontWeight.w900` : l'épaisseur maximale de la police, pour un « VS » bien percutant.

---

## 6.5 — Des boutons de combat

Remplace toute la classe `ChoiceButton` par :

```dart
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
```

**Ce qu'il faut comprendre**

- **`ElevatedButton.styleFrom`** règle tout le style d'un bouton : fond, texte, bordure (`side`), forme (`shape`), ombre (`elevation`).
- **`VoidCallback?`** : en Flutter, un bouton dont `onPressed` vaut `null` est **automatiquement désactivé** (grisé). On s'en servira à la fin du combat.

---

## 6.6 — Construire l'arène

C'est le gros morceau : on remplace l'écran par l'arène.

**1)** Dans `_GameScreenState`, **supprime** la méthode `buildChoice` (on ne s'en sert plus).

**2)** Remplace toute la méthode `build` de `_GameScreenState` par ces quatre méthodes :

```dart
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

    return fighter;
  }
```

⚠️ Fais un **hot restart** (`R`) : la structure de l'écran a beaucoup changé.

**Ce qu'il faut comprendre**

- **`Expanded(flex: ...)`** partage l'espace : `flex: 2` et `flex: 3` donnent 2/5 de l'écran à l'ordi et 3/5 à toi.
- **`Stack`** empile ses enfants **les uns sur les autres** (comme des calques). Le badge VS est posé par-dessus l'arène.
- **`Align`** place un enfant dans son parent : `Alignment(0, -0.2)` = centré horizontalement, un peu au-dessus du milieu, pile sur la frontière entre les camps.
- **La santé** se calcule à partir des scores : quand tu marques un point, l'ordi perd 20 PV (`(5 - playerScore) / 5`).
- **`Transform.rotate(angle: pi)`** fait pivoter un widget d'un demi-tour (`pi` radians = 180°). `pi` vient de `dart:math`, déjà importé.
- **Paramètres nommés `{ }`** : `buildFighter(computerChoice, waiting: '🤖', upsideDown: true)` se lit presque comme une phrase. `upsideDown = false` donne une valeur par défaut.
- **`SafeArea`** évite que le jeu passe sous l'encoche ou la barre d'état du téléphone.

🧪 **Joue un combat complet** : à 0 PV, les boutons se grisent et « Nouveau combat » relance la partie.

---

## 6.7 — Les animations

Deux petites retouches pour donner du punch.

**1) Les coups apparaissent en grossissant.** Dans `buildFighter`, remplace la dernière ligne `return fighter;` par :

```dart
    // AnimatedSwitcher anime le passage d'un enfant à un autre.
    // La "key" change à chaque coup, donc l'animation se rejoue toujours.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: SizedBox(key: ValueKey(round), child: fighter),
    );
```

**2) Les barres de vie descendent en douceur.** Dans `HealthBar`, remplace le `child: LinearProgressIndicator(...)` du `ClipRRect` par :

```dart
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
```

**Ce qu'il faut comprendre**

- **`AnimatedSwitcher`** : quand son enfant change, il anime la sortie de l'ancien et l'entrée du nouveau. Il reconnaît un « nouvel » enfant grâce à sa **`key`**. Comme `round` augmente à chaque coup, l'animation se rejoue même si tu joues deux fois Pierre de suite.
- **`TweenAnimationBuilder`** : quand `end` change (ex. de 0.8 à 0.6), il calcule toutes les valeurs intermédiaires et redessine la jauge à chaque image. Résultat : la barre « fond » au lieu de sauter.
- Ce sont des **animations implicites** : on décrit le résultat voulu, Flutter s'occupe du mouvement.

🎉 **Ton jeu ressemble maintenant à un vrai jeu de combat !**

---

## 🧩 Pour aller plus loin (design)

1. **Change de camp** : essaie d'autres couleurs dans les constantes de l'étape 6.1 (vert contre violet, par exemple).
2. **Barre de vie qui change de couleur** : verte au-dessus de 60 PV, orange au-dessus de 30, rouge en dessous. Indice : un `if` dans `HealthBar` pour choisir `color`.
3. **Secousse quand on est touché** : utilise un `TweenAnimationBuilder` avec `Transform.translate` pour faire trembler ton camp.
4. **Écran de fin** : à la fin du combat, affiche un grand panneau « Victoire » ou « K.O. » par-dessus l'arène (indice : un 3e enfant dans le `Stack`).
5. **Police de jeu** : ajoute le package [`google_fonts`](https://pub.dev/packages/google_fonts) et essaie une police comme *Press Start 2P* pour un style rétro.
6. **Sons** : joue un bruitage à chaque coup avec le package [`audioplayers`](https://pub.dev/packages/audioplayers).

---

## 🛠️ Si quelque chose ne va pas

| Problème | Solution |
|---|---|
| Bandes jaunes et noires en bas de l'écran (*overflow*) | La fenêtre est trop petite : agrandis-la, ou réduis `fontSize: 64` dans `buildFighter`. |
| Le badge VS n'est pas pile sur la frontière | Vérifie les `flex` (2 et 3) et l'`Alignment(0, -0.2)`. Si tu changes les `flex`, recalcule : y = −1 + 2 × (flex du haut ÷ total). |
| `The method 'buildChoice' isn't defined` | Tu as supprimé `buildChoice` mais l'ancien `build` l'appelle encore : remplace bien **toute** la méthode `build` (6.6). |
| L'animation ne se rejoue pas | Vérifie que `round++` est bien dans le `setState` de `play`, et la `key: ValueKey(round)`. |

📁 **Code final complet** : branche `step6` (`git checkout step6`).

# ✊✋✌️ Pierre-Feuille-Ciseaux avec Flutter

**Guide pas à pas — Webinaire « Flutter pour débutants : créez votre première app multiplateforme »**

Ce guide te permet de refaire chez toi, à ton rythme, l'application présentée pendant le webinaire. À la fin, tu auras une vraie app Flutter qui tourne sur le web, Android et iOS avec **un seul code**.

| Étape | Ce qu'on construit | Concepts Flutter / Dart |
|---|---|---|
| 1 | Un écran avec un titre | `main()`, `MaterialApp`, `Scaffold`, `Text` |
| 2 | Les trois boutons | `Column`, `Row`, `ElevatedButton`, créer son widget |
| 3 | L'ordinateur joue au hasard | `StatefulWidget`, `setState`, `Random`, `Map` |
| 4 | Qui a gagné ? | `if / else`, règles du jeu dans une `Map` |
| 5 | Score, « Recommencer », style | compteurs, `Card`, couleurs, remise à zéro |

> 📁 Le code complet de chaque étape se trouve sur la branche `stepN` de ce dépôt (ex. `git checkout step3`). Si tu bloques, récupère simplement la branche de l'étape et repars de là.

---

## 0. Avant de commencer

### Option A — Sans rien installer (recommandé pour découvrir)

1. Ouvre **[dartpad.dev](https://dartpad.dev)** dans ton navigateur.
2. Efface le code présent à gauche.
3. Colle le code de l'étape, puis clique sur **Run**. L'app s'affiche à droite.

### Option B — Sur ton ordinateur

1. Installe Flutter en suivant le guide officiel : [docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install).
2. Vérifie ton installation :
   ```bash
   flutter doctor
   ```
3. Crée le projet :
   ```bash
   flutter create pierre_feuille_ciseaux
   cd pierre_feuille_ciseaux
   ```
4. Tout notre code ira dans un seul fichier : **`lib/main.dart`**. Ouvre-le et efface son contenu.
5. Lance l'app :
   ```bash
   flutter run -d chrome     # dans le navigateur
   flutter devices           # liste les appareils disponibles
   flutter run               # sur l'émulateur ou le téléphone branché
   ```

> 💡 **Hot reload** : quand l'app tourne, modifie le code, enregistre (ou appuie sur `r` dans le terminal) et l'écran se met à jour en une seconde, sans redémarrer l'app.

---

## Étape 1 — Un écran avec un titre

**Objectif** : afficher un écran avec une barre de titre et un texte au centre.

Colle ce code dans `lib/main.dart` :

```dart
import 'package:flutter/material.dart';

void main() {
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
      body: const Center(
        child: Text(
          'Fais ton choix !',
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}
```

**Ce qu'il faut comprendre**

- **`main()`** est le point de départ du programme. `runApp()` lance l'application.
- **En Flutter, tout est widget** : l'app, l'écran, le texte, les marges… On les emboîte comme des poupées russes.
- **`MaterialApp`** configure l'application : titre, thème de couleurs, premier écran (`home`).
- **`Scaffold`** donne la structure d'un écran : une barre en haut (`appBar`) et un contenu (`body`).
- **`StatelessWidget`** : un widget qui ne change pas tout seul. Sa méthode `build()` décrit ce qu'il affiche.

🧪 **Essaie** : change `Colors.deepPurple` en `Colors.orange` et regarde le hot reload faire son effet.

---

## Étape 2 — Les trois boutons

**Objectif** : afficher les boutons Pierre, Feuille et Ciseaux.

**1)** Tout en bas du fichier, ajoute notre propre widget **`ChoiceButton`** :

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
```

**2)** Dans `GameScreen`, remplace le `body` par :

```dart
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
```

**Ce qu'il faut comprendre**

- **`Column`** empile ses enfants de haut en bas, **`Row`** les aligne de gauche à droite.
- **`SizedBox`** sert à créer un espace vide entre deux éléments.
- On a **créé notre propre widget** `ChoiceButton` : on l'écrit une fois et on le réutilise trois fois avec des paramètres différents.
- `onPressed` reçoit une **fonction** : ce qui se passe quand on appuie. Pour l'instant, on affiche juste un message dans la console.

🧪 **Appuie sur un bouton** : le nom s'affiche dans la console (le terminal, ou l'onglet *Console* de DartPad).

---

## Étape 3 — L'ordinateur joue au hasard

**Objectif** : quand on choisit, l'ordinateur choisit aussi, et on affiche le duel.

Pour que l'écran puisse **changer**, il doit devenir un **`StatefulWidget`** (un widget avec un état).

**1)** Tout en haut du fichier, ajoute l'import de `dart:math` (pour le hasard) :

```dart
import 'dart:math';

import 'package:flutter/material.dart';
```

**2)** Juste après les imports, ajoute la liste des choix et de leurs emojis :

```dart
const Map<String, String> emojis = {
  'Pierre': '✊',
  'Feuille': '✋',
  'Ciseaux': '✌️',
};
```

**3)** Remplace toute la classe `GameScreen` par ces deux classes :

```dart
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? playerChoice;
  String? computerChoice;

  final Random random = Random();

  void play(String choice) {
    final options = emojis.keys.toList();
    final computerPick = options[random.nextInt(options.length)];

    setState(() {
      playerChoice = choice;
      computerChoice = computerPick;
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
            if (playerChoice != null && computerChoice != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildChoice('Toi', playerChoice!),
                  const Text('VS', style: TextStyle(fontSize: 24)),
                  buildChoice('Ordi', computerChoice!),
                ],
              ),
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
```

**Ce qu'il faut comprendre**

- **`StatefulWidget`** : un widget qui a des données qui changent (ici, les choix). Ces données vivent dans la classe `State`.
- **`setState()`** : la règle d'or. Quand on modifie l'état, on le fait **dans** `setState`, et Flutter redessine l'écran automatiquement.
- **`String?`** : le `?` veut dire « peut être vide (`null`) ». Au début, personne n'a encore joué. Le `!` dit à Dart « je suis sûr que ce n'est pas vide ».
- **`Map`** : un dictionnaire clé → valeur (`'Pierre'` → `'✊'`).
- **`for` et `if` dans une liste de widgets** : la boucle crée un bouton par choix, et le duel ne s'affiche que si une partie a été jouée.

⚠️ Après un passage de `StatelessWidget` à `StatefulWidget`, le hot reload ne suffit pas toujours : fais un **hot restart** (`R` majuscule dans le terminal, ou le bouton 🔄).

---

## Étape 4 — Qui a gagné ?

**Objectif** : comparer les deux choix et afficher le résultat.

**1)** Sous la `Map` `emojis`, ajoute les **règles du jeu** :

```dart
// Chaque choix BAT celui indiqué à droite.
const Map<String, String> beats = {
  'Pierre': 'Ciseaux', // la pierre casse les ciseaux
  'Feuille': 'Pierre', // la feuille enveloppe la pierre
  'Ciseaux': 'Feuille', // les ciseaux coupent la feuille
};
```

**2)** Dans `_GameScreenState`, ajoute une variable sous `computerChoice` :

```dart
  String result = '';
```

**3)** Dans la méthode `play`, complète le `setState` :

```dart
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
```

**4)** Dans `build`, remplace le bloc `if (playerChoice != null && computerChoice != null) Row(...)` par :

```dart
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
```

**Ce qu'il faut comprendre**

- **`if / else if / else`** : on teste d'abord l'égalité, puis si notre choix bat celui de l'ordi, sinon on a perdu.
- **La `Map` `beats`** sert de table de règles : `beats['Pierre']` vaut `'Ciseaux'`. Plus besoin d'écrire 9 cas à la main !
- **`...[ ]`** (le *spread*) : il permet d'afficher **plusieurs** widgets avec un seul `if`.

---

## Étape 5 — Score, « Recommencer » et un peu de style

**Objectif** : compter les points, colorer le résultat et pouvoir recommencer.

**1)** Dans `_GameScreenState`, ajoute ces variables sous `result` :

```dart
  Color resultColor = Colors.grey;
  int playerScore = 0;
  int computerScore = 0;
```

**2)** Dans `play`, mets à jour la couleur et le score dans chaque cas :

```dart
      if (choice == computerPick) {
        result = 'Égalité !';
        resultColor = Colors.grey;
      } else if (beats[choice] == computerPick) {
        result = 'Tu as gagné ! 🎉';
        resultColor = Colors.green;
        playerScore++;
      } else {
        result = 'Perdu… 😢';
        resultColor = Colors.red;
        computerScore++;
      }
```

**3)** Sous la méthode `play`, ajoute la méthode pour tout remettre à zéro :

```dart
  void reset() {
    setState(() {
      playerChoice = null;
      computerChoice = null;
      result = '';
      playerScore = 0;
      computerScore = 0;
    });
  }
```

**4)** Dans `build`, donne une couleur à la barre du haut :

```dart
      appBar: AppBar(
        title: const Text('Pierre-Feuille-Ciseaux'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
```

**5)** Toujours dans `build`, ajoute le **tableau des scores** comme premier enfant de la `Column` (avant `'Fais ton choix !'`) :

```dart
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Text(
                  'Toi  $playerScore  –  $computerScore  Ordi',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
```

**6)** Enfin, colore le résultat et ajoute le bouton « Recommencer » à la fin du bloc `...[ ]` :

```dart
              Text(
                result,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Recommencer'),
              ),
```

> Attention : le `TextStyle` du résultat n'est plus `const`, car sa couleur change pendant le jeu.

**Ce qu'il faut comprendre**

- **`playerScore++`** ajoute 1 au score.
- **`'Toi $playerScore'`** : le `$` insère la valeur d'une variable dans un texte (interpolation).
- **`Theme.of(context)`** récupère les couleurs du thème défini dans `MaterialApp` : toute l'app reste cohérente.
- **`reset()`** remet l'état à zéro… toujours dans un `setState` !

🎉 **Bravo, ton application est terminée !** Le code final complet est sur la branche `step5`.

---

## 🚀 Lancer l'app sur plusieurs plateformes

C'est le même code partout :

```bash
flutter devices             # liste les appareils disponibles et leur identifiant
flutter run -d chrome       # Web
flutter run -d <identifiant> # Android ou iOS (iOS nécessite un Mac)
flutter run -d windows      # ou macos / linux, pour le desktop
```

Pour générer une version à partager :

```bash
flutter build apk           # un fichier .apk pour Android
flutter build web           # un site web dans build/web
```

---

## 🧩 Pour aller plus loin

À toi de jouer ! Quelques idées, de la plus simple à la plus difficile :

1. **Changer le thème** : une autre couleur, un mode sombre (`brightness: Brightness.dark` dans `ColorScheme.fromSeed`).
2. **Partie en 3 points** : le premier à 3 gagne, et un message annonce le vainqueur.
3. **Ajouter une animation** : fais apparaître le résultat avec un `AnimatedSwitcher` ou un `AnimatedScale`.
4. **Version « Lézard-Spock »** : ajoute deux choix (règles de *Pierre-Feuille-Ciseaux-Lézard-Spock*). Indice : la `Map` `beats` devra associer chaque choix à une **liste** de choix battus.
5. **Historique** : affiche les 5 dernières parties avec une `ListView`.

---

## 📚 Ressources

- Documentation officielle : [docs.flutter.dev](https://docs.flutter.dev)
- Catalogue des widgets : [docs.flutter.dev/ui/widgets](https://docs.flutter.dev/ui/widgets)
- Apprendre Dart : [dart.dev/language](https://dart.dev/language)
- Tester du code sans rien installer : [dartpad.dev](https://dartpad.dev)
- Packages Flutter : [pub.dev](https://pub.dev)

**Merci d'avoir suivi le webinaire, et bon code ! 💙**

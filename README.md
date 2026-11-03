# ✊✋✌️ Pierre-Feuille-Ciseaux — Flutter pour débutants

Dépôt du webinaire **« Flutter pour débutants : créez votre première app multiplateforme »** (Force N).

Tu vas construire, étape par étape, un jeu de Pierre-Feuille-Ciseaux qui tourne sur le **web**, **Android** et **iOS** avec **un seul code**.

> 🚩 **Tu es sur la branche `main` : c'est le point de départ.**
> Elle contient un projet Flutter tout neuf (l'app « compteur » générée par `flutter create`). C'est d'ici que tu pars pour suivre le guide.

---

## 📚 Ce que contient le dépôt

| Dossier / fichier | Contenu |
|---|---|
| [`guides/GUIDE-ETAPES-1-A-5.md`](guides/GUIDE-ETAPES-1-A-5.md) | 📘 Le guide principal : construire le jeu en 5 étapes |
| [`guides/GUIDE-ETAPE-6-DESIGN.md`](guides/GUIDE-ETAPE-6-DESIGN.md) | 🥊 Bonus : transformer le jeu en « arène de combat » |
| [`presentation/flutter-debutants.html`](presentation/flutter-debutants.html) | 🎤 Les slides du webinaire (à ouvrir dans un navigateur) |
| `lib/main.dart` | Le seul fichier de code qu'on va modifier |

---

## 🚀 Démarrer

### Option A — Sans rien installer

1. Ouvre **[dartpad.dev](https://dartpad.dev)**.
2. Suis le [guide](guides/GUIDE-ETAPES-1-A-5.md) et colle le code de chaque étape dans DartPad.

### Option B — Sur ton ordinateur

1. Installe Flutter : [docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install), puis vérifie :
   ```bash
   flutter doctor
   ```
2. Récupère le projet :
   ```bash
   git clone https://github.com/dev-sec-killer/pierre_feuille_ciseaux.git
   cd pierre_feuille_ciseaux
   flutter pub get
   ```
3. Lance l'app de départ :
   ```bash
   flutter run -d chrome   # dans le navigateur
   flutter devices         # liste les appareils disponibles
   flutter run             # sur un émulateur ou un téléphone branché
   ```
   Tu dois voir l'app « compteur » de Flutter : c'est normal, c'est le point de départ ✅
4. Ouvre [`guides/GUIDE-ETAPES-1-A-5.md`](guides/GUIDE-ETAPES-1-A-5.md) et commence l'**étape 1** dans `lib/main.dart`.

> 💡 **Hot reload** : pendant que l'app tourne, enregistre le fichier (ou appuie sur `r` dans le terminal) et l'écran se met à jour en une seconde. Si quelque chose ne se met pas à jour, fais un **hot restart** avec `R`.

---

## 🪜 Les étapes (une branche par étape)

Chaque branche contient le **code complet à la fin de l'étape**. Si tu bloques, récupère la branche et repars de là.

| Branche | Étape | Ce que fait l'app | Guide |
|---|---|---|---|
| `main` | 0 — Départ | Projet Flutter vierge (app compteur) | [Avant de commencer](guides/GUIDE-ETAPES-1-A-5.md#0-avant-de-commencer) |
| `step1` | 1 | Un écran avec un titre | [Étape 1](guides/GUIDE-ETAPES-1-A-5.md#étape-1--un-écran-avec-un-titre) |
| `step2` | 2 | Les trois boutons ✊ ✋ ✌️ | [Étape 2](guides/GUIDE-ETAPES-1-A-5.md#étape-2--les-trois-boutons) |
| `step3` | 3 | L'ordinateur joue au hasard | [Étape 3](guides/GUIDE-ETAPES-1-A-5.md#étape-3--lordinateur-joue-au-hasard) |
| `step4` | 4 | Qui a gagné ? | [Étape 4](guides/GUIDE-ETAPES-1-A-5.md#étape-4--qui-a-gagné-) |
| `step5` | 5 | Score, « Recommencer » et style | [Étape 5](guides/GUIDE-ETAPES-1-A-5.md#étape-5--score--recommencer-et-un-peu-de-style) |
| `step6` | 6 (bonus) | L'arène de combat 🥊 | [Étape 6](guides/GUIDE-ETAPE-6-DESIGN.md) |

### Passer d'une étape à l'autre

```bash
git checkout step3        # voir le code de la fin de l'étape 3
flutter run -d chrome

git checkout main         # revenir au point de départ
```

> ⚠️ Si tu as modifié des fichiers, Git peut refuser de changer de branche. Sauvegarde ton travail d'abord :
> ```bash
> git stash               # met tes changements de côté
> git checkout step3
> git checkout main && git stash pop   # pour les récupérer plus tard
> ```

---

## 🧰 Les commandes utiles

```bash
flutter run -d chrome      # 🌐 lancer sur le web
flutter run                # 🤖 / 🍎 lancer sur Android ou iOS (iOS nécessite un Mac)
flutter build apk          # créer un .apk Android à partager
flutter build web          # créer un site web dans build/web
flutter test               # lancer les tests
```

---

## 🔗 Ressources

- Documentation officielle : [docs.flutter.dev](https://docs.flutter.dev)
- Catalogue des widgets : [docs.flutter.dev/ui/widgets](https://docs.flutter.dev/ui/widgets)
- Apprendre Dart : [dart.dev/language](https://dart.dev/language)
- Coder sans rien installer : [dartpad.dev](https://dartpad.dev)
- Packages Flutter : [pub.dev](https://pub.dev)

---

**Formateur : Saliou Seck — Développeur mobile · Mentor Force N**
Merci d'avoir suivi le webinaire, et bon code ! 💙 Jërëjëf

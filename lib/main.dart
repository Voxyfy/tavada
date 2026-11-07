import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/pantry.dart';
import 'data/prefs.dart';
import 'data/recipes.dart';
import 'data/saved.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(TavadaApp(pantry: Pantry(prefs), saved: Saved(prefs), prefs: Prefs(prefs), recipes: await loadRecipes()));
}

class TavadaApp extends StatelessWidget {
  const TavadaApp({required this.pantry, required this.saved, required this.prefs, required this.recipes, super.key});

  final Pantry pantry;
  final Saved saved;
  final Prefs prefs;
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) => MaterialApp(
        locale: prefs.locale,
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: prefs.onboarded
            ? HomeShell(pantry: pantry, saved: saved, prefs: prefs, recipes: recipes)
            : OnboardingScreen(prefs: prefs),
      ),
    );
  }
}

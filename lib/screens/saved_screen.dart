import 'package:flutter/material.dart';

import '../data/pantry.dart';
import '../data/prefs.dart';
import '../data/recipes.dart';
import '../data/saved.dart';
import '../domain/matcher.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/soft_image.dart';
import 'recipe_screen.dart';

/// Kayıtlılar: yer imiyle kaydedilen tarifler, iki sütunlu kartlar.
class SavedScreen extends StatelessWidget {
  const SavedScreen({
    required this.pantry,
    required this.saved,
    required this.prefs,
    required this.recipes,
    required this.onGoToKitchen,
    super.key,
  });

  final Pantry pantry;
  final Saved saved;
  final Prefs prefs;
  final List<Recipe> recipes;
  final VoidCallback onGoToKitchen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: ListenableBuilder(
        listenable: Listenable.merge([saved, pantry]),
        builder: (context, _) {
          // Kaydedilme sırası değil katalog sırası; kullanıcı kendi sıralamasını henüz istemedi.
          final items = recipes.where((r) => saved.has(r.id)).toList();
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                titleSpacing: 20,
                title: Text(l.tabSaved, style: display(30)),
              ),
              if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SoftImage('assets/images/actions/serve.jpg', size: 220),
                        const SizedBox(height: 8),
                        Text(l.savedEmptyTitle, textAlign: TextAlign.center, style: display(24, weight: 750)),
                        const SizedBox(height: 8),
                        Text(
                          l.savedEmptyBody,
                          textAlign: TextAlign.center,
                          style: body(15, color: AppColors.muted),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: onGoToKitchen,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 52),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            shape: const StadiumBorder(),
                            textStyle: body(16, weight: 650),
                          ),
                          child: Text(l.goToKitchen),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 236,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _SavedCard(
                        recipe: items[i],
                        lang: lang,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => RecipeScreen(
                              match: matchOne(items[i], pantry.selected),
                              pantry: pantry.selected,
                              saved: saved,
                              servings: prefs.servings,
                            ),
                          ),
                        ),
                      ),
                      childCount: items.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({required this.recipe, required this.lang, required this.onTap});

  final Recipe recipe;
  final String lang;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                'assets/images/dishes/${recipe.id}.jpg',
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.background),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name(lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: display(17, weight: 750).copyWith(letterSpacing: -0.2),
                  ),
                  const SizedBox(height: 3),
                  Text(l.minutesShort(recipe.minutes), style: body(13, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

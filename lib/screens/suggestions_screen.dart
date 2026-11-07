import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../data/ingredients.dart';
import '../data/prefs.dart';
import '../data/saved.dart';
import '../domain/matcher.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/hero_image.dart';
import 'recipe_screen.dart';

enum _Filter { all, complete, quick }

/// Öneriler: seçili malzemelerle yapılabilen tarifler, eksik varsa alternatifiyle.
class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({
    required this.matches,
    required this.pantry,
    required this.saved,
    required this.prefs,
    super.key,
  });

  final List<Match> matches;
  final Set<String> pantry;
  final Saved saved;
  final Prefs prefs;

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final all = widget.matches;
    final shown = switch (_filter) {
      _Filter.all => all,
      _Filter.complete => all.where((m) => m.complete).toList(),
      _Filter.quick => all.where((m) => m.recipe.minutes <= 30).toList(),
    };
    final complete = all.where((m) => m.complete).length;
    final missing = all.length - complete;
    final subtitle = missing == 0
        ? l.suggestionsAllComplete
        : complete == 0
        ? l.suggestionsAllMissing
        : l.suggestionsSubtitle(complete, missing);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            expandedHeight: MediaQuery.sizeOf(context).width * 805 / 1200,
            flexibleSpace: const FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              // Üst üçte bir zaten boş; geri oku oraya oturur.
              background: HeroImage('assets/images/hero_suggestions.jpg', topFade: 0.08),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              tooltip: l.back,
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.ink, size: 24),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            sliver: SliverList.list(
              children: [
                if (all.isEmpty) ...[
                  Text(l.noSuggestionsTitle, style: display(30)),
                  const SizedBox(height: 8),
                  Text(l.noSuggestionsBody, style: body(16, color: AppColors.muted)),
                ] else ...[
                  Text(l.suggestionsTitle(widget.pantry.length, all.length), style: display(32)),
                  const SizedBox(height: 8),
                  Text(subtitle, style: body(16, color: AppColors.muted)),
                  const SizedBox(height: 18),
                  // Dar ekranda üç çip sığmazsa yana kayar.
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: [
                        for (final f in _Filter.values) ...[
                          _FilterChip(
                            label: switch (f) {
                              _Filter.all => l.filterAll,
                              _Filter.complete => l.filterComplete,
                              _Filter.quick => l.filterQuick,
                            },
                            selected: _filter == f,
                            onTap: () => setState(() => _filter = f),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final m in shown) ...[
                    _RecipeCard(match: m, pantry: widget.pantry, saved: widget.saved, prefs: widget.prefs, lang: lang),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.ink : AppColors.card,
        shape: StadiumBorder(side: BorderSide(color: selected ? AppColors.ink : AppColors.line)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(label, style: body(14, weight: 500, color: selected ? Colors.white : AppColors.ink)),
          ),
        ),
      ),
    );
  }
}

String ingredientName(String id, String lang) =>
    ingredients.firstWhere((i) => i.id == id, orElse: () => Ingredient(id, IngredientGroup.basic, id, id)).name(lang);

String difficultyLabel(AppLocalizations l, int d) => switch (d) {
  1 => l.difficultyEasy,
  2 => l.difficultyMedium,
  _ => l.difficultyHard,
};

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.match,
    required this.pantry,
    required this.saved,
    required this.prefs,
    required this.lang,
  });

  final Match match;
  final Set<String> pantry;
  final Saved saved;
  final Prefs prefs;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final r = match.recipe;
    final miss = match.missing.firstOrNull;

    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => RecipeScreen(match: match, pantry: pantry, saved: saved, servings: prefs.servings),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/dishes/${r.id}.jpg',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                      errorBuilder: (_, _, _) => Container(width: 96, height: 96, color: AppColors.background),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name(lang), style: display(21, weight: 750)),
                        const SizedBox(height: 4),
                        Text(
                          l.recipeMeta(r.minutes, difficultyLabel(l, r.difficulty), r.servings),
                          style: body(13, color: AppColors.muted),
                        ),
                        const SizedBox(height: 10),
                        _Badge(complete: match.complete, l: l),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (miss != null)
              Container(
                color: const Color(0xFFFFF3C7),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const HugeIcon(icon: HugeIcons.strokeRoundedExchange01, size: 16, color: Color(0xFFB45309)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        miss.sub == null
                            ? l.missingRow(ingredientName(miss.id, lang))
                            : l.swapRow(ingredientName(miss.id, lang), ingredientName(miss.sub!.id, lang)),
                        style: body(14, weight: 500),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.complete, required this.l});

  final bool complete;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: complete ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: complete ? HugeIcons.strokeRoundedCheckmarkCircle02 : HugeIcons.strokeRoundedAlertCircle,
            size: 14,
            color: complete ? const Color(0xFF15803D) : const Color(0xFF92400E),
          ),
          const SizedBox(width: 5),
          Text(
            complete ? l.badgeComplete : l.badgeMissing,
            style: body(12, weight: 600, color: complete ? const Color(0xFF15803D) : const Color(0xFF92400E)),
          ),
        ],
      ),
    );
  }
}

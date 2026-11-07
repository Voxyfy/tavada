import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../data/saved.dart';
import '../domain/matcher.dart';
import '../domain/scale_qty.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/hero_image.dart';
import 'cooking_screen.dart';
import 'suggestions_screen.dart' show difficultyLabel, ingredientName;

/// Tarif: büyük görsel, Malzemeler / Yapılışı sekmeleri, eksik malzeme alternatifiyle.
class RecipeScreen extends StatefulWidget {
  const RecipeScreen({
    required this.match,
    required this.pantry,
    required this.saved,
    required this.servings,
    super.key,
  });

  final Match match;
  final Set<String> pantry;
  final Saved saved;

  /// Ayarlardaki kişi sayısı; miktarlar tarifin kendi kişi sayısına oranla ölçeklenir.
  final int servings;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool _showSteps = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final r = widget.match.recipe;
    final missingById = {for (final m in widget.match.missing) m.id: m};
    final factor = widget.servings / r.servings;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                expandedHeight: MediaQuery.sizeOf(context).width * 0.95,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: HeroImage('assets/images/dishes/${r.id}.jpg', topFade: 0.12),
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: l.back,
                  icon: const HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.ink, size: 24),
                ),
                actions: [
                  ListenableBuilder(
                    listenable: widget.saved,
                    builder: (context, _) {
                      final on = widget.saved.has(r.id);
                      return IconButton(
                        onPressed: () => widget.saved.toggle(r.id),
                        tooltip: on ? l.savedLabel : l.save,
                        isSelected: on,
                        icon: HugeIcon(
                          icon: on ? HugeIcons.strokeRoundedBookmarkCheck02 : HugeIcons.strokeRoundedBookmark02,
                          color: on ? AppColors.accent : AppColors.ink,
                          size: 24,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList.list(
                  children: [
                    Text(r.name(lang), style: display(36)),
                    const SizedBox(height: 6),
                    Text(
                      l.recipeMeta(r.minutes, difficultyLabel(l, r.difficulty), widget.servings),
                      style: body(15, color: AppColors.muted),
                    ),
                    const SizedBox(height: 18),
                    _Segmented(
                      left: l.tabIngredients,
                      right: l.tabSteps(r.steps.length),
                      rightSelected: _showSteps,
                      onChanged: (v) => setState(() => _showSteps = v),
                    ),
                    const SizedBox(height: 8),
                    if (!_showSteps)
                      for (final i in r.ingredients)
                        if (missingById[i.id] case final m?)
                          _MissingBox(
                            title: m.sub == null
                                ? l.missingRow(ingredientName(i.id, lang))
                                : l.swapArrow(ingredientName(i.id, lang), ingredientName(m.sub!.id, lang)),
                            qty: scaleQty(i.qty, factor),
                            note: m.sub?.note,
                          )
                        else
                          _IngredientRow(
                            name: ingredientName(i.id, lang),
                            qty: scaleQty(i.qty, factor),
                            have: widget.pantry.contains(i.id),
                            optional: i.optional,
                          )
                    else
                      for (final (n, step) in r.steps.indexed)
                        _StepRow(number: n + 1, text: step, isLast: n == r.steps.length - 1),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 16),
              child: FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (_) => CookingScreen(recipe: r, saved: widget.saved),
                  ),
                ),
                icon: const HugeIcon(icon: HugeIcons.strokeRoundedPlay, color: Colors.white, size: 20),
                label: Text(l.startCooking),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: const StadiumBorder(),
                  textStyle: body(17, weight: 650),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// İki seçenekli siyah/krem sekme.
class _Segmented extends StatelessWidget {
  const _Segmented({required this.left, required this.right, required this.rightSelected, required this.onChanged});

  final String left;
  final String right;
  final bool rightSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget tab(String label, bool selected, bool value) => Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? AppColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onChanged(value),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(label, style: body(14, weight: 600, color: selected ? Colors.white : AppColors.muted)),
            ),
          ),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [tab(left, !rightSelected, false), tab(right, rightSelected, true)]),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.name, required this.qty, required this.have, required this.optional});

  final String name;
  final String qty;
  final bool have;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Semantics(
            label: have ? l.haveIt : l.dontHaveIt,
            child: HugeIcon(
              icon: have ? HugeIcons.strokeRoundedCheckmarkCircle02 : HugeIcons.strokeRoundedCircle,
              size: 22,
              color: have ? const Color(0xFF15803D) : AppColors.line,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: name,
                children: [
                  if (optional)
                    TextSpan(
                      text: '  ${l.optionalTag}',
                      style: body(12, color: AppColors.muted),
                    ),
                ],
              ),
              style: body(16),
            ),
          ),
          Text(qty, style: body(14, color: AppColors.muted)),
        ],
      ),
    );
  }
}

/// Eksik malzeme: sarı kutu, alternatif ve kısa not.
class _MissingBox extends StatelessWidget {
  const _MissingBox({required this.title, required this.qty, required this.note});

  final String title;
  final String qty;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HugeIcon(icon: HugeIcons.strokeRoundedAlertCircle, size: 22, color: Color(0xFFB45309)),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: body(16, weight: 600))),
              Text(qty, style: body(14, color: AppColors.muted)),
            ],
          ),
          if (note != null)
            Padding(
              padding: const EdgeInsets.only(left: 34, top: 6),
              child: Text(note!, style: body(14, color: const Color(0xFF44403C)).copyWith(height: 1.4)),
            ),
        ],
      ),
    );
  }
}

/// Zaman çizgisi: solda numaralı düğüm ve bağlantı çizgisi, sağda adım kartı.
class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text, required this.isLast});

  final int number;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                  child: Text('$number', style: body(13, weight: 700, color: Colors.white)),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: AppColors.line)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                child: Text(text, style: body(15).copyWith(height: 1.45)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

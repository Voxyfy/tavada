import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../data/ingredients.dart';
import '../data/pantry.dart';
import '../data/prefs.dart';
import '../data/recipes.dart';
import '../data/saved.dart';
import '../domain/matcher.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/hero_image.dart';
import 'suggestions_screen.dart';

/// Türkçe büyük/küçük harf: Dart'ın toLowerCase'i "I"yı "i", "İ"yi "i̇" yapar.
String foldTurkish(String s) => s.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();

/// Hazırla hapı bu kadar malzeme seçilmeden görünmez; daha azıyla anlamlı öneri çıkmıyor.
const minIngredients = 3;

/// Her grupta önizleme 3 sütun × 3 satır: 8 çip + "+N daha"; gerisi alttan açılan sayfada.
const previewCount = 8;
const gridColumns = 3;

/// Ana ekran: kullanıcı mutfağındaki malzemeleri seçer, "Hazırla" der.
class KitchenScreen extends StatefulWidget {
  const KitchenScreen({
    required this.pantry,
    required this.saved,
    required this.prefs,
    required this.recipes,
    super.key,
  });

  final Pantry pantry;
  final Saved saved;
  final Prefs prefs;
  final List<Recipe> recipes;

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final q = foldTurkish(_query.trim());
    final searching = q.isNotEmpty;
    final visible = ingredients.where((i) => !searching || foldTurkish(i.name(lang)).contains(q)).toList();
    final groupTitles = {
      IngredientGroup.vegetable: l.groupVegetable,
      IngredientGroup.fruit: l.groupFruit,
      IngredientGroup.meat: l.groupMeat,
      IngredientGroup.dairy: l.groupDairy,
      IngredientGroup.grain: l.groupGrain,
      IngredientGroup.basic: l.groupBasic,
      IngredientGroup.herb: l.groupHerb,
    };
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.pantry,
        builder: (context, _) => Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Logo ve ayarlar üstte sabit kalır; sahne kaydırınca toplanır.
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppColors.background,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  expandedHeight: width * 2 / 3,
                  titleSpacing: 20,
                  title: Text.rich(
                    TextSpan(
                      text: 'tavada',
                      children: [
                        TextSpan(
                          text: '.',
                          style: display(30).copyWith(color: AppColors.accent),
                        ),
                      ],
                    ),
                    style: display(30),
                    semanticsLabel: l.appName,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: const HeroImage('assets/images/hero_kitchen.jpg', topFade: 0.1),
                  ),
                ),
                SliverPadding(
                  // 140 = alt hap + pay.
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                  sliver: SliverList.list(
                    children: [
                      Text(l.kitchenTitle, style: display(38)),
                      const SizedBox(height: 8),
                      Text(l.kitchenSubtitle, style: body(16, color: AppColors.muted)),
                      const SizedBox(height: 18),
                      TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: body(16),
                        decoration: InputDecoration(
                          hintText: l.searchHint,
                          hintStyle: body(16, color: AppColors.muted),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12),
                            child: HugeIcon(icon: HugeIcons.strokeRoundedSearch01, color: AppColors.muted, size: 22),
                          ),
                          filled: true,
                          fillColor: AppColors.card,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
                          ),
                        ),
                      ),
                      if (visible.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(l.noSearchResult, style: body(15, color: AppColors.muted)),
                        ),
                      for (final group in IngredientGroup.values)
                        if (visible.any((i) => i.group == group))
                          _GroupSection(
                            title: groupTitles[group]!,
                            items: visible.where((i) => i.group == group).toList(),
                            // Aramada hepsi görünür; normalde ilk 8 + "+N daha".
                            previewAll: searching,
                            pantry: widget.pantry,
                            lang: lang,
                          ),
                    ],
                  ),
                ),
              ],
            ),
            // Hazırla hapının arkası: çipler hapın altında yumuşakça kaybolur; hap yokken geçiş de yok.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 150,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  key: const ValueKey('prepare-fade'),
                  opacity: widget.pantry.selected.length >= minIngredients ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.background.withValues(alpha: 0), AppColors.background],
                        stops: const [0, 0.5],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 0,
              child: _PrepareBar(
                pantry: widget.pantry,
                saved: widget.saved,
                prefs: widget.prefs,
                recipes: widget.recipes,
                lang: lang,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.title,
    required this.items,
    required this.previewAll,
    required this.pantry,
    required this.lang,
  });

  final String title;
  final List<Ingredient> items;
  final bool previewAll;
  final Pantry pantry;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final shown = previewAll ? items : items.take(previewCount).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: body(12, weight: 600, color: AppColors.muted).copyWith(letterSpacing: 1)),
          const SizedBox(height: 8),
          _IngredientGrid(
            items: shown,
            pantry: pantry,
            lang: lang,
            trailing: shown.length < items.length
                ? _MoreChip(label: l.showMore(items.length - shown.length), onTap: () => _openGroupSheet(context))
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _openGroupSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => ListenableBuilder(
        listenable: pantry,
        builder: (context, _) => SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 8, 12),
                  child: Row(
                    children: [
                      Expanded(child: Text(title, style: display(26, weight: 750))),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l.done, style: body(16, weight: 600, color: AppColors.accent)),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: _IngredientGrid(items: items, pantry: pantry, lang: lang),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 2 sütunlu eşit genişlikte çip ızgarası; satırlar düzgün hizalanır, kaydırmayı dıştaki liste yapar.
class _IngredientGrid extends StatelessWidget {
  const _IngredientGrid({required this.items, required this.pantry, required this.lang, this.trailing});

  final List<Ingredient> items;
  final Pantry pantry;
  final String lang;

  /// Son hücreye eklenen "+N daha" çipi.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GridView(
      // GridView varsayılan olarak güvenli alan payını ekler; dış liste onu zaten veriyor.
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridColumns,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 42,
      ),
      children: [
        for (final i in items)
          _IngredientChip(
            asset: 'assets/images/ingredients/${i.id}.png',
            label: i.name(lang),
            selected: pantry.has(i.id),
            onTap: () => pantry.toggle(i.id),
          ),
        ?trailing,
      ],
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.asset, required this.label, required this.selected, required this.onTap});

  final String asset;
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
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 8),
            child: Row(
              children: [
                // Kil ikon krem madalyon içinde; siyah seçili çipte de aynı görünür.
                ClipOval(
                  child: Image.asset(
                    asset,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    // İkonu henüz üretilmemiş malzeme için boş krem madalyon.
                    errorBuilder: (_, _, _) => Container(width: 30, height: 30, color: AppColors.background),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body(13, weight: selected ? 600 : 450, color: selected ? Colors.white : AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "+N daha" çipi: ikon yok, soluk yazı, ızgarada son hücre.
class _MoreChip extends StatelessWidget {
  const _MoreChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const StadiumBorder(side: BorderSide(color: AppColors.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Center(
          child: Text(label, style: body(14, weight: 600, color: AppColors.muted)),
        ),
      ),
    );
  }
}

/// Alttaki sabit kart: kaç malzeme seçildiği ve ana düğme.
class _PrepareBar extends StatelessWidget {
  const _PrepareBar({
    required this.pantry,
    required this.saved,
    required this.prefs,
    required this.recipes,
    required this.lang,
  });

  final Pantry pantry;
  final Saved saved;
  final Prefs prefs;
  final List<Recipe> recipes;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Katalog sırasıyla ilk üç seçili malzeme, gerisi "+N".
    final names = [
      for (final i in ingredients)
        if (pantry.has(i.id)) i.name(lang),
    ];
    final summary = names.isEmpty
        ? l.nothingSelected
        : [names.take(3).join(', '), if (names.length > 3) l.selectedMore(names.length - 3)].join(' ');

    // Alt menüyle aynı genişlik ve biçimde tek hap; 3 malzemeden azsa alttan kayıp kaybolur.
    final enabled = names.length >= minIngredients;
    return AnimatedSlide(
      offset: enabled ? Offset.zero : const Offset(0, 1.6),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        key: const ValueKey('prepare-bar'),
        opacity: enabled ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !enabled,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: enabled ? AppColors.accent : AppColors.card,
              shape: StadiumBorder(side: BorderSide(color: enabled ? AppColors.accent : AppColors.line)),
              elevation: enabled ? 8 : 0,
              shadowColor: const Color(0x331C1917),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: enabled
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => SuggestionsScreen(
                            matches: matchRecipes(recipes, pantry.selected, diet: prefs.diet),
                            pantry: pantry.selected,
                            saved: saved,
                            prefs: prefs,
                          ),
                        ),
                      )
                    : null,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.fromLTRB(22, 0, 18, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.selectedCount(names.length),
                              style: display(18, weight: 700).copyWith(color: enabled ? Colors.white : AppColors.muted),
                            ),
                            Text(
                              summary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: body(12, color: enabled ? const Color(0xE6FFFFFF) : AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(l.prepare, style: body(16, weight: 650, color: enabled ? Colors.white : AppColors.muted)),
                      const SizedBox(width: 6),
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight01,
                        color: enabled ? Colors.white : AppColors.muted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

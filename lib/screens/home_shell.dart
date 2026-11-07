import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../data/pantry.dart';
import '../data/prefs.dart';
import '../data/recipes.dart';
import '../data/saved.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'kitchen_screen.dart';
import 'saved_screen.dart';
import 'settings_screen.dart';

/// Alt menü: Mutfağım · Kayıtlılar · Ayarlar. Ekranın dibine yapışık, üç eşit sekme, hepsinde yazı.
/// (Yüzen hap denendi, kullanıcı dengesiz buldu.) Sekmeler durumunu korur (IndexedStack).
class HomeShell extends StatefulWidget {
  const HomeShell({required this.pantry, required this.saved, required this.prefs, required this.recipes, super.key});

  final Pantry pantry;
  final Saved saved;
  final Prefs prefs;
  final List<Recipe> recipes;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tabs = [
      (HugeIcons.strokeRoundedChefHat, l.tabKitchen),
      (HugeIcons.strokeRoundedBookmark02, l.tabSaved),
      (HugeIcons.strokeRoundedSettings01, l.tabSettings),
    ];
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          KitchenScreen(pantry: widget.pantry, saved: widget.saved, prefs: widget.prefs, recipes: widget.recipes),
          SavedScreen(
            pantry: widget.pantry,
            saved: widget.saved,
            prefs: widget.prefs,
            recipes: widget.recipes,
            onGoToKitchen: () => setState(() => _tab = 0),
          ),
          SettingsScreen(prefs: widget.prefs),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              for (final (i, (icon, label)) in tabs.indexed)
                _TabItem(icon: icon, label: label, selected: _tab == i, onTap: () => setState(() => _tab = i)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final List<List<dynamic>> icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.ink : AppColors.muted;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(icon: icon, color: color, size: 24, strokeWidth: selected ? 2 : 1.5),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: body(11, weight: selected ? 650 : 500, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

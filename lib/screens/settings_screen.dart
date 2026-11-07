import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/prefs.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

/// Ayarlar: beslenme, kişi sayısı, dil, bildirim, gizlilik, iletişim.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.prefs, super.key});

  final Prefs prefs;

  // shortcut: gizlilik sayfası henüz yayında değil; Voxyfy yayın düzenine göre bu adrese konacak.
  static final privacyUrl = Uri.parse('https://voxyfy.github.io/tavada/privacy.html');
  static const contactMail = 'haymana.batuhan@gmail.com';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: ListenableBuilder(
        listenable: prefs,
        builder: (context, _) {
          final dietLabel = switch (prefs.diet) {
            Diet.all => l.dietAll,
            Diet.vegetarian => l.dietVegetarian,
            Diet.vegan => l.dietVegan,
          };
          final servingsLabel = switch (prefs.servings) {
            5 => l.servingsFive,
            4 => '3–4',
            final n => '$n',
          };
          final langLabel = switch (prefs.localeCode) {
            'tr' => 'Türkçe',
            'en' => 'English',
            _ => l.languageSystem,
          };
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                titleSpacing: 20,
                title: Text(l.tabSettings, style: display(30)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                sliver: SliverList.list(
                  children: [
                    _Group(
                      children: [
                        _Row(
                          icon: HugeIcons.strokeRoundedLeaf01,
                          label: l.settingsDiet,
                          value: dietLabel,
                          onTap: () => _pick<Diet>(
                            context,
                            title: l.settingsDiet,
                            hint: l.dietHint,
                            options: [
                              (Diet.all, l.dietAll),
                              (Diet.vegetarian, l.dietVegetarian),
                              (Diet.vegan, l.dietVegan),
                            ],
                            selected: prefs.diet,
                            onPick: (v) => prefs.diet = v,
                          ),
                        ),
                        _Row(
                          icon: HugeIcons.strokeRoundedUserGroup,
                          label: l.settingsServings,
                          value: servingsLabel,
                          onTap: () => _pick<int>(
                            context,
                            title: l.settingsServings,
                            hint: l.servingsHint,
                            options: [(1, '1'), (2, '2'), (4, '3–4'), (5, l.servingsFive)],
                            selected: prefs.servings,
                            onPick: (v) => prefs.servings = v,
                          ),
                        ),
                        _Row(
                          icon: HugeIcons.strokeRoundedGlobe02,
                          label: l.settingsLanguage,
                          value: langLabel,
                          onTap: () => _pick<String?>(
                            context,
                            title: l.settingsLanguage,
                            options: [(null, l.languageSystem), ('tr', 'Türkçe'), ('en', 'English')],
                            selected: prefs.localeCode,
                            onPick: (v) => prefs.localeCode = v,
                          ),
                        ),
                        _Row(
                          icon: HugeIcons.strokeRoundedNotification03,
                          label: l.settingsNotifications,
                          hint: l.notificationsHint,
                          trailing: Switch.adaptive(
                            value: prefs.notifications,
                            activeTrackColor: AppColors.ink,
                            onChanged: (v) => prefs.notifications = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Group(
                      children: [
                        _Row(
                          icon: HugeIcons.strokeRoundedShield01,
                          label: l.settingsPrivacy,
                          onTap: () => _open(context, privacyUrl),
                        ),
                        _Row(
                          icon: HugeIcons.strokeRoundedMail01,
                          label: l.settingsContact,
                          onTap: () => _open(
                            context,
                            Uri(scheme: 'mailto', path: contactMail, queryParameters: {'subject': l.contactSubject}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(l.settingsVersion('1.0.0'), style: body(13, color: AppColors.muted)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _open(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).couldNotOpen)));
    }
  }

  /// Alttan açılan tek seçimli liste; seçince kapanır.
  Future<void> _pick<T>(
    BuildContext context, {
    required String title,
    String? hint,
    required List<(T, String)> options,
    required T selected,
    required ValueChanged<T> onPick,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: display(26, weight: 750)),
              if (hint != null) ...[const SizedBox(height: 6), Text(hint, style: body(14, color: AppColors.muted))],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (value, label) in options)
                    _Choice(
                      label: label,
                      selected: value == selected,
                      onTap: () {
                        onPick(value);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (n, child) in children.indexed) ...[
            if (n > 0) const Divider(height: 1, color: AppColors.line),
            child,
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, this.value, this.hint, this.trailing, this.onTap});

  final List<List<dynamic>> icon;
  final String label;
  final String? value;
  final String? hint;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: AppColors.ink, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: body(16)),
                  if (hint != null) Text(hint!, style: body(12, color: AppColors.muted)),
                ],
              ),
            ),
            if (value != null) ...[Text(value!, style: body(14, color: AppColors.muted)), const SizedBox(width: 6)],
            trailing ?? const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.label, required this.selected, required this.onTap});

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
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Center(
              widthFactor: 1,
              child: Text(label, style: body(15, weight: 500, color: selected ? Colors.white : AppColors.ink)),
            ),
          ),
        ),
      ),
    );
  }
}

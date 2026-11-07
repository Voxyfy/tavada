import 'package:flutter/material.dart';

import '../data/prefs.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/hero_image.dart';

/// İlk açılışta 3 sayfalık tanıtım; bitince Prefs.onboarded işaretlenir, main.dart ana ekranı açar.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.prefs, super.key});

  final Prefs prefs;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  void _next() {
    if (_index == 2) return widget.prefs.finishOnboarding();
    _page.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final pages = [
      // Buzdolabı sağ kenarda; pencere sağa kayar.
      _Page(asset: 'assets/images/onb_1.jpg', title: l.onbTitle1, body: l.onbBody1, align: const Alignment(0.35, 1)),
      _Page(asset: 'assets/images/onb_2.jpg', title: l.onbTitle2, body: l.onbBody2),
      _Page(asset: 'assets/images/onb_3.jpg', title: l.onbTitle3, body: l.onbBody3, form: true),
    ];
    final last = _index == 2;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _page,
            onPageChanged: (i) => setState(() => _index = i),
            children: [
              for (final p in pages)
                // Üç sayfa aynı düzen: sahne + metin (+ form) tek grup, düğmelerin üstündeki alanda ortalı;
                // sığmazsa kaydırılır.
                Builder(
                  builder: (context) {
                    final top = MediaQuery.paddingOf(context).top + 44;
                    const bottom = 170.0;
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(top: top, bottom: bottom),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: size.height - top - bottom),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.width * (p.form ? 0.7 : 0.92),
                              child: HeroImage(p.asset, topFade: 0.05, alignment: p.align),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.title, style: display(36)),
                                  const SizedBox(height: 10),
                                  Text(p.body, style: body(17, color: AppColors.muted).copyWith(height: 1.4)),
                                  if (p.form) ...[const SizedBox(height: 22), _PrefsForm(prefs: widget.prefs)],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          // Alt düğmelerin arkası: kaydırılan içerik zemine erir, düğmelerle karışmaz.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 220,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.background.withValues(alpha: 0), AppColors.background],
                    stops: const [0, 0.45],
                  ),
                ),
              ),
            ),
          ),
          // Sağ üst: Atla.
          Positioned(
            top: 0,
            right: 8,
            child: SafeArea(
              child: TextButton(
                onPressed: widget.prefs.finishOnboarding,
                style: TextButton.styleFrom(foregroundColor: AppColors.ink),
                child: Text(l.onbSkip, style: body(15, weight: 600)),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _index ? 22 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _index ? AppColors.ink : AppColors.line,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: const StadiumBorder(),
                      textStyle: body(17, weight: 650),
                    ),
                    child: Text(switch (_index) {
                      0 => l.onbStart,
                      1 => l.onbContinue,
                      _ => l.onbGoKitchen,
                    }),
                  ),
                  if (last)
                    TextButton(
                      onPressed: widget.prefs.finishOnboarding,
                      style: TextButton.styleFrom(foregroundColor: AppColors.muted),
                      child: Text(l.onbSkipForNow, style: body(14, weight: 600)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Page {
  const _Page({
    required this.asset,
    required this.title,
    required this.body,
    this.form = false,
    this.align = Alignment.bottomCenter,
  });

  final String asset;

  /// Kare kırpmada pencerenin yeri.
  final Alignment align;
  final String title;
  final String body;
  final bool form;
}

/// 3. sayfa: beslenme ve kişi sayısı; Ayarlar'daki aynı tercihler.
class _PrefsForm extends StatelessWidget {
  const _PrefsForm({required this.prefs});

  final Prefs prefs;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(l.onbDietLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (d, label) in [
                (Diet.all, l.dietAll),
                (Diet.vegetarian, l.dietVegetarian),
                (Diet.vegan, l.dietVegan),
              ])
                _Chip(label: label, selected: prefs.diet == d, onTap: () => prefs.diet = d),
            ],
          ),
          const SizedBox(height: 18),
          _label(l.onbServingsLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (n, label) in [(1, '1'), (2, '2'), (4, '3–4'), (5, l.servingsFive)])
                _Chip(label: label, selected: prefs.servings == n, onTap: () => prefs.servings = n),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text.toUpperCase(), style: body(12, weight: 600, color: AppColors.muted).copyWith(letterSpacing: 1)),
  );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

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
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // widthFactor: 1 → çip metni kadar geniş kalır, satırı doldurmaz.
            child: Center(
              widthFactor: 1,
              child: Text(label, style: body(14, weight: 500, color: selected ? Colors.white : AppColors.ink)),
            ),
          ),
        ),
      ),
    );
  }
}

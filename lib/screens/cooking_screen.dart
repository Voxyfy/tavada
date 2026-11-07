import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../data/recipes.dart';
import '../data/saved.dart';
import '../domain/step_action.dart';
import '../domain/step_duration.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/soft_image.dart';

/// Pişirme modu: tek adım, büyük yazı, süre geçen adımda zamanlayıcı. Ekran açık kalır.
class CookingScreen extends StatefulWidget {
  const CookingScreen({required this.recipe, required this.saved, this.startAt = 0, super.key});

  final Recipe recipe;
  final Saved saved;

  /// Başlangıç adımı (mağaza görselleri için süreli bir adımdan açmak gerekiyor).
  final int startAt;

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  late int _index = widget.startAt;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    // Mutfakta telefon kilitlenmesin; hata olursa (desteklenmeyen platform) sessizce geçilir.
    unawaited(WakelockPlus.enable().catchError((_) {}));
  }

  @override
  void dispose() {
    unawaited(WakelockPlus.disable().catchError((_) {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final steps = widget.recipe.steps;
    final last = _index == steps.length - 1;
    final duration = stepDuration(steps[_index]);
    if (_finished) return _FinishScreen(recipe: widget.recipe, saved: widget.saved);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(l.stepOf(_index + 1, steps.length), style: body(15, weight: 600))),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: l.close,
                    icon: const HugeIcon(icon: HugeIcons.strokeRoundedCancel01, color: AppColors.ink, size: 24),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: (_index + 1) / steps.length,
                  minHeight: 5,
                  backgroundColor: AppColors.line,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 36),
              Text(steps[_index], style: display(30, weight: 700).copyWith(height: 1.2)),
              Expanded(
                child: Center(
                  child: duration != null
                      // Adım değişince zamanlayıcı sıfırlansın diye anahtar adım numarası.
                      ? _StepTimer(key: ValueKey(_index), total: duration)
                      // Süresiz adımda şefin o işi yaptığı sahne; eylem bulunamazsa yemeğin kendisi.
                      : SoftImage(switch (stepAction(steps[_index])) {
                          final a? => 'assets/images/actions/$a.jpg',
                          null => 'assets/images/dishes/${widget.recipe.id}.jpg',
                        }, size: 300),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (_index > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _index--),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.ink,
                          side: const BorderSide(color: AppColors.line),
                          minimumSize: const Size.fromHeight(56),
                          shape: const StadiumBorder(),
                          textStyle: body(16, weight: 600),
                        ),
                        child: Text(l.previous),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () => setState(() => last ? _finished = true : _index++),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(56),
                        shape: const StadiumBorder(),
                        textStyle: body(17, weight: 650),
                      ),
                      child: Text(last ? l.finishCooking : l.next),
                    ),
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

/// Son ekran: yemeğin görseli, "Afiyet olsun!", kaydet ve tarife dön.
class _FinishScreen extends StatelessWidget {
  const _FinishScreen({required this.recipe, required this.saved});

  final Recipe recipe;
  final Saved saved;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              SoftImage('assets/images/dishes/${recipe.id}.jpg', size: 320),
              const SizedBox(height: 24),
              Text(l.enjoyTitle, textAlign: TextAlign.center, style: display(36)),
              const SizedBox(height: 8),
              Text(
                recipe.name(lang),
                textAlign: TextAlign.center,
                style: body(17, color: AppColors.muted),
              ),
              const Spacer(),
              ListenableBuilder(
                listenable: saved,
                builder: (context, _) {
                  final on = saved.has(recipe.id);
                  return FilledButton.icon(
                    onPressed: () => saved.toggle(recipe.id),
                    icon: HugeIcon(
                      icon: on ? HugeIcons.strokeRoundedBookmarkCheck02 : HugeIcons.strokeRoundedBookmark02,
                      color: on ? AppColors.ink : Colors.white,
                      size: 20,
                    ),
                    label: Text(on ? l.savedLabel : l.save),
                    style: FilledButton.styleFrom(
                      backgroundColor: on ? AppColors.card : AppColors.accent,
                      foregroundColor: on ? AppColors.ink : Colors.white,
                      side: on ? const BorderSide(color: AppColors.line) : null,
                      minimumSize: const Size.fromHeight(56),
                      shape: const StadiumBorder(),
                      textStyle: body(17, weight: 650),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: AppColors.ink, minimumSize: const Size.fromHeight(48)),
                child: Text(l.backToRecipe, style: body(16, weight: 600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Büyük yuvarlak geri sayım; Başlat/Duraklat ve +1 dk.
class _StepTimer extends StatefulWidget {
  const _StepTimer({required this.total, super.key});

  final Duration total;

  @override
  State<_StepTimer> createState() => _StepTimerState();
}

class _StepTimerState extends State<_StepTimer> {
  late Duration _remaining = widget.total;
  Timer? _ticker;

  bool get _running => _ticker != null;
  bool get _done => _remaining == Duration.zero;

  void _toggle() {
    if (_running) {
      _ticker?.cancel();
      setState(() => _ticker = null);
      return;
    }
    setState(() {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _remaining -= const Duration(seconds: 1));
        if (_done) {
          _ticker?.cancel();
          _ticker = null;
          unawaited(HapticFeedback.heavyImpact());
        }
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final m = _remaining.inMinutes.toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    final progress = widget.total.inSeconds == 0 ? 1.0 : _remaining.inSeconds / widget.total.inSeconds;

    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColors.line,
                color: _done ? AppColors.accent : AppColors.ink,
              ),
              Center(
                child: Text(
                  _done ? l.timerDone : '$m:$s',
                  style: _done ? body(18, weight: 600, color: AppColors.accent) : display(44, weight: 700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Pill(
              label: _running ? l.timerPause : (_remaining == widget.total ? l.timerStart : l.timerResume),
              onTap: _done ? null : _toggle,
            ),
            const SizedBox(width: 12),
            _Pill(label: l.timerPlusMinute, onTap: () => setState(() => _remaining += const Duration(minutes: 1))),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line),
        minimumSize: const Size(120, 48),
        shape: const StadiumBorder(),
        textStyle: body(15, weight: 600),
      ),
      child: Text(label),
    );
  }
}

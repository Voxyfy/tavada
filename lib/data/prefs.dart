import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Diet { all, vegetarian, vegan }

/// Kullanıcı tercihleri; telefonda kalıcı. Pantry/Saved ile aynı kalıp.
class Prefs extends ChangeNotifier {
  Prefs(this._prefs)
    : _diet = Diet.values.byName(_prefs.getString('prefs.diet') ?? 'all'),
      _servings = _prefs.getInt('prefs.servings') ?? 2,
      _localeCode = _prefs.getString('prefs.locale'),
      _notifications = _prefs.getBool('prefs.notifications') ?? false,
      _onboarded = _prefs.getBool('prefs.onboarded') ?? false;

  final SharedPreferences _prefs;
  Diet _diet;
  int _servings;
  String? _localeCode;
  bool _notifications;
  bool _onboarded;

  Diet get diet => _diet;

  /// 1, 2, 4 (3–4) ya da 5 (5+).
  int get servings => _servings;

  /// null = cihaz dili.
  Locale? get locale => _localeCode == null ? null : Locale(_localeCode!);
  String? get localeCode => _localeCode;
  bool get notifications => _notifications;

  /// Tanıtım bir kez gösterilir.
  bool get onboarded => _onboarded;

  set diet(Diet v) {
    _diet = v;
    notifyListeners();
    unawaited(_prefs.setString('prefs.diet', v.name));
  }

  set servings(int v) {
    _servings = v;
    notifyListeners();
    unawaited(_prefs.setInt('prefs.servings', v));
  }

  set localeCode(String? v) {
    _localeCode = v;
    notifyListeners();
    unawaited(v == null ? _prefs.remove('prefs.locale') : _prefs.setString('prefs.locale', v));
  }

  set notifications(bool v) {
    _notifications = v;
    notifyListeners();
    unawaited(_prefs.setBool('prefs.notifications', v));
  }

  void finishOnboarding() {
    _onboarded = true;
    notifyListeners();
    unawaited(_prefs.setBool('prefs.onboarded', true));
  }
}

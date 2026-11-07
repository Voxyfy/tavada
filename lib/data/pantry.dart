import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının "mutfağımda var" dediği malzemeler. Telefonda kalıcı
/// tutulur ki her açılışta baştan seçmek gerekmesin.
class Pantry extends ChangeNotifier {
  Pantry(this._prefs) : _selected = {...?_prefs.getStringList(_key)};

  static const _key = 'pantry.selected';
  final SharedPreferences _prefs;
  final Set<String> _selected;

  Set<String> get selected => Set.unmodifiable(_selected);

  bool has(String id) => _selected.contains(id);

  void toggle(String id) {
    _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    notifyListeners();
    // Yazma hatası seçimi bozmaz; en kötü ihtimalle bir sonraki açılışta eski liste gelir.
    unawaited(_prefs.setStringList(_key, _selected.toList()));
  }
}

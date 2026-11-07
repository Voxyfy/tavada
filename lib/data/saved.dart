import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kaydedilen tarifler; telefonda kalıcı, hesap gerekmez. Pantry ile aynı kalıp.
class Saved extends ChangeNotifier {
  Saved(this._prefs) : _ids = {...?_prefs.getStringList(_key)};

  static const _key = 'saved.recipes';
  final SharedPreferences _prefs;
  final Set<String> _ids;

  Set<String> get ids => Set.unmodifiable(_ids);

  bool has(String id) => _ids.contains(id);

  void toggle(String id) {
    _ids.contains(id) ? _ids.remove(id) : _ids.add(id);
    notifyListeners();
    unawaited(_prefs.setStringList(_key, _ids.toList()));
  }
}

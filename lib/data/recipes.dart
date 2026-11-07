import 'dart:convert';

import 'package:flutter/services.dart';

/// Tarif kategorileri; sıralama ekrandaki filtre sırasıdır.
enum RecipeCategory { corba, ana, zeytinyagli, pilav, hamur, kahvalti, salata, tatli }

class RecipeIngredient {
  const RecipeIngredient(this.id, this.qty, {this.optional = false});

  final String id;

  /// Miktar metni (ör. "2 adet"). shortcut: yalnız Türkçe; İngilizce sürümde birimler çevrilecek.
  final String qty;

  /// İsteğe bağlı malzeme eksikse tarif yine "yapılabilir" sayılır.
  final bool optional;
}

class Substitute {
  const Substitute(this.id, this.note);

  final String id;
  final String note;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.tr,
    required this.en,
    required this.category,
    required this.minutes,
    required this.difficulty,
    required this.servings,
    required this.ingredients,
    required this.subs,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    id: j['id'] as String,
    tr: j['tr'] as String,
    en: j['en'] as String,
    category: RecipeCategory.values.byName(j['cat'] as String),
    minutes: j['min'] as int,
    difficulty: j['dif'] as int,
    servings: j['srv'] as int,
    // JSON'da her malzeme [id, miktar, isteğeBağlı?] üçlüsü; kısa tutmak için nesne değil dizi.
    ingredients: [
      for (final i in j['ing'] as List)
        RecipeIngredient(i[0] as String, i[1] as String, optional: (i as List).length > 2 && i[2] == 1),
    ],
    subs: {
      for (final e in ((j['subs'] as Map?) ?? const {}).entries)
        e.key as String: Substitute((e.value as List)[0] as String, (e.value as List)[1] as String),
    },
    steps: (j['steps'] as List).cast<String>(),
  );

  final String id;
  final String tr;
  final String en;
  final RecipeCategory category;
  final int minutes;

  /// 1 kolay, 2 orta, 3 zor.
  final int difficulty;
  final int servings;
  final List<RecipeIngredient> ingredients;

  /// Tarife özel alternatifler: eksik malzeme kimliği → yerine kullanılacak + not.
  final Map<String, Substitute> subs;

  /// shortcut: adımlar yalnız Türkçe; İngilizce çeviri D1'e geçince eklenecek.
  final List<String> steps;

  String name(String languageCode) => languageCode == 'tr' ? tr : en;
}

/// Gömülü tarif veri seti. shortcut: assets/data/recipes.json; D1 gelince ağdan çekilecek.
Future<List<Recipe>> loadRecipes() async {
  final raw = await rootBundle.loadString('assets/data/recipes.json');
  return [for (final j in jsonDecode(raw) as List) Recipe.fromJson(j as Map<String, dynamic>)];
}

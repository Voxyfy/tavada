/// Malzeme kataloğu. Kimlikler kalıcıdır (seçimler ve ileride tarif
/// veritabanı bunlarla eşleşir); adları değiştirmek serbest, kimliği değil.
enum IngredientGroup { vegetable, fruit, meat, dairy, grain, basic, herb }

class Ingredient {
  const Ingredient(this.id, this.group, this.tr, this.en);

  final String id;
  final IngredientGroup group;
  final String tr;
  final String en;

  String name(String languageCode) => languageCode == 'tr' ? tr : en;
}

// shortcut: katalog uygulamaya gömülü, tarif veritabanı (D1) gelince oradan çekilecek.
// Sıra ekrandaki sırayı belirler: her grupta en sık kullanılanlar başta.
const ingredients = <Ingredient>[
  // Sebze
  Ingredient('tomato', IngredientGroup.vegetable, 'Domates', 'Tomato'),
  Ingredient('onion', IngredientGroup.vegetable, 'Soğan', 'Onion'),
  Ingredient('pepper', IngredientGroup.vegetable, 'Biber', 'Pepper'),
  Ingredient('potato', IngredientGroup.vegetable, 'Patates', 'Potato'),
  Ingredient('eggplant', IngredientGroup.vegetable, 'Patlıcan', 'Eggplant'),
  Ingredient('garlic', IngredientGroup.vegetable, 'Sarımsak', 'Garlic'),
  Ingredient('zucchini', IngredientGroup.vegetable, 'Kabak', 'Zucchini'),
  Ingredient('carrot', IngredientGroup.vegetable, 'Havuç', 'Carrot'),
  Ingredient('spinach', IngredientGroup.vegetable, 'Ispanak', 'Spinach'),
  Ingredient('cucumber', IngredientGroup.vegetable, 'Salatalık', 'Cucumber'),
  Ingredient('leek', IngredientGroup.vegetable, 'Pırasa', 'Leek'),
  Ingredient('cabbage', IngredientGroup.vegetable, 'Lahana', 'Cabbage'),
  Ingredient('cauliflower', IngredientGroup.vegetable, 'Karnabahar', 'Cauliflower'),
  Ingredient('broccoli', IngredientGroup.vegetable, 'Brokoli', 'Broccoli'),
  Ingredient('green_beans', IngredientGroup.vegetable, 'Taze fasulye', 'Green beans'),
  Ingredient('peas', IngredientGroup.vegetable, 'Bezelye', 'Peas'),
  Ingredient('mushroom', IngredientGroup.vegetable, 'Mantar', 'Mushroom'),
  Ingredient('corn', IngredientGroup.vegetable, 'Mısır', 'Corn'),
  Ingredient('celeriac', IngredientGroup.vegetable, 'Kereviz', 'Celeriac'),
  Ingredient('artichoke', IngredientGroup.vegetable, 'Enginar', 'Artichoke'),
  Ingredient('okra', IngredientGroup.vegetable, 'Bamya', 'Okra'),
  Ingredient('purslane', IngredientGroup.vegetable, 'Semizotu', 'Purslane'),
  Ingredient('chard', IngredientGroup.vegetable, 'Pazı', 'Chard'),
  Ingredient('lettuce', IngredientGroup.vegetable, 'Marul', 'Lettuce'),
  Ingredient('pumpkin', IngredientGroup.vegetable, 'Bal kabağı', 'Pumpkin'),
  Ingredient('vine_leaves', IngredientGroup.vegetable, 'Asma yaprağı', 'Vine leaves'),
  // Meyve
  Ingredient('lemon', IngredientGroup.fruit, 'Limon', 'Lemon'),
  Ingredient('apple', IngredientGroup.fruit, 'Elma', 'Apple'),
  Ingredient('banana', IngredientGroup.fruit, 'Muz', 'Banana'),
  Ingredient('orange', IngredientGroup.fruit, 'Portakal', 'Orange'),
  Ingredient('quince', IngredientGroup.fruit, 'Ayva', 'Quince'),
  Ingredient('pomegranate', IngredientGroup.fruit, 'Nar', 'Pomegranate'),
  Ingredient('grapes', IngredientGroup.fruit, 'Üzüm', 'Grapes'),
  Ingredient('strawberry', IngredientGroup.fruit, 'Çilek', 'Strawberry'),
  Ingredient('dried_apricot', IngredientGroup.fruit, 'Kuru kayısı', 'Dried apricot'),
  Ingredient('walnut', IngredientGroup.fruit, 'Ceviz', 'Walnut'),
  Ingredient('hazelnut', IngredientGroup.fruit, 'Fındık', 'Hazelnut'),
  Ingredient('almond', IngredientGroup.fruit, 'Badem', 'Almond'),
  // Et, tavuk, balık
  Ingredient('ground_meat', IngredientGroup.meat, 'Kıyma', 'Ground meat'),
  Ingredient('chicken', IngredientGroup.meat, 'Tavuk', 'Chicken'),
  Ingredient('beef_cubes', IngredientGroup.meat, 'Kuşbaşı', 'Beef cubes'),
  Ingredient('lamb', IngredientGroup.meat, 'Kuzu eti', 'Lamb'),
  Ingredient('sucuk', IngredientGroup.meat, 'Sucuk', 'Sucuk'),
  Ingredient('pastirma', IngredientGroup.meat, 'Pastırma', 'Pastırma'),
  Ingredient('salami', IngredientGroup.meat, 'Salam', 'Salami'),
  Ingredient('fish', IngredientGroup.meat, 'Balık', 'Fish'),
  Ingredient('tuna', IngredientGroup.meat, 'Ton balığı', 'Tuna'),
  Ingredient('shrimp', IngredientGroup.meat, 'Karides', 'Shrimp'),
  Ingredient('liver', IngredientGroup.meat, 'Ciğer', 'Liver'),
  // Süt ürünleri ve yumurta
  Ingredient('egg', IngredientGroup.dairy, 'Yumurta', 'Egg'),
  Ingredient('yogurt', IngredientGroup.dairy, 'Yoğurt', 'Yogurt'),
  Ingredient('milk', IngredientGroup.dairy, 'Süt', 'Milk'),
  Ingredient('feta', IngredientGroup.dairy, 'Peynir', 'Feta cheese'),
  Ingredient('kashar', IngredientGroup.dairy, 'Kaşar', 'Kashar cheese'),
  Ingredient('cream_cheese', IngredientGroup.dairy, 'Labne', 'Cream cheese'),
  Ingredient('cream', IngredientGroup.dairy, 'Krema', 'Cream'),
  Ingredient('butter', IngredientGroup.dairy, 'Tereyağı', 'Butter'),
  Ingredient('kaymak', IngredientGroup.dairy, 'Kaymak', 'Kaymak'),
  Ingredient('tulum', IngredientGroup.dairy, 'Tulum peyniri', 'Tulum cheese'),
  // Tahıl ve bakliyat
  Ingredient('rice', IngredientGroup.grain, 'Pirinç', 'Rice'),
  Ingredient('bulgur', IngredientGroup.grain, 'Bulgur', 'Bulgur'),
  Ingredient('pasta', IngredientGroup.grain, 'Makarna', 'Pasta'),
  Ingredient('noodles', IngredientGroup.grain, 'Erişte', 'Noodles'),
  Ingredient('vermicelli', IngredientGroup.grain, 'Şehriye', 'Vermicelli'),
  Ingredient('red_lentil', IngredientGroup.grain, 'Mercimek', 'Red lentils'),
  Ingredient('green_lentil', IngredientGroup.grain, 'Yeşil mercimek', 'Green lentils'),
  Ingredient('chickpea', IngredientGroup.grain, 'Nohut', 'Chickpeas'),
  Ingredient('dry_beans', IngredientGroup.grain, 'Kuru fasulye', 'Dry beans'),
  Ingredient('couscous', IngredientGroup.grain, 'Kuskus', 'Couscous'),
  Ingredient('oats', IngredientGroup.grain, 'Yulaf', 'Oats'),
  Ingredient('bread', IngredientGroup.grain, 'Ekmek', 'Bread'),
  Ingredient('phyllo', IngredientGroup.grain, 'Yufka', 'Phyllo'),
  Ingredient('lavash', IngredientGroup.grain, 'Lavaş', 'Lavash'),
  // Temel (kiler)
  Ingredient('flour', IngredientGroup.basic, 'Un', 'Flour'),
  Ingredient('olive_oil', IngredientGroup.basic, 'Zeytinyağı', 'Olive oil'),
  Ingredient('sunflower_oil', IngredientGroup.basic, 'Sıvı yağ', 'Sunflower oil'),
  Ingredient('tomato_paste', IngredientGroup.basic, 'Salça', 'Tomato paste'),
  Ingredient('pepper_paste', IngredientGroup.basic, 'Biber salçası', 'Pepper paste'),
  Ingredient('sugar', IngredientGroup.basic, 'Şeker', 'Sugar'),
  Ingredient('semolina', IngredientGroup.basic, 'İrmik', 'Semolina'),
  Ingredient('starch', IngredientGroup.basic, 'Nişasta', 'Starch'),
  Ingredient('vinegar', IngredientGroup.basic, 'Sirke', 'Vinegar'),
  Ingredient('pomegranate_syrup', IngredientGroup.basic, 'Nar ekşisi', 'Pomegranate molasses'),
  Ingredient('honey', IngredientGroup.basic, 'Bal', 'Honey'),
  Ingredient('tahini', IngredientGroup.basic, 'Tahin', 'Tahini'),
  Ingredient('molasses', IngredientGroup.basic, 'Pekmez', 'Grape molasses'),
  Ingredient('olives', IngredientGroup.basic, 'Zeytin', 'Olives'),
  Ingredient('pickles', IngredientGroup.basic, 'Turşu', 'Pickles'),
  Ingredient('canned_tomato', IngredientGroup.basic, 'Konserve domates', 'Canned tomatoes'),
  Ingredient('baking_powder', IngredientGroup.basic, 'Kabartma tozu', 'Baking powder'),
  Ingredient('yeast', IngredientGroup.basic, 'Maya', 'Yeast'),
  Ingredient('tarhana', IngredientGroup.basic, 'Tarhana', 'Tarhana'),
  // Ot ve baharat (tuz, karabiber varsayılan; listede değil)
  Ingredient('parsley', IngredientGroup.herb, 'Maydanoz', 'Parsley'),
  Ingredient('dill', IngredientGroup.herb, 'Dereotu', 'Dill'),
  Ingredient('mint', IngredientGroup.herb, 'Nane', 'Mint'),
  Ingredient('spring_onion', IngredientGroup.herb, 'Taze soğan', 'Spring onion'),
  Ingredient('red_pepper_flakes', IngredientGroup.herb, 'Pul biber', 'Red pepper flakes'),
  Ingredient('cumin', IngredientGroup.herb, 'Kimyon', 'Cumin'),
  Ingredient('paprika', IngredientGroup.herb, 'Toz biber', 'Paprika'),
  Ingredient('thyme', IngredientGroup.herb, 'Kekik', 'Thyme'),
  Ingredient('sumac', IngredientGroup.herb, 'Sumak', 'Sumac'),
  Ingredient('cinnamon', IngredientGroup.herb, 'Tarçın', 'Cinnamon'),
  Ingredient('bay_leaf', IngredientGroup.herb, 'Defne yaprağı', 'Bay leaf'),
];

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Tavada';

  @override
  String get kitchenTitle => 'Mutfağınızda\nne var?';

  @override
  String get kitchenSubtitle => 'Seçin, gerisini biz halledelim.';

  @override
  String get searchHint => 'Malzeme arayın';

  @override
  String get groupVegetable => 'Sebze';

  @override
  String get groupFruit => 'Meyve ve kuruyemiş';

  @override
  String get groupMeat => 'Et, tavuk, balık';

  @override
  String get groupDairy => 'Süt ürünleri ve yumurta';

  @override
  String get groupGrain => 'Tahıl ve bakliyat';

  @override
  String get groupBasic => 'Kiler';

  @override
  String get groupHerb => 'Ot ve baharat';

  @override
  String selectedCount(int count) {
    return '$count malzeme';
  }

  @override
  String selectedMore(int count) {
    return '+$count';
  }

  @override
  String get nothingSelected => 'Malzeme seçin';

  @override
  String get noSearchResult => 'Bu adla bir malzeme bulamadık.';

  @override
  String showMore(int count) {
    return '+$count daha';
  }

  @override
  String get done => 'Tamam';

  @override
  String get prepare => 'Hazırla';

  @override
  String suggestionsTitle(int ingredients, int recipes) {
    return '$ingredients malzemeden\n$recipes yemek çıktı';
  }

  @override
  String suggestionsSubtitle(int complete, int missing) {
    return '$complete tanesi hemen yapılır, $missing tanesinde tek eksik var.';
  }

  @override
  String get suggestionsAllComplete => 'Hepsi hemen yapılır.';

  @override
  String get suggestionsAllMissing => 'Hepsinde tek bir eksik var.';

  @override
  String get noSuggestionsTitle => 'Bu malzemelerle tarif bulamadık';

  @override
  String get noSuggestionsBody => 'Bir iki malzeme daha eklemeyi deneyin.';

  @override
  String get filterAll => 'Hepsi';

  @override
  String get filterComplete => 'Eksiksiz';

  @override
  String get filterQuick => '30 dk altı';

  @override
  String get badgeComplete => 'Hepsi var';

  @override
  String get badgeMissing => '1 eksik';

  @override
  String swapRow(String missing, String sub) {
    return '$missing yerine $sub';
  }

  @override
  String missingRow(String missing) {
    return '$missing eksik';
  }

  @override
  String recipeMeta(int minutes, String difficulty, int servings) {
    return '$minutes dk · $difficulty · $servings kişilik';
  }

  @override
  String get difficultyEasy => 'Kolay';

  @override
  String get difficultyMedium => 'Orta';

  @override
  String get difficultyHard => 'Zor';

  @override
  String get back => 'Geri';

  @override
  String get filters => 'Filtreler';

  @override
  String get tabIngredients => 'Malzemeler';

  @override
  String tabSteps(int count) {
    return 'Yapılışı · $count adım';
  }

  @override
  String get optionalTag => 'isteğe bağlı';

  @override
  String get haveIt => 'Sizde var';

  @override
  String get dontHaveIt => 'Sizde yok';

  @override
  String swapArrow(String missing, String sub) {
    return '$missing → $sub';
  }

  @override
  String stepOf(int step, int total) {
    return 'Adım $step / $total';
  }

  @override
  String get previous => 'Önceki';

  @override
  String get next => 'Sonraki';

  @override
  String get finishCooking => 'Bitti, afiyet olsun';

  @override
  String get timerStart => 'Başlat';

  @override
  String get timerPause => 'Duraklat';

  @override
  String get timerResume => 'Devam';

  @override
  String get timerPlusMinute => '+1 dk';

  @override
  String get timerDone => 'Süre doldu';

  @override
  String get close => 'Kapat';

  @override
  String get enjoyTitle => 'Afiyet olsun!';

  @override
  String get savedLabel => 'Kaydedildi';

  @override
  String get backToRecipe => 'Tarife dön';

  @override
  String get tabKitchen => 'Mutfağım';

  @override
  String get tabSaved => 'Kayıtlılar';

  @override
  String get tabSettings => 'Ayarlar';

  @override
  String get savedEmptyTitle => 'Kaydettiğiniz tarifler burada görünür';

  @override
  String get savedEmptyBody =>
      'Beğendiğiniz tarifi yer imiyle kaydedin, pişirirken elinizin altında olsun.';

  @override
  String get goToKitchen => 'Mutfağıma git';

  @override
  String minutesShort(int minutes) {
    return '$minutes dk';
  }

  @override
  String get settingsDiet => 'Beslenme tercihi';

  @override
  String get settingsServings => 'Kişi sayısı';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsNotifications => 'Bildirimler';

  @override
  String get settingsPrivacy => 'Gizlilik';

  @override
  String get settingsContact => 'Bize ulaşın';

  @override
  String settingsVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get dietAll => 'Hepsi';

  @override
  String get dietVegetarian => 'Vejetaryen';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietHint =>
      'Önerilerde et, tavuk ve balık içeren tarifler elenir; vegan seçilirse yumurta, süt ürünleri ve bal da.';

  @override
  String get servingsHint =>
      'Şimdilik yalnız kaydediliyor; miktarları buna göre ölçeklemek yakında.';

  @override
  String get servingsFive => '5+';

  @override
  String get languageSystem => 'Cihaz dili';

  @override
  String get notificationsHint =>
      'Zamanlayıcı dolunca ve haftalık öneriler için.';

  @override
  String get contactSubject => 'Tavada hakkında';

  @override
  String get couldNotOpen => 'Açılamadı.';

  @override
  String get onbTitle1 => 'Evdekiyle ne pişer?';

  @override
  String get onbBody1 =>
      'Mutfağınızdakileri seçin, size uygun Türk yemeklerini bulalım.';

  @override
  String get onbTitle2 => 'Eksik mi var? Sorun değil.';

  @override
  String get onbBody2 =>
      'Bir malzeme eksikse yerine ne kullanacağınızı söyleriz.';

  @override
  String get onbTitle3 => 'Sizi biraz tanıyalım';

  @override
  String get onbBody3 => 'Önerileri buna göre ayarlayacağız.';

  @override
  String get onbStart => 'Başlayalım';

  @override
  String get onbContinue => 'Devam';

  @override
  String get onbSkip => 'Atla';

  @override
  String get onbSkipForNow => 'Şimdilik geç';

  @override
  String get onbGoKitchen => 'Mutfağıma geç';

  @override
  String get onbDietLabel => 'Beslenme';

  @override
  String get onbServingsLabel => 'Kaç kişisiniz?';

  @override
  String get startCooking => 'Pişirmeye başla';

  @override
  String get save => 'Kaydet';

  @override
  String get cookingComingNext => 'Pişirme modu sıradaki adımda geliyor.';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Tavada'**
  String get appName;

  /// No description provided for @kitchenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mutfağınızda\nne var?'**
  String get kitchenTitle;

  /// No description provided for @kitchenSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Seçin, gerisini biz halledelim.'**
  String get kitchenSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Malzeme arayın'**
  String get searchHint;

  /// No description provided for @groupVegetable.
  ///
  /// In tr, this message translates to:
  /// **'Sebze'**
  String get groupVegetable;

  /// No description provided for @groupFruit.
  ///
  /// In tr, this message translates to:
  /// **'Meyve ve kuruyemiş'**
  String get groupFruit;

  /// No description provided for @groupMeat.
  ///
  /// In tr, this message translates to:
  /// **'Et, tavuk, balık'**
  String get groupMeat;

  /// No description provided for @groupDairy.
  ///
  /// In tr, this message translates to:
  /// **'Süt ürünleri ve yumurta'**
  String get groupDairy;

  /// No description provided for @groupGrain.
  ///
  /// In tr, this message translates to:
  /// **'Tahıl ve bakliyat'**
  String get groupGrain;

  /// No description provided for @groupBasic.
  ///
  /// In tr, this message translates to:
  /// **'Kiler'**
  String get groupBasic;

  /// No description provided for @groupHerb.
  ///
  /// In tr, this message translates to:
  /// **'Ot ve baharat'**
  String get groupHerb;

  /// No description provided for @selectedCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} malzeme'**
  String selectedCount(int count);

  /// No description provided for @selectedMore.
  ///
  /// In tr, this message translates to:
  /// **'+{count}'**
  String selectedMore(int count);

  /// No description provided for @nothingSelected.
  ///
  /// In tr, this message translates to:
  /// **'Malzeme seçin'**
  String get nothingSelected;

  /// No description provided for @noSearchResult.
  ///
  /// In tr, this message translates to:
  /// **'Bu adla bir malzeme bulamadık.'**
  String get noSearchResult;

  /// No description provided for @showMore.
  ///
  /// In tr, this message translates to:
  /// **'+{count} daha'**
  String showMore(int count);

  /// No description provided for @done.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get done;

  /// No description provided for @prepare.
  ///
  /// In tr, this message translates to:
  /// **'Hazırla'**
  String get prepare;

  /// No description provided for @suggestionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'{ingredients} malzemeden\n{recipes} yemek çıktı'**
  String suggestionsTitle(int ingredients, int recipes);

  /// No description provided for @suggestionsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'{complete} tanesi hemen yapılır, {missing} tanesinde tek eksik var.'**
  String suggestionsSubtitle(int complete, int missing);

  /// No description provided for @suggestionsAllComplete.
  ///
  /// In tr, this message translates to:
  /// **'Hepsi hemen yapılır.'**
  String get suggestionsAllComplete;

  /// No description provided for @suggestionsAllMissing.
  ///
  /// In tr, this message translates to:
  /// **'Hepsinde tek bir eksik var.'**
  String get suggestionsAllMissing;

  /// No description provided for @noSuggestionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu malzemelerle tarif bulamadık'**
  String get noSuggestionsTitle;

  /// No description provided for @noSuggestionsBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir iki malzeme daha eklemeyi deneyin.'**
  String get noSuggestionsBody;

  /// No description provided for @filterAll.
  ///
  /// In tr, this message translates to:
  /// **'Hepsi'**
  String get filterAll;

  /// No description provided for @filterComplete.
  ///
  /// In tr, this message translates to:
  /// **'Eksiksiz'**
  String get filterComplete;

  /// No description provided for @filterQuick.
  ///
  /// In tr, this message translates to:
  /// **'30 dk altı'**
  String get filterQuick;

  /// No description provided for @badgeComplete.
  ///
  /// In tr, this message translates to:
  /// **'Hepsi var'**
  String get badgeComplete;

  /// No description provided for @badgeMissing.
  ///
  /// In tr, this message translates to:
  /// **'1 eksik'**
  String get badgeMissing;

  /// No description provided for @swapRow.
  ///
  /// In tr, this message translates to:
  /// **'{missing} yerine {sub}'**
  String swapRow(String missing, String sub);

  /// No description provided for @missingRow.
  ///
  /// In tr, this message translates to:
  /// **'{missing} eksik'**
  String missingRow(String missing);

  /// No description provided for @recipeMeta.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk · {difficulty} · {servings} kişilik'**
  String recipeMeta(int minutes, String difficulty, int servings);

  /// No description provided for @difficultyEasy.
  ///
  /// In tr, this message translates to:
  /// **'Kolay'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In tr, this message translates to:
  /// **'Zor'**
  String get difficultyHard;

  /// No description provided for @back.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// No description provided for @filters.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get filters;

  /// No description provided for @tabIngredients.
  ///
  /// In tr, this message translates to:
  /// **'Malzemeler'**
  String get tabIngredients;

  /// No description provided for @tabSteps.
  ///
  /// In tr, this message translates to:
  /// **'Yapılışı · {count} adım'**
  String tabSteps(int count);

  /// No description provided for @optionalTag.
  ///
  /// In tr, this message translates to:
  /// **'isteğe bağlı'**
  String get optionalTag;

  /// No description provided for @haveIt.
  ///
  /// In tr, this message translates to:
  /// **'Sizde var'**
  String get haveIt;

  /// No description provided for @dontHaveIt.
  ///
  /// In tr, this message translates to:
  /// **'Sizde yok'**
  String get dontHaveIt;

  /// No description provided for @swapArrow.
  ///
  /// In tr, this message translates to:
  /// **'{missing} → {sub}'**
  String swapArrow(String missing, String sub);

  /// No description provided for @stepOf.
  ///
  /// In tr, this message translates to:
  /// **'Adım {step} / {total}'**
  String stepOf(int step, int total);

  /// No description provided for @previous.
  ///
  /// In tr, this message translates to:
  /// **'Önceki'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki'**
  String get next;

  /// No description provided for @finishCooking.
  ///
  /// In tr, this message translates to:
  /// **'Bitti, afiyet olsun'**
  String get finishCooking;

  /// No description provided for @timerStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlat'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In tr, this message translates to:
  /// **'Duraklat'**
  String get timerPause;

  /// No description provided for @timerResume.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get timerResume;

  /// No description provided for @timerPlusMinute.
  ///
  /// In tr, this message translates to:
  /// **'+1 dk'**
  String get timerPlusMinute;

  /// No description provided for @timerDone.
  ///
  /// In tr, this message translates to:
  /// **'Süre doldu'**
  String get timerDone;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @enjoyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Afiyet olsun!'**
  String get enjoyTitle;

  /// No description provided for @savedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi'**
  String get savedLabel;

  /// No description provided for @backToRecipe.
  ///
  /// In tr, this message translates to:
  /// **'Tarife dön'**
  String get backToRecipe;

  /// No description provided for @tabKitchen.
  ///
  /// In tr, this message translates to:
  /// **'Mutfağım'**
  String get tabKitchen;

  /// No description provided for @tabSaved.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlılar'**
  String get tabSaved;

  /// No description provided for @tabSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get tabSettings;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydettiğiniz tarifler burada görünür'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Beğendiğiniz tarifi yer imiyle kaydedin, pişirirken elinizin altında olsun.'**
  String get savedEmptyBody;

  /// No description provided for @goToKitchen.
  ///
  /// In tr, this message translates to:
  /// **'Mutfağıma git'**
  String get goToKitchen;

  /// No description provided for @minutesShort.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk'**
  String minutesShort(int minutes);

  /// No description provided for @settingsDiet.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme tercihi'**
  String get settingsDiet;

  /// No description provided for @settingsServings.
  ///
  /// In tr, this message translates to:
  /// **'Kişi sayısı'**
  String get settingsServings;

  /// No description provided for @settingsLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get settingsNotifications;

  /// No description provided for @settingsPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik'**
  String get settingsPrivacy;

  /// No description provided for @settingsContact.
  ///
  /// In tr, this message translates to:
  /// **'Bize ulaşın'**
  String get settingsContact;

  /// No description provided for @settingsVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version}'**
  String settingsVersion(String version);

  /// No description provided for @dietAll.
  ///
  /// In tr, this message translates to:
  /// **'Hepsi'**
  String get dietAll;

  /// No description provided for @dietVegetarian.
  ///
  /// In tr, this message translates to:
  /// **'Vejetaryen'**
  String get dietVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In tr, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietHint.
  ///
  /// In tr, this message translates to:
  /// **'Önerilerde et, tavuk ve balık içeren tarifler elenir; vegan seçilirse yumurta, süt ürünleri ve bal da.'**
  String get dietHint;

  /// No description provided for @servingsHint.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik yalnız kaydediliyor; miktarları buna göre ölçeklemek yakında.'**
  String get servingsHint;

  /// No description provided for @servingsFive.
  ///
  /// In tr, this message translates to:
  /// **'5+'**
  String get servingsFive;

  /// No description provided for @languageSystem.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz dili'**
  String get languageSystem;

  /// No description provided for @notificationsHint.
  ///
  /// In tr, this message translates to:
  /// **'Zamanlayıcı dolunca ve haftalık öneriler için.'**
  String get notificationsHint;

  /// No description provided for @contactSubject.
  ///
  /// In tr, this message translates to:
  /// **'Tavada hakkında'**
  String get contactSubject;

  /// No description provided for @couldNotOpen.
  ///
  /// In tr, this message translates to:
  /// **'Açılamadı.'**
  String get couldNotOpen;

  /// No description provided for @onbTitle1.
  ///
  /// In tr, this message translates to:
  /// **'Evdekiyle ne pişer?'**
  String get onbTitle1;

  /// No description provided for @onbBody1.
  ///
  /// In tr, this message translates to:
  /// **'Mutfağınızdakileri seçin, size uygun Türk yemeklerini bulalım.'**
  String get onbBody1;

  /// No description provided for @onbTitle2.
  ///
  /// In tr, this message translates to:
  /// **'Eksik mi var? Sorun değil.'**
  String get onbTitle2;

  /// No description provided for @onbBody2.
  ///
  /// In tr, this message translates to:
  /// **'Bir malzeme eksikse yerine ne kullanacağınızı söyleriz.'**
  String get onbBody2;

  /// No description provided for @onbTitle3.
  ///
  /// In tr, this message translates to:
  /// **'Sizi biraz tanıyalım'**
  String get onbTitle3;

  /// No description provided for @onbBody3.
  ///
  /// In tr, this message translates to:
  /// **'Önerileri buna göre ayarlayacağız.'**
  String get onbBody3;

  /// No description provided for @onbStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlayalım'**
  String get onbStart;

  /// No description provided for @onbContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get onbContinue;

  /// No description provided for @onbSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onbSkip;

  /// No description provided for @onbSkipForNow.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik geç'**
  String get onbSkipForNow;

  /// No description provided for @onbGoKitchen.
  ///
  /// In tr, this message translates to:
  /// **'Mutfağıma geç'**
  String get onbGoKitchen;

  /// No description provided for @onbDietLabel.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme'**
  String get onbDietLabel;

  /// No description provided for @onbServingsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaç kişisiniz?'**
  String get onbServingsLabel;

  /// No description provided for @startCooking.
  ///
  /// In tr, this message translates to:
  /// **'Pişirmeye başla'**
  String get startCooking;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @cookingComingNext.
  ///
  /// In tr, this message translates to:
  /// **'Pişirme modu sıradaki adımda geliyor.'**
  String get cookingComingNext;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

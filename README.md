# Tavada

Mutfağınızdakileri seçin, Tavada size uygun Türk yemeğini bulsun. Bir malzeme eksikse yerine ne kullanacağınızı söyler; "Pişirmeye başla" deyince adım adım, zamanlayıcıyla eşlik eder.

Flutter ile yazılmış iPhone uygulaması (yalnız iOS; `android/` klasörü bilerek yok, gerekirse `flutter create --platforms android .` ile geri gelir). Hesap yok, internet yok, veri toplanmıyor; 187 tarif ve bütün görseller uygulamanın içinde gelir.

*Pick what's in your kitchen and Tavada finds the Turkish dish that fits. If one ingredient is missing it tells you what to use instead, then walks you through the steps with a timer. Flutter app for iPhone; no account, no network, no data collection.*

## Ekranlar

| Ekran | Ne yapar |
|---|---|
| **Mutfağım** | 103 malzeme, 7 grup, kil ikonlu çipler; arama Türkçe harflere duyarlı. 3 malzeme seçilince "Hazırla" hapı gelir. |
| **Öneriler** | Eşleşen tarifler: önce eksiksizler, sonra tek eksiği alternatifle kapananlar. Filtreler: Hepsi / Eksiksiz / 30 dk altı. |
| **Tarif** | Malzemeler (eldekiler tikli, eksik olan sarı kutuda alternatifiyle) ve zaman çizgisi hâlinde yapılış. Miktarlar kişi sayısına göre ölçeklenir. |
| **Pişirme modu** | Tek adım, büyük yazı; süreli adımda geri sayım, süresiz adımda şefin o işi yaptığı sahne. Ekran kapanmaz. |
| **Kayıtlılar** | Yer imiyle kaydedilen tarifler. |
| **Ayarlar** | Beslenme tercihi (vejetaryen/vegan önerileri eler), kişi sayısı, dil (TR/EN), gizlilik, iletişim. |

## Nasıl çalışır

- **Eşleştirme kodla yapılır**, yapay zekâ yok: `lib/domain/matcher.dart`. Tarifin zorunlu malzemeleri dolapla karşılaştırılır; 0 eksik → 1 eksik (alternatifi eldeyse önce) sıralanır, 2 ve üzeri eksik elenir. Tuz ve karabiber her evde var sayılır.
- **Alternatifler iki katmanlı:** tarife özel (`subs`, ör. "İzmir köftede patates yerine patlıcan") ve genel tablo (`globalSubs`, ör. tereyağı → zeytinyağı). Tarife özel olan önce denenir.
- **Adım → eylem:** `lib/domain/step_action.dart` adım cümlesindeki son fiile bakıp 24 şef sahnesinden birini seçer; `step_duration.dart` "35 dakika", "1 saat", "3-4 dakika" gibi süreleri zamanlayıcıya çevirir.
- **Veri:** `assets/data/recipes.json` (187 tarif, 8 kategori). Her malzeme `[id, miktar, isteğeBağlı?]`; kimlikler `lib/data/ingredients.dart` kataloğuyla eşleşir. Testler kimliklerin tekil ve kataloğa uygun olduğunu doğrular.
- **Tercihler** `shared_preferences` ile telefonda tutulur (`lib/data/pantry.dart`, `saved.dart`, `prefs.dart`).

## Görsel dil

Her şey kil minyatür diorama: malzeme ikonları, 187 yemek görseli, 24 şef eylem sahnesi, ekran başlıkları ve uygulama ikonu. Zemin her yerde `#F5EFE6`; vurgu rengi `#C2410C` yalnızca ana düğmede. Yazı tipleri Bricolage Grotesque (başlık) ve Inter (gövde), ikonlar [Hugeicons](https://hugeicons.com).

Görseller üretken modellerle sayfa sayfa üretilip kare kare kesilir; zemin her görselde uygulama kremine eşitlenir. Kaynak sayfalar ve kesim betikleri depoda değildir; yeni malzeme ya da tarif eklerken aynı stil kurallarıyla (ilgili sayfa, aynı sıra, aynı ışık) üretilip `assets/images/` altındaki adlandırmayla konur: `ingredients/<malzeme_id>.png`, `dishes/<tarif_id>.jpg`, `actions/<eylem>.jpg`.

## Geliştirme

```sh
flutter pub get
flutter gen-l10n          # lib/l10n/*.arb → AppLocalizations
flutter analyze
flutter test              # 20 test; tarif verisini, eşleştirmeyi ve ekran akışlarını kapsar
```

- Dil dosyaları `lib/l10n/app_tr.arb` ve `app_en.arb`; yeni metin ikisine de eklenir. Tarif miktarları ve adımlar şimdilik yalnız Türkçe.
- Kod yorumları Türkçe, tanımlayıcılar İngilizce.
- Xcode 27'de `flutter run` simülatörde çalışmıyor; `flutter build ios --simulator --config-only` sonrası `xcodebuild ... ARCHS=arm64` ile derleyip `xcrun simctl install` ile kurun. Yeni derleme eski Dart paketini kullanıyorsa uygulamayı simülatörden kaldırıp yeniden kurun.
- Testlerde `loadRecipes()` yalnızca `setUpAll` içinde çağrılır; `testWidgets` gövdesinde sahte zaman yüzünden takılır.

### Uygulama ikonu ve mağaza görselleri

```sh
dart run flutter_launcher_icons                                       # assets/icon/icon.png → iOS ikon seti
flutter test --dart-define=SHOTS=true --update-goldens test/shots_test.dart   # design/store/01..04.png (1206×2622)
```

Mağaza görselleri gerçek ekranların başlıklı kartlara yerleştirilmiş hâlidir; ekran değişince aynı komutla yenilenir (çıktı klasörü depoda değildir). iOS hedefi yalnız iPhone, dikey.

## Gizlilik

Uygulama veri toplamaz; politika metni `docs/privacy.html` (TR + EN), GitHub Pages ile yayınlanır.

## Lisans ve iletişim

© 2026 Batuhan Haymana · haymana.batuhan@gmail.com

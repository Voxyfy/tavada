// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tavada';

  @override
  String get kitchenTitle => 'What\'s in\nyour kitchen?';

  @override
  String get kitchenSubtitle => 'Pick, and leave the rest to us.';

  @override
  String get searchHint => 'Search ingredients';

  @override
  String get groupVegetable => 'Vegetables';

  @override
  String get groupFruit => 'Fruit & nuts';

  @override
  String get groupMeat => 'Meat, poultry, fish';

  @override
  String get groupDairy => 'Dairy & eggs';

  @override
  String get groupGrain => 'Grains & legumes';

  @override
  String get groupBasic => 'Pantry';

  @override
  String get groupHerb => 'Herbs & spices';

  @override
  String selectedCount(int count) {
    return '$count ingredients';
  }

  @override
  String selectedMore(int count) {
    return '+$count';
  }

  @override
  String get nothingSelected => 'Pick ingredients';

  @override
  String get noSearchResult => 'No ingredient by that name.';

  @override
  String showMore(int count) {
    return '+$count more';
  }

  @override
  String get done => 'Done';

  @override
  String get prepare => 'Cook';

  @override
  String suggestionsTitle(int ingredients, int recipes) {
    return '$recipes dishes from\n$ingredients ingredients';
  }

  @override
  String suggestionsSubtitle(int complete, int missing) {
    return '$complete ready to cook, $missing missing just one thing.';
  }

  @override
  String get suggestionsAllComplete => 'All ready to cook.';

  @override
  String get suggestionsAllMissing => 'Each is missing just one thing.';

  @override
  String get noSuggestionsTitle => 'No recipes for these ingredients';

  @override
  String get noSuggestionsBody => 'Try adding one or two more.';

  @override
  String get filterAll => 'All';

  @override
  String get filterComplete => 'Complete';

  @override
  String get filterQuick => 'Under 30 min';

  @override
  String get badgeComplete => 'All set';

  @override
  String get badgeMissing => '1 missing';

  @override
  String swapRow(String missing, String sub) {
    return '$sub instead of $missing';
  }

  @override
  String missingRow(String missing) {
    return '$missing missing';
  }

  @override
  String recipeMeta(int minutes, String difficulty, int servings) {
    return '$minutes min · $difficulty · serves $servings';
  }

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get back => 'Back';

  @override
  String get filters => 'Filters';

  @override
  String get tabIngredients => 'Ingredients';

  @override
  String tabSteps(int count) {
    return 'Steps · $count';
  }

  @override
  String get optionalTag => 'optional';

  @override
  String get haveIt => 'You have it';

  @override
  String get dontHaveIt => 'You don\'t have it';

  @override
  String swapArrow(String missing, String sub) {
    return '$missing → $sub';
  }

  @override
  String stepOf(int step, int total) {
    return 'Step $step / $total';
  }

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get finishCooking => 'Done, enjoy!';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerPlusMinute => '+1 min';

  @override
  String get timerDone => 'Time\'s up';

  @override
  String get close => 'Close';

  @override
  String get enjoyTitle => 'Enjoy your meal!';

  @override
  String get savedLabel => 'Saved';

  @override
  String get backToRecipe => 'Back to recipe';

  @override
  String get tabKitchen => 'My kitchen';

  @override
  String get tabSaved => 'Saved';

  @override
  String get tabSettings => 'Settings';

  @override
  String get savedEmptyTitle => 'Recipes you save show up here';

  @override
  String get savedEmptyBody =>
      'Bookmark a recipe you like so it\'s at hand while cooking.';

  @override
  String get goToKitchen => 'Go to my kitchen';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDiet => 'Diet';

  @override
  String get settingsServings => 'Servings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsContact => 'Contact us';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get dietAll => 'Everything';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietHint =>
      'Recipes with meat, poultry or fish are left out; vegan also leaves out eggs, dairy and honey.';

  @override
  String get servingsHint =>
      'Saved only for now; scaling quantities is coming soon.';

  @override
  String get servingsFive => '5+';

  @override
  String get languageSystem => 'Device language';

  @override
  String get notificationsHint => 'For timer alerts and weekly suggestions.';

  @override
  String get contactSubject => 'About Tavada';

  @override
  String get couldNotOpen => 'Could not open.';

  @override
  String get onbTitle1 => 'What can you cook with what\'s home?';

  @override
  String get onbBody1 =>
      'Pick what\'s in your kitchen and we\'ll find Turkish dishes that fit.';

  @override
  String get onbTitle2 => 'Missing something? No problem.';

  @override
  String get onbBody2 =>
      'If one ingredient is missing, we\'ll tell you what to use instead.';

  @override
  String get onbTitle3 => 'Let\'s get to know you';

  @override
  String get onbBody3 => 'We\'ll tune suggestions to this.';

  @override
  String get onbStart => 'Let\'s start';

  @override
  String get onbContinue => 'Continue';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbSkipForNow => 'Skip for now';

  @override
  String get onbGoKitchen => 'Go to my kitchen';

  @override
  String get onbDietLabel => 'Diet';

  @override
  String get onbServingsLabel => 'How many of you?';

  @override
  String get startCooking => 'Start cooking';

  @override
  String get save => 'Save';

  @override
  String get cookingComingNext => 'Cooking mode is coming next.';
}

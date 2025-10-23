// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'News 24h';

  @override
  String get settingsAndMenu => 'Settings & Menu';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get switchLanguage => 'Switch Language';

  @override
  String get savedArticles => 'Saved Articles';

  @override
  String get viewHistory => 'View History';

  @override
  String get login => 'Login';

  @override
  String errorFetchingData(String message) {
    return 'Error fetching data: $message';
  }

  @override
  String get categoryTop => 'Top';

  @override
  String get categoryPolitics => 'Politics';

  @override
  String get categoryWorld => 'World';

  @override
  String get categoryBusiness => 'Business';

  @override
  String get categoryScience => 'Science';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryEntertainment2 => 'Entertainment';

  @override
  String get categoryCrime => 'Crime';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryOther => 'Real Estate';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get searchByTitle => 'Search by title...';

  @override
  String get noArticlesFound => 'No articles found.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Tin tức 24h';

  @override
  String get settingsAndMenu => 'Cài đặt & Menu';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get switchLanguage => 'Chuyển ngôn ngữ';

  @override
  String get savedArticles => 'Bài báo đã lưu';

  @override
  String get viewHistory => 'Lịch sử xem';

  @override
  String get login => 'Đăng nhập';

  @override
  String errorFetchingData(String message) {
    return 'Lỗi khi tải dữ liệu: $message';
  }

  @override
  String get categoryTop => 'Tin nóng';

  @override
  String get categoryPolitics => 'Xã hội';

  @override
  String get categoryWorld => 'Thế giới';

  @override
  String get categoryBusiness => 'Kinh tế';

  @override
  String get categoryScience => 'Khoa học';

  @override
  String get categoryEntertainment => 'Văn hóa';

  @override
  String get categorySports => 'Thể thao';

  @override
  String get categoryEntertainment2 => 'Giải trí';

  @override
  String get categoryCrime => 'Pháp luật';

  @override
  String get categoryEducation => 'Giáo dục';

  @override
  String get categoryHealth => 'Sức khỏe';

  @override
  String get categoryOther => 'Nhà đất';

  @override
  String get categoryTechnology => 'Xe cộ';
}

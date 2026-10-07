import '../constants/app_strings.dart';
import '../locale/app_locale.dart';

const _monthsAr = [
  '',
  'جانفي',
  'فيفري',
  'مارس',
  'أفريل',
  'ماي',
  'جوان',
  'جويلية',
  'أوت',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

const _monthsFr = [
  '',
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

const _monthsEn = [
  '',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

List<String> get _months {
  switch (appLocale.lang) {
    case AppLang.fr:
      return _monthsFr;
    case AppLang.en:
      return _monthsEn;
    case AppLang.ar:
      return _monthsAr;
  }
}

/// Formats a date using the current app language (ar / fr / en).
String formatDateAr(DateTime d) {
  final l = d.toLocal();
  return '${l.day} ${_months[l.month]} ${l.year}';
}

String _two(int n) => n.toString().padLeft(2, '0');

String formatSqlDateTime(DateTime d) {
  final l = d.toLocal();
  return '${l.year}-${_two(l.month)}-${_two(l.day)} ${_two(l.hour)}:${_two(l.minute)}:${_two(l.second)}';
}

String formatTimeHm(DateTime d) {
  final l = d.toLocal();
  return '${_two(l.hour)}:${_two(l.minute)}';
}

String formatChatTime(DateTime? d) {
  if (d == null) return '';
  final local = d.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return formatTimeHm(local);
  if (diff == 1) return AppStrings.yesterday;
  return formatDateAr(local);
}

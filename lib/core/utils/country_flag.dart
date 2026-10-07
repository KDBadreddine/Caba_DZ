import '../api/shared_data.dart';
import '../../models/country_model.dart';

/// ISO 3166-1 alpha-2 from a place string (country or common city name).
const _placeIso = <String, String>{
  'algeria': 'DZ',
  'algerie': 'DZ',
  'algérie': 'DZ',
  'الجزائر': 'DZ',
  'algiers': 'DZ',
  'alger': 'DZ',
  'alg': 'DZ',
  'oran': 'DZ',
  'وهران': 'DZ',
  'ora': 'DZ',
  'constantine': 'DZ',
  'قسنطينة': 'DZ',
  'france': 'FR',
  'فرنسا': 'FR',
  'paris': 'FR',
  'باريس': 'FR',
  'cdg': 'FR',
  'lyon': 'FR',
  'marseille': 'FR',
  'canada': 'CA',
  'كندا': 'CA',
  'montreal': 'CA',
  'montréal': 'CA',
  'مونتريال': 'CA',
  'yul': 'CA',
  'turkey': 'TR',
  'turkiye': 'TR',
  'türkiye': 'TR',
  'تركيا': 'TR',
  'istanbul': 'TR',
  'إسطنبول': 'TR',
  'ist': 'TR',
  'germany': 'DE',
  'allemagne': 'DE',
  'ألمانيا': 'DE',
  'frankfurt': 'DE',
  'فرانكفورت': 'DE',
  'fra': 'DE',
  'berlin': 'DE',
  'united states': 'US',
  'usa': 'US',
  'america': 'US',
  'الولايات': 'US',
  'united kingdom': 'GB',
  'uk': 'GB',
  'britain': 'GB',
  'angleterre': 'GB',
  'spain': 'ES',
  'إسبانيا': 'ES',
  'italy': 'IT',
  'إيطاليا': 'IT',
  'belgium': 'BE',
  'بلجيكا': 'BE',
  'netherlands': 'NL',
  'هولندا': 'NL',
  'tunisia': 'TN',
  'تونس': 'TN',
  'morocco': 'MA',
  'المغرب': 'MA',
  'uae': 'AE',
  'emirates': 'AE',
  'الإمارات': 'AE',
  'saudi': 'SA',
  'السعودية': 'SA',
  'qatar': 'QA',
  'قطر': 'QA',
  'china': 'CN',
  'الصين': 'CN',
  'japan': 'JP',
  'اليابان': 'JP',
};

String? getCountryIso(String? place) => countryIso2(name: place);

String? countryIso2({
  String? iso,
  int? countryId,
  String? name,
}) {
  final fromIso = _normalizeIso(iso);
  if (fromIso != null) return fromIso;

  if (countryId != null && countryId > 0) {
    final c = countryById(countryId);
    final byId = _normalizeIso(c?.iso) ?? _iso3ToIso2(c?.iso3);
    if (byId != null) return byId;
  }

  final text = name?.trim() ?? '';
  if (text.isEmpty) return null;

  final lower = text.toLowerCase();
  for (final entry in _placeIso.entries) {
    if (lower.contains(entry.key.toLowerCase()) || text.contains(entry.key)) {
      return entry.value;
    }
  }

  for (final c in countryCache) {
    final nice = c.nicename.toLowerCase();
    final en = c.name.toLowerCase();
    if (lower == nice || lower == en) return _normalizeIso(c.iso);
    if (nice.length >= 4 && lower.contains(nice)) return _normalizeIso(c.iso);
    if (en.length >= 4 && lower.contains(en)) return _normalizeIso(c.iso);
    final iso2 = c.iso.toLowerCase();
    if (iso2.length == 2 && lower == iso2) return _normalizeIso(c.iso);
    final iso3 = (c.iso3 ?? '').toLowerCase();
    if (iso3.length == 3 && lower == iso3) return _normalizeIso(c.iso);
  }
  return null;
}

CountryModel? countryFromPlace(String? raw) {
  final iso = countryIso2(name: raw);
  if (iso == null) return null;
  for (final c in countryCache) {
    if (c.iso.toUpperCase() == iso) return c;
  }
  return null;
}

String? _normalizeIso(String? iso) {
  if (iso == null) return null;
  final code = iso.trim().toUpperCase();
  if (code.length == 2 && _isLetters(code)) return code;
  if (code.length == 3) return _iso3ToIso2(code);
  return null;
}

String? _iso3ToIso2(String? iso3) {
  if (iso3 == null || iso3.trim().length != 3) return null;
  final code = iso3.trim().toUpperCase();
  for (final c in countryCache) {
    if ((c.iso3 ?? '').toUpperCase() == code) {
      return _normalizeIso(c.iso);
    }
  }
  const map = {
    'DZA': 'DZ',
    'FRA': 'FR',
    'CAN': 'CA',
    'TUR': 'TR',
    'DEU': 'DE',
    'USA': 'US',
    'GBR': 'GB',
    'ARE': 'AE',
    'SAU': 'SA',
    'QAT': 'QA',
    'TUN': 'TN',
    'MAR': 'MA',
    'ESP': 'ES',
    'ITA': 'IT',
    'BEL': 'BE',
    'NLD': 'NL',
    'CHN': 'CN',
    'JPN': 'JP',
  };
  return map[code];
}

bool _isLetters(String code) {
  for (var i = 0; i < code.length; i++) {
    final u = code.codeUnitAt(i);
    if (u < 65 || u > 90) return false;
  }
  return true;
}

String flagImageUrl(String iso2, {int width = 80}) =>
    'https://flagcdn.com/w$width/${iso2.toLowerCase()}.png';

String iso2ToEmoji(String iso2) {
  final code = iso2.toUpperCase();
  return String.fromCharCodes([
    0x1F1E6 + (code.codeUnitAt(0) - 0x41),
    0x1F1E6 + (code.codeUnitAt(1) - 0x41),
  ]);
}

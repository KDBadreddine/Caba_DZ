import '../../models/country_model.dart';
import '../../models/user_model.dart';

UserModel? userInfo;

List<CountryModel> countryCache = [];

UserModel get currentUser => userInfo ?? UserModel.empty();

CountryModel? countryById(int id) {
  for (final c in countryCache) {
    if (c.id == id) return c;
  }
  return null;
}

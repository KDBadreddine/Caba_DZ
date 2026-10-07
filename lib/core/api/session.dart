import 'package:shared_preferences/shared_preferences.dart';

import 'shared_data.dart';

const kUserIdKey = 'caba_user_id';

Future<void> saveSession(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(kUserIdKey, userId);
}

Future<void> clearSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(kUserIdKey);
  userInfo = null;
}

Future<String?> readSavedUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(kUserIdKey);
}
